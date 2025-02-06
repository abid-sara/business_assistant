import 'package:business_assistant/database/db_helper.dart';
import 'package:business_assistant/database/db_utility.dart';
import 'package:business_assistant/models/product.dart';

Future<List<Map<String, dynamic>>> showProducts() async {
  final database = await DBHelper.getDatabase();

  try {
    return await database.query(
      'Product',
      where: 'deleted = ?',
      whereArgs: [0], //deleted is false so show the orders
    );
  } catch (e) {
    print("Error selecting from Order: $e");
    return [];
  }
}

Future<Map<String, dynamic>> getOneProduct(int productId) async {
  final database = await DBHelper.getDatabase();

  try {
    final result = await database.query(
      'Product',
      where: 'deleted = ? AND id = ?',
      whereArgs: [
        0,
        productId
      ], //show the order specified by the id if it is not deleted
    );

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return {};
    }
  } catch (e) {
    print("Error selecting from Order: $e");
    return {};
  }
}

Future<bool> addProduct({required Map<String, dynamic> product}) async {
  try {
    await DBAssistant.insert("Product", product);
    return true;
  } catch (e) {
    print("error adding the product");
    return false;
  }
}

Future<bool> deleteProduct(int? productId) async {
  try {
    await DBAssistant.delete("Product", productId!);
    return true;
  } catch (e) {
    print("error deleting the product");
    return false;
  }
}

Future<bool> editProduct(
    int? productId, Map<String, dynamic> productUpdated) async {
  try {
    await DBAssistant.update("Product", productId!, productUpdated);
    print("update done");
    return true;
  } catch (e) {
    print("error updating the product");
    return false;
  }
}

Future<int> getQuantity(int productID) async {
  final database = await DBHelper.getDatabase();

  try {
    final result = await database.query(
      'Product',
      columns: ['quantity'],
      where: 'id = ?',
      whereArgs: [productID],
    );
    if (result.isNotEmpty) {
      return result.first['quantity'] as int;
    }
    return -1; //if the product is not found return -1
  } catch (e) {
    print("Error selecting from Product: $e");
    return -2; //return -2 for error
  }
}

Future<bool> checkQuantityIfAdded(int productID, int newQuantity) async {
  int oldQuantity = await getQuantity(productID);
  if (oldQuantity == -1 || oldQuantity == -2) {
    print("Error fetching old quantity");
    return false;
  }
  return newQuantity > oldQuantity;
}

Future<List<Product>> displayProduct() async {
  final database = await DBHelper.getDatabase();

  try {
    final List<Map<String, dynamic>> productData = await database.query(
      'Product',
      where: 'deleted = ?',
      whereArgs: [0], // Fetch only non-deleted products
    );
    return productData.map((map) => Product.fromMap(map)).toList();
  } catch (e) {
    print("Error selecting from Product: $e");
    return [];
  }
}
