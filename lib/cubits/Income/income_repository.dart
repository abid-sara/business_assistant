import 'package:business_assistant/models/income.dart';
import 'package:business_assistant/database/db_helper.dart';

class IncomeRepository {
  // Method to fetch all income records
  Future<List<Income>> getIncome() async {
    final database = await DBHelper.getDatabase();
    final List<Map<String, dynamic>> incomeMaps = await database.query('Income');

    print('Income maps: $incomeMaps'); // Debugging line

    // Convert the list of maps into a list of Income objects
    return incomeMaps.map((map) => Income.fromMap(map)).toList();
  }

  // Method to insert income record
  Future<int?> insertIncome(Income income) async {
    final database = await DBHelper.getDatabase();
    return await database.insert('Income', income.toMap());
  }
}
