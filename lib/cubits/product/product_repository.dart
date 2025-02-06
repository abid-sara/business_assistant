import '/models/product.dart';
import '/database/db_product.dart';

class ProductRepository {
  Future<List<Product>> getProductsRepo() async {
    List<Map<String, dynamic>> productMaps = await showProducts();
    return productMaps.map((map) => Product.fromMap(map)).toList();
  }

  Future<void> addProductRepo(Product product) async {
    Map<String, dynamic> productData = product.toMap();
    await addProduct(product: productData);
  }

  Future<void> deleteProductRepo(int? id) async {
    await deleteProduct(id);
  }

  Future<void> updateProductRepo(int? id, Product product) async {
    Map<String, dynamic> productData = product.toMap();

    await editProduct(id, productData);
  }

  Future<Product> getProductByIdRepo(int? id) async {
    Map<String, dynamic> productData = await getOneProduct(id!);
    return Product.fromMap(productData);
  }
}
