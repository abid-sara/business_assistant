// ignore_for_file: avoid_print

import 'package:business_assistant/database/db_helper.dart';
import 'package:business_assistant/database/db_utility.dart';
import 'package:business_assistant/database/db_product.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:business_assistant/models/order.dart';
import 'package:business_assistant/models/customer.dart';

Future<List<Map<String, dynamic>>> showOrders() async {
  final database = await DBHelper.getDatabase();
  try {
    return await database.query(
      'Order',
      where: 'deleted = ?',
      whereArgs: [0], // Show only non-deleted orders
    );
  } catch (e) {
    print("Error selecting from Order: $e");
    return [];
  }
}

Future<String> getOrderStatus(int orderId) async {
  final database = await DBHelper.getDatabase();
  try {
    final queryResult = await database.rawQuery(
      "SELECT status from 'Order' WHERE id = ?",
      [orderId],
    );
    final result = queryResult.first["status"] as String;

    print("result in db_order: " + result);
    return result;
  } catch (e) {
    print("Error selecting from Order: $e");
    return "";
  }
}

Future<bool> deleteOrder(int orderId, int customerId) async {
  final database = await DBHelper.getDatabase();
  try {
    await database.update(
      'Order',
      {'deleted': 1},
      where: 'id = ?',
      whereArgs: [orderId],
    );
    print("updated the delete ");
    // Decrement customer order count
    await decrementCustomerCount(customerId);

    return true;
  } catch (e) {
    print("Error deleting the order: $e");
    return false;
  }
}

Future<bool> decrementCustomerCount(int customerId) async {
  final database = await DBHelper.getDatabase();
  try {
    // Fetch the customer record
    final List<Map<String, dynamic>> customers = await database.query(
      'Customer',
      where: 'id = ?',
      whereArgs: [customerId],
    );

    if (customers.isNotEmpty) {
      int count = (customers.first['count'] ?? 0) - 1;

      // Ensure the count doesn't go below zero
      if (count < 0) count = 0;

      // Update the customer's order count
      await database.update(
        'Customer',
        {'count': count},
        where: 'id = ?',
        whereArgs: [customerId],
      );
    }
    return true;
  } catch (e) {
    print("Error decrementing customer count: $e");
    return false;
  }
}

Future<Map<String, dynamic>> getOneCustomer(int? customerId) async {
  final database = await DBHelper.getDatabase();
  try {
    final result = await database.query(
      'Customer',
      where: 'id = ? AND deleted = ?',
      whereArgs: [customerId, 0],
    );
    if (result.isEmpty) {
      throw Exception('Customer not found');
    }
    return result.first;
  } catch (e) {
    print("Error selecting customer: $e");
    return {};
  }
}

Future<int> addOrder({
  required Map<String, dynamic> order,
  required List<Map<String, dynamic>> products,
}) async {
  final database = await DBHelper.getDatabase();
  try {
    // Validate customer existence
    final customer = await database.query(
      'Customer',
      where: 'id = ? AND deleted = 0',
      whereArgs: [order["customer_id"]],
    );
    if (customer.isEmpty) {
      print('Error: Customer not found or deleted.');
      return -1;
    }

    final int orderId = await database.insert('Order', order);

    if (orderId <= 0) {
      print('Error: Failed to insert order.');
      return -2;
    }

    print('Order added with ID: $orderId.');

    // Link products to the order
    for (final product in products) {
      final productId =
          product['product']?.id; // Ensure the product ID is extracted
      final quantity = product['quantity'];

      if (productId == null || quantity == null) {
        print('Invalid product data: $product');
        continue; // Skip invalid products
      }

      print(
          'Linking product_id: $productId with quantity: $quantity to order_id: $orderId');
      await database.insert('OrderProduct', {
        'order_id': orderId,
        'product_id': productId,
        'quantity': quantity,
      });
    }

    return orderId;
  } catch (e) {
    print("Error adding order: $e");
    return -99;
  }
}

Future<double> _validateAndCalculateTotalPrice(
    List<Map<String, dynamic>> products) async {
  double totalPrice = 0.0;

  for (var productInfo in products) {
    int productId = productInfo['id'];
    int quantity = productInfo['quantity'];

    // Fetch product details
    Map<String, dynamic>? product = await getOneProduct(productId);

    if (product.isEmpty) {
      print('Product with ID $productId not found');
      return -1; // Product not found
    }

    int availableQuantity = product['quantity'];
    double price = product['unit_price'];

    if (availableQuantity < quantity) {
      print('Insufficient quantity for product ID $productId');
      return -2; // Insufficient quantity
    }

    totalPrice += price * quantity;
  }

  return totalPrice;
}

