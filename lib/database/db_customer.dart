// ignore_for_file: avoid_print

import 'package:business_assistant/database/db_order.dart';
import 'package:business_assistant/database/db_utility.dart';
import 'package:business_assistant/database/db_helper.dart';
import 'package:business_assistant/models/order.dart';
import 'package:business_assistant/models/customer.dart';

/// Show all customers that are not marked as deleted
Future<List<Customer>> showCustomers() async {
  try {
    final database =
        await DBHelper.getDatabase(); // Ensure database initialization
    final List<Map<String, dynamic>> customerData = await database.query(
      'Customer',
      where: 'deleted = ?',
      whereArgs: [0], // Fetch only non-deleted customers
    );
    print(customerData.map(Customer.fromMap).toList());
    return customerData.map(Customer.fromMap).toList();
  } catch (e) {
    print("Error fetching customers: $e");
    return [];
  }
}

/// Get the number of orders for a customer
Future<int> getOrdersCountForCustomer(int customerId) async {
  try {
    final orders = await getOrdersForCustomer(customerId);
    return orders.length;
  } catch (e) {
    print("Error fetching order count for customer: $e");
    return 0;
  }
}

/// Mark a customer as deleted
Future<bool> deleteCustomer(int? customerId) async {
  try {
    final database =
        await DBHelper.getDatabase(); // Ensure database initialization
    await database.update(
      'Customer',
      {'deleted': 1},
      where: 'id = ?',
      whereArgs: [customerId!],
    );
    return true;
  } catch (e) {
    print("Error deleting customer: $e");
    return false;
  }
}

/// Insert a new customer into the database
Future<int> insertCustomer(Map<String, dynamic> customerData) async {
  try {
    final database = await DBHelper.getDatabase();
    final id = await database.insert('Customer', customerData);
    return id;
  } catch (e) {
    print("Error inserting customer: $e");
    return -1;
  }
}

/// Get a customer by ID (excluding deleted ones)
Future<Map<String, dynamic>> getCustomerById(int customerId) async {
  try {
    final database =
        await DBHelper.getDatabase(); // Ensure database initialization
    final result = await database.query(
      'Customer',
      where: 'id = ? AND deleted = 0',
      whereArgs: [customerId],
    );
    return result.isNotEmpty ? result.first : {};
  } catch (e) {
    print("Error selecting Customer: $e");
    return {};
  }
}

/// Fetch orders for a customer
Future<List<Order>> getOrdersForCustomer(int customerId) async {
  try {
    final database = await DBHelper.getDatabase();
    final List<Map<String, dynamic>> result = await database.query(
      'Order',
      where: 'customer_id = ? AND deleted = ?',
      whereArgs: [customerId, 0],
    );
    final customerData = await getOneCustomer(customerId);
    final Customer customer = Customer.fromMap(customerData);

    return (result.map((orderMap) => Order.fromMap(orderMap, customer)))
        .toList();
  } catch (e) {
    print("Error fetching orders for customer: $e");
    return [];
  }
}

/// Update an existing customer in the database
Future<bool> updateCustomer(Customer customer) async {
  try {
    final database = await DBHelper.getDatabase();

    if (customer.id == null) {
      return false;
    }

    int rowsAffected = await database.update(
      'Customer',
      customer.toMap(),
      where: 'id = ?',
      whereArgs: [customer.id],
    );

    return rowsAffected > 0;
  } catch (e) {
    print("Error updating customer: $e");
    return false;
  }
}

Future<List<String>> getCustomerNames() async {
  final db = await DBHelper.getDatabase();
  final List<Map<String, dynamic>> result = await db.query(
    'Customer',
    columns: ['name'],
    where: 'deleted = ?',
    whereArgs: [0],
  );
  return result.map((map) => map['name'] as String).toList();
}

Future<List<Customer>> displayCustomer() async {
  try {
    final database =
        await DBHelper.getDatabase(); // Ensure database initialization
    final List<Map<String, dynamic>> customerData = await database.query(
      'Customer',
      where: 'deleted = ?',
      whereArgs: [0], // Fetch only non-deleted customers
    );
    return customerData.map(Customer.fromMap).toList();
  } catch (e) {
    print("Error fetching customers: $e");
    return [];
  }
}
