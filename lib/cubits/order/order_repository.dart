import 'package:business_assistant/database/db_helper.dart';
import 'package:business_assistant/database/db_order.dart';
import 'package:business_assistant/models/order.dart';

import '../../models/customer.dart';

class OrderRepository {

  
  Future<List<Order>> fetchOrders() async {
    try {
      return await displayOrder();
    } catch (e) {
      throw Exception('Failed to fetch orders: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getProductsForOrderRepo(
      int orderId) async {
    try {
      return await getProductsForOrder(orderId);
    } catch (e) {
      throw Exception('Failed to fetch order products: $e');
    }
  }

  Future<double> getTotalWithDeliveryRepo(int orderId) async {
    try {
      return await getTotalWithDelivery(orderId);
    } catch (e) {
      throw Exception('Failed to calculate total with delivery: $e');
    }
  }

  Future<String> getOrderStatusRespo(int orderId) async {
    try {
      return await getOrderStatus(orderId);
    } catch (e) {
      throw Exception('Failed to get the status of the order: $e');
    }
  }

  Future<bool> updateOrderStatusRepo(int orderId) async {
    try {
      final status = await getOrderStatusRespo(orderId);
      if (status == "delivered") {
        return await updateOrderStatus(orderId, "pending");
      } else {
        return await updateOrderStatus(orderId, "delivered");
      }
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }

  Future<bool> deleteOrderRepo(int orderId, int customerId) async {
    try {
      return await deleteOrder(orderId, customerId);
    } catch (e) {
      throw Exception('Failed to delete order: $e');
    }
  }

  Future<int> addOrderRepo({
    required Map<String, dynamic> order,
    required List<Map<String, dynamic>> products,
  }) async {
    try {
      final orderId = await addOrder(
        order: order,
        products: products,
      );

      if (orderId < 0) {
        switch (orderId) {
          case -1:
            throw Exception('Customer not found or deleted');
          case -2:
            throw Exception('Failed to insert order');
          case -99:
            throw Exception('Unknown error occurred while adding order');
          default:
            throw Exception('Failed to add order with error code: $orderId');
        }
      }

      return orderId;
    } catch (e) {
      throw Exception('Failed to add order: $e');
    }
  }

  Future<String> getCustomerNameRepo(int customerId) async {
    try {
      return await getCustomerName(customerId);
    } catch (e) {
      throw Exception('Failed to get customer name: $e');
    }
  }

  Future<List<Order>> fetchCustomerOrders(int? customerId) async {
    final orders = await displayCustomerOrders(customerId);
    Customer customer = Customer.fromMap(await getOneCustomer(customerId));
    return orders.map((map) => Order.fromMap(map, customer)).toList();
  }


  Future<Order?> getOrderById(int id) async {
    final database = await DBHelper.getDatabase();
    final List<Map<String, dynamic>> maps = await database.query(
      'Order',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      // Fetch the corresponding Customer object
      final List<Map<String, dynamic>> customerData = await database.query(
        'Customer',
        where: 'id = ?',
        whereArgs: [maps.first['customer_id']],
      );

      if (customerData.isNotEmpty) {
        final customer = Customer.fromMap(customerData.first);
        return Order.fromMap(maps.first, customer);
      }
    }
    
  } 
  Future<Order?> getLatestOrder({required String orderDate, required int customerId}) async {
  final database = await DBHelper.getDatabase();
  
  // Query the latest order based on order_date and customer_id
  final List<Map<String, dynamic>> maps = await database.query(
    'Order',
    where: 'order_date = ? AND customer_id = ?',
    whereArgs: [orderDate, customerId],
    orderBy: 'id DESC', // Fetch the order with the highest ID
    limit: 1, // Only return one order
  );

  // Check if an order was found
  if (maps.isNotEmpty) {
    // Fetch the associated customer object
    final List<Map<String, dynamic>> customerData = await database.query(
      'Customer',
      where: 'id = ?',
      whereArgs: [maps.first['customer_id']],
    );

    if (customerData.isNotEmpty) {
      final customer = Customer.fromMap(customerData.first);
      return Order.fromMap(maps.first, customer); // Map order and customer data
    }
  }

  return null; // Return null if no order was found
}

}
