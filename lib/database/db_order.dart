import 'package:business_assistant/database/db_helper.dart';
import 'package:business_assistant/database/db_utility.dart';

Future<List<Map<String, dynamic>>> showOrders() async {
  final database = await DBHelper.getDatabase();

  try {
    return await database.query(
      'Order',
      where: 'deleted == ?',
      whereArgs: [0], //deleted is false so show the orders
    );
  } catch (e) {
    print("Error selecting from Order: $e");
    return [];
  }
}

Future<int> addOrder({
  required int productId,
  required int customerId,
  required int quantity,
  required String status,
  required String deliveryAddress,
  required String orderDate,
  required String deliveryDate,
  required double deliveryPrice,
}) async {
  final database = await DBHelper.getDatabase();

  // Fetch product to check quantity and price
  List<Map<String, dynamic>> product = await database.query(
    'Product',
    where: 'id = ?',
    whereArgs: [productId],
  );

  if (product.isEmpty) {
    // Product not found, return -1
    print('Product not found');
    return -1;
  }

  int availableQuantity = product.first['quantity'];
  double price = product.first['price'];

  // Check if sufficient quantity is available
  if (availableQuantity < quantity) {
    // Insufficient quantity in inventory, return -2
    print('Insufficient quantity in inventory');
    return -2;
  }

  // Everything is good, proceed with the order
  final orderId = await database.insert('Order', {
    'price': price * quantity, // Calculate total price
    'status': status,
    'deleted': 0,
    'order_date': orderDate,
    'delivery_date': deliveryDate,
    'delivery_address': deliveryAddress,
    'delivery_price': deliveryPrice,
    'customer_id': customerId,
  });

  // Insert the product and its quantity into the 'OrderProduct' table
  await database.insert('OrderProduct', {
    'order_id': orderId,
    'product_id': productId,
    'quantity': quantity,
  });

  // Update the product's quantity in the 'Product' table
  await database.update(
    'Product',
    {'quantity': availableQuantity - quantity},
    where: 'id = ?',
    whereArgs: [productId],
  );

  print('Order added successfully');

  //update the customers count
  // Fetch customer to get the previous count
  List<Map<String, dynamic>> customer = await database.query(
    'Customer',
    where: 'id = ?',
    whereArgs: [customerId],
  );
  int count = customer.first['count'];
  count += 1; //update the count of the customer to +1
  Map<String, dynamic> dataCutomer = {
    //prepare data for function
    "count": count
  };
  //write to db the updated value
  DBAssistant.update("Customer", customerId, dataCutomer);

  return 1; // Return 1 to indicate successful order addition
}

Future<int> deleteOrder(int orderId, int customerId) async {
  try {
    DBAssistant.delete("Order", orderId);
    // Fetch customer to get the previous count
    List<Map<String, dynamic>> customer = await DBHelper.database.query(
      'Customer',
      where: 'id = ?',
      whereArgs: [customerId],
    );

    int count = customer.first['count'];
    count -= 1; //update the count of the customer to +1
    Map<String, dynamic> dataCutomer = {
      //prepare data for function
      "count": count
    };
    //write to db the updated value
    DBAssistant.update("Customer", customerId, dataCutomer);
    return 1;
  } catch (e) {
    print("error deleting the order");
    return 0;
  }
}

Future<int> addIncome(int orderId, int price) async {
  List<Map<String, dynamic>> order = await DBHelper.database.query(
    'Order',
    where: 'id = ?',
    whereArgs: [orderId],
  );

  if (order.isEmpty) {
    print('Order not found');
    return -1; // Order not found, return error code
  }

  Map<String, dynamic> data = {
    "order_id": orderId,
    "price": price,
  };
  return DBAssistant.insert("Income", data);
}
