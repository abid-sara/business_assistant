import 'package:business_assistant/database/db_helper.dart';
import 'package:business_assistant/database/db_utility.dart';
import 'package:business_assistant/database/db_product.dart';
import 'package:business_assistant/database/db_product.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:business_assistant/models/income.dart';
import 'package:business_assistant/models/order.dart';
import 'package:business_assistant/models/customer.dart';

Future<List<Income>> showIncome() async {
  final database = await DBHelper.getDatabase();

  try {
    List<Map<String, dynamic>> data = await database.query(
      'Income',
      where: 'deleted = ?',
      whereArgs: [0],
    );

    // Convert the List<Map> into a List of Income objects
    List<Income> incomeList = [];
    for (var map in data) {
      // Fetch the corresponding Order object
      List<Map<String, dynamic>> orderData = await database.query(
        'Order',
        where: 'id = ?',
        whereArgs: [map['order_id']],
      );

      if (orderData.isNotEmpty) {
        // Fetch the corresponding Customer object
        List<Map<String, dynamic>> customerData = await database.query(
          'Customer',
          where: 'id = ?',
          whereArgs: [orderData.first['customer_id']],
        );

        if (customerData.isNotEmpty) {
          Customer customer = Customer.fromMap(customerData.first);
          Order order = Order.fromMap(orderData.first, customer);
          incomeList.add(Income.fromMap(map, order));
        }
      }
    }

    return incomeList;
  } catch (e) {
    print("Error selecting from Income: $e");
    return [];
  }
}

Future<bool> deleteIncome(int incomeId) async {
  try {
    //delete
    DBAssistant.delete("Income", incomeId);
    return true;
  } catch (e) {
    print("Error deleting the income");
    return false;
  }
}


Future<bool> insertIncome(Income income) async {
  try {
    // Convert the Income object to a Map, ensuring the DateTime is converted to a string
    Map<String, dynamic> data = income.toMap();

    int result = await DBAssistant.insert("Income", data);
    print('Inserted income with ID: $result'); // Debugging line

    return result > 0;
  } catch (e) {
    print("Error inserting the income: $e");
    return false;
  }
}