Future<List<Map<String, dynamic>>> displayCustomerOrders(
    int? customerId) async {
  final db = await DBHelper.getDatabase();

  final List<Map<String, dynamic>> orders = await db.rawQuery('''
      SELECT 
        o.*,
        c.id as customer_id,
        c.name as customer_name,
        c.address as customer_address,
        c.phone_num as customer_phone_num,
        c.email as customer_email,
        c.note as customer_note,
        c.deleted as customer_deleted
      FROM "Order" o
      INNER JOIN "Customer" c ON o.customer_id = c.id
      WHERE o.customer_id = ? 
      AND o.deleted = 0
      ORDER BY o.order_date DESC
    ''', [customerId]);

  // Transform the flat query result into nested objects
  return orders.map((order) {
    // Extract customer data
    final customerData = {
      'id': order['customer_id'],
      'name': order['customer_name'],
      'address': order['customer_address'],
      'phone_num': order['customer_phone_num'],
      'email': order['customer_email'],
      'note': order['customer_note'],
      'deleted': order['customer_deleted'],
    };

    // Remove customer fields from the main order object
    final orderData = Map<String, dynamic>.from(order)
      ..removeWhere((key, value) => key.startsWith('customer_'));

    // Add the customer object back
    orderData['customer'] = customerData;

    return orderData;
  }).toList();
}

Future<List<Order>> displayOrder() async {
  final database = await DBHelper.getDatabase();
  try {
    final List<Map<String, dynamic>> orderData = await database.query(
      'Order',
      where: 'deleted = ?',
      whereArgs: [0], // Fetch only non-deleted customers
    );
    
    List<Order> orders = [];
    for (var map in orderData) {
      final int customerId = map['customer_id'];

      final Map<String, dynamic> customerData =
          await getOneCustomer(customerId);

      if (customerData.isEmpty) {
        print("Warning: Customer not found for order ${map['id']}");
        continue;
      }

      final customer = Customer.fromMap(customerData);

      final order = Order.fromMap(map, customer);
      orders.add(order);
    }
    print("Successfully processed ${orders.length} orders");
    return orders;
  } catch (e) {
    print("Error fetching orders: $e");
    return [];
  }
}

Future<int> _insertOrder(
    Database database, Map<String, dynamic> order, double totalPrice) async {
  return await database.insert('Order', {
    'price': totalPrice,
    'status': order["status"],
    'deleted': 0,
    'order_date': order["order_date"], // Fix key names to match `orderData`
    'delivery_date': order["delivery_date"],
    'delivery_address': order["delivery_address"],
    'delivery_price': order["delivery_price"],
    'customer_id': order["customer_id"], // Ensure correct key
  });
}

Future<void> _linkProductsToOrder(
    Database database, int orderId, List<Map<String, dynamic>> products) async {
  for (var productInfo in products) {
    await database.insert('OrderProduct', {
      'order_id': orderId,
      'product_id': productInfo['id'],
      'quantity': productInfo['quantity'],
    });
  }
}

Future<void> _updateProductQuantities(
    Database database, List<Map<String, dynamic>> products) async {
  for (var productInfo in products) {
    int productId = productInfo['id'];
    int quantity = productInfo['quantity'];

    // Fetch current product details
    final product = await database.query(
      'Product',
      where: 'id = ?',
      whereArgs: [productId],
    );

    if (product.isNotEmpty) {
      int newQuantity = ((product.first['quantity'] ?? 0) as int) - quantity;

      // Update the product's quantity
      await database.update(
        'Product',
        {'quantity': newQuantity},
        where: 'id = ?',
        whereArgs: [productId],
      );
    }
  }
}

Future<void> incrementCustomerOrderCount(
    Database database, int? customerId) async {
  final customer = await database.query(
    'Customer',
    where: 'id = ?',
    whereArgs: [customerId],
  );

  if (customer.isNotEmpty) {
    int count = (customer.first['count'] ?? 0) as int;
    count += 1;

    await database.update(
      'Customer',
      {'count': count},
      where: 'id = ?',
      whereArgs: [customerId],
    );
  }
}

// function to get he customer name
Future<String> getCustomerName(int? customerId) async {
  final database = await DBHelper.getDatabase();
  try {
    final result = await database.query(
      'Customer',
      where: 'id = ?',
      whereArgs: [customerId],
    );
    return result.isNotEmpty ? result.first['name'] : '';
  } catch (e) {
    print("Error selecting customer: $e");
    return '';
  }
}

//update the order satatus
Future<bool> updateOrderStatus(int orderId, String status) async {
  final database = await DBHelper.getDatabase();
  try {
    await database.update(
      'Order',
      {'status': status},
      where: 'id = ?',
      whereArgs: [orderId],
    );
    return true;
  } catch (e) {
    print("Error updating order status: $e");
    return false;
  }
}

//get total with delivery
Future<double> getTotalWithDelivery(int orderId) async {
  final database = await DBHelper.getDatabase();
  try {
    final result = await database.query(
      'Order',
      where: 'id = ?',
      whereArgs: [orderId],
    );

    if (result.isNotEmpty) {
      return (result.first['price'] + result.first['delivery_price']);
    }
    return 0.0;
  } catch (e) {
    print("Error selecting order: $e");
    return 0.0;
  }
}

//get products for order
Future<List<Map<String, dynamic>>> getProductsForOrder(int orderId) async {
  final database = await DBHelper.getDatabase();
  try {
    final result = await database.rawQuery('''
    SELECT p.id, p.name, p.unit_price, op.quantity
    FROM 'OrderProduct' op
    JOIN 'Product' p ON op.product_id = p.id
    WHERE op.order_id = ?
    ''', [orderId]);

    print(result);

    return result;
  } catch (e) {
    print("Error selecting products for order: $e");
    return [];
  }
}
