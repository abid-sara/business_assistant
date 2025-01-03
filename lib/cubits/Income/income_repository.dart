import 'package:business_assistant/models/customer.dart';
import 'package:business_assistant/models/order.dart';
import 'package:business_assistant/models/income.dart';
import 'package:business_assistant/database/db_helper.dart';

class IncomeRepository {
  Future<List<Income>> getIncome() async {
    final database = await DBHelper.getDatabase();
    final List<Map<String, dynamic>> maps = await database.query('Income');
    print('Income maps: $maps'); 

    List<Income> incomeList = [];
    for (var map in maps) {
      
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
  }

  Future<int?> insertIncome(Income income) async {
  final database = await DBHelper.getDatabase();
  final result = await database.insert('Income', income.toMap());

  // Set the ID after insertion if it's null
  if (income.id == null) {
    income.id = result;  // Set the ID after insertion
  }

  print('Inserted income with ID: $result'); // Debugging line
  print('Income object: $income'); // Debugging line
  print('Income object: ${income.toMap()}'); // Debugging line
  return result;
}


  Future<double> calculateTotalIncome() async {
    final database = await DBHelper.getDatabase();
    final result = await database.rawQuery('SELECT SUM(amount) as total FROM Income');
    return result.first['total'] ?? 0.0;
  }

  Future<List<Income>> getLatestIncome(int limit) async {
    final database = await DBHelper.getDatabase();
    final List<Map<String, dynamic>> maps = await database.query(
      'Income',
      orderBy: 'date DESC',
      limit: limit,
    );
    print('Latest income: $maps'); // Debugging line

    List<Income> incomeList = [];
    for (var map in maps) {
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
          print('Income object: ${Income.fromMap(map, order)}'); // Debugging line
        }
      }
    }

    return incomeList;
  }

  Future<Map<String, double>> getIncomeGroupedByDate() async {
    final database = await DBHelper.getDatabase();
    final List<Map<String, dynamic>> maps = await database.query('Income');
    print('Income maps: $maps'); // Debugging line

    Map<String, double> incomeMap = {};
    for (var map in maps) {
      final date = map['date'].split('T')[0]; // Extract date part
      final amount = map['amount'] as double;
      if (incomeMap.containsKey(date)) {
        incomeMap[date] = incomeMap[date]! + amount;
      } else {
        incomeMap[date] = amount;
      }
    }
    print('Income map: $incomeMap'); // Debugging line

    return incomeMap;
  }
}