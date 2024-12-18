// ignore_for_file: avoid_print

import 'package:business_assistant/database/db_helper.dart';
import 'package:business_assistant/database/db_utility.dart';
import 'package:business_assistant/database/db_product.dart';
import 'package:sqflite/sqlite_api.dart';

Future<List<Map<String, dynamic>>> showOrders() async {
  final database = await DBHelper.getDatabase();

  try {
    return await database.query(
      'Order',
      where: 'deleted = ?',
      whereArgs: [0], //deleted is false so show the orders
    );
  } catch (e) {
    print("Error selecting from Order: $e");
    return [];
  }
}

Future<bool> deleteOrder(int orderId, int customerId) async {
  try {
    //delete
    DBAssistant.delete("Order", orderId);
    // update the customer count
    decrementCustomerCount(customerId);
    return true;
  } catch (e) {
    print("error deleting the order");
    return false;
  }
}

Future<bool> decrementCustomerCount(int customerId) async {
  /*This function will be added to the db_customer */
  Map<String, dynamic> customer = await getOneCustomer(customerId);

  try {
    int count = customer['count'];
    count -= 1; //update the count of the customer to -1
    Map<String, dynamic> dataCutomer = {
      //prepare data for function
      "count": count
    };
    //write to db the updated value
    return DBAssistant.update("Customer", customerId, dataCutomer);
  } catch (e) {
    print("Error decrementing the counter of the customer: $e");

    return false;
  }
}

Future<Map<String, dynamic>> getOneCustomer(int customerID) async {
  /*This function will be added to the db_customer */
  try {
    return await DBHelper.database.query(
      'Customer',
      where: 'id = ?',
      whereArgs: [customerID],
    );
  } catch (e) {
    print("Error selecting from Customer: $e");
    return {};
  }
}

Future<int> addIncome(int orderId) async {
  /*this function should be added to the db_income */
  Map<String, dynamic> order = await getOneOrder(orderId);

  if (order.isEmpty) {
    print('Order not found');
    return -1; // Order not found, return error code
  }

  Map<String, dynamic> data = {
    "order_id": orderId,
    "price": order["price"] + order["delivery_price"],
  };
  return DBAssistant.insert("Income", data);
}

Future<Map<String, dynamic>> getOneOrder(int orderId) async {
  try {
    return await DBHelper.database.query(
      'Order',
      where: 'id = ?',
      whereArgs: [orderId],
    );
  } catch (e) {
    print("Error selecting from Order: $e");
    return {};
  }
}

Future<int> addOrder({
  required Map<String, dynamic> order,
  required List<Map<String, dynamic>> products,
}) async {
  final database = await DBHelper.getDatabase();

  // Step 1: Validate products and calculate total price
  double totalPrice = await _validateAndCalculateTotalPrice(products);
  if (totalPrice < 0) return -1; // Invalid product(s) or insufficient quantity

  // Step 2: Insert order into the database
  final int orderId = await _insertOrder(database, order, totalPrice);

  // Step 3: Link products to the order
  await _linkProductsToOrder(database, orderId, products);

  // Step 4: Update product quantities
  await _updateProductQuantities(database, products);

  // Step 5: Update customer order count
  await _incrementCustomerOrderCount(database, order["customerId"]);

  print('Order added successfully');
  return orderId;
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
    double price = product['price'];

    if (availableQuantity < quantity) {
      print('Insufficient quantity for product ID $productId');
      return -2; // Insufficient quantity
    }

    totalPrice += price * quantity; // Add product price to total
  }

  return totalPrice;
}

Future<int> _insertOrder(
    Database database, Map<String, dynamic> order, double totalPrice) async {
  return await database.insert('Order', {
    'price': totalPrice,
    'status': order["status"],
    'deleted': 0,
    'order_date': order["orderDate"],
    'delivery_date': order["deliveryDate"],
    'delivery_address': order["deliveryAddress"],
    'delivery_price': order["deliveryPrice"],
    'customer_id': order["customerId"],
  });
}

Future<void> _linkProductsToOrder(
    Database database, int orderId, List<Map<String, dynamic>> products) async {
  for (var productInfo in products) {
    await database.insert('OrderProduct', {
      'order_id': orderId,
      'product_id': productInfo['product_id'],
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
    Map<String, dynamic>? product = await getOneProduct(productId);
    if (product.isNotEmpty) {
      int newQuantity = product['quantity'] - quantity;

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

Future<void> _incrementCustomerOrderCount(
    Database database, int customerId) async {
  // Fetch customer details
  List<Map<String, dynamic>> customer = await database.query(
    'Customer',
    where: 'id = ?',
    whereArgs: [customerId],
  );

  if (customer.isNotEmpty) {
    int currentCount = customer.first['count'];
    int updatedCount = currentCount + 1;

    // Update the customer's order count
    await database.update(
      'Customer',
      {'count': updatedCount},
      where: 'id = ?',
      whereArgs: [customerId],
    );
  }
}

Future<bool> updateOrderStatus(int orderId) async {
  try {
    String oldStatus = await getOrderStatus(orderId);
    String status = oldStatus == "pending" ? "delivered" : "pending";

    return await DBHelper.database.update(
      'Order',
      {'status': status},
      where: 'id = ?',
      whereArgs: [orderId],
    );
  } catch (e) {
    print("Error updating the order status: $e");
    return false;
  }
}

Future<String> getOrderStatus(int orderId) async {
  try {
    return await DBHelper.database
        .rawQuery('''SELECT status FROM Order WHERE id = ?''', [orderId]);
  } catch (e) {
    print("Error getting the status from Order: $e");
    return "";
  }
}


Future<String> getCustomerName(int customerId) async{
  try {
    return await DBHelper.database
        .rawQuery('''SELECT name FROM Customer WHERE id = ?''', [customerId]);
  } catch (e) {
    print("Error getting the status from Order: $e");
    return "";
  }
}