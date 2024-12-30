import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_state.dart';
import 'product_repository.dart';
import '../../models/product.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository repository;

  List<Product> products = [];

  ProductCubit(this.repository) : super(ProductInitial()) {
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    emit(ProductLoading());
    try {
      products = await repository.getProductsRepo();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError('Failed to fetch products: $e'));
    }
  }

  void addProduct(Product product) async {
    try {
      await repository.addProductRepo(product);
      products.add(product);
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError('Failed to add product: $e'));
    }
  }

  void deleteProduct(int? id) async {
    try {
      await repository.deleteProductRepo(id);
      products.removeWhere((product) => product.id == id);
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError('Failed to delete product: $e'));
    }
  }

  void updateProduct(int? id, Product updatedProduct) async {
    try {
      await repository.updateProductRepo(id, updatedProduct);

      final index = products.indexWhere((product) => product.id == id);

      if (index != -1) {
        products[index] = updatedProduct;
        emit(ProductUpdated(updatedProduct));
        emit(ProductLoaded(List<Product>.from(products)));
      } else {
        emit(ProductError('Product with ID $id not found.'));
      }
    } catch (e) {
      emit(ProductError('Failed to update product: $e'));
    }
  }

  void decrementProductQuantity(int? id, int quantity) async {
    try {
      Product currentProduct = await repository.getProductByIdRepo(id!);

      Product updatedProduct = Product(
          id: currentProduct.id,
          name: currentProduct.name,
          unitPrice: currentProduct.unitPrice,
          quantity: currentProduct.quantity - quantity,
          minimumQuantity: currentProduct.minimumQuantity,
          deleted: currentProduct.deleted,
          supplierName: currentProduct.supplierName,
          supplierAddress: currentProduct.supplierAddress,
          supplierPhoneNum: currentProduct.supplierPhoneNum,
          productDescription: currentProduct.productDescription,
          productImage: currentProduct.productImage);

      await repository.updateProductRepo(id, updatedProduct);

      final index = products.indexWhere((product) => product.id == id);

      if (index != -1) {
        products[index] = updatedProduct;
        emit(ProductUpdated(updatedProduct));
        emit(ProductLoaded(List<Product>.from(products)));
      } else {
        emit(ProductError('Product with ID $id not found.'));
      }
    } catch (e) {
      emit(ProductError('Failed to update product: $e'));
    }
  }

  void filterProducts(String query, String category) {
    List<Product> filtered = products;

    if (query.isNotEmpty) {
      filtered = filtered
          .where((product) =>
              product.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    if (category == 'Low-stock') {
      filtered = filtered
          .where((product) => product.quantity <= product.minimumQuantity)
          .toList();
    } else if (category == 'High-stock') {
      filtered = filtered
          .where((product) => product.quantity > product.minimumQuantity)
          .toList();
    }

    emit(ProductFiltered(filtered));
  }
}
