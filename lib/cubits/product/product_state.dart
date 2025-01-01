
import 'package:equatable/equatable.dart';
import 'package:image_input/image_input.dart';
import '../../models/product.dart';

abstract class ProductState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;

  ProductLoaded(this.products);

  @override
  List<Object?> get props => [products];
}

class ProductFiltered extends ProductState {
  final List<Product> filteredProducts;

  ProductFiltered(this.filteredProducts);

  @override
  List<Object?> get props => [filteredProducts];
}

class ProductUpdated extends ProductState {
  final Product updatedProduct;

  ProductUpdated(this.updatedProduct);

  @override
  List<Object?> get props => [updatedProduct];
}

class ProductError extends ProductState {
  final String message;

  ProductError(this.message);

  @override
  List<Object?> get props => [message];
}

class ValidationState extends ProductState {
  final String minThresholdError;
  final String unitPriceError;
  final String currentQuantityError;
  final String supplierPhoneError;
  final String imagePath;

  ValidationState({
    this.minThresholdError = '',
    this.unitPriceError = '',
    this.currentQuantityError = '',
    this.supplierPhoneError = '',
    this.imagePath = '',
  });

  ValidationState copyWith({
    String? minThresholdError,
    String? unitPriceError,
    String? currentQuantityError,
    String? supplierPhoneError,
    String? imagePath,
  }) {
    return ValidationState(
      minThresholdError: minThresholdError ?? this.minThresholdError,
      unitPriceError: unitPriceError ?? this.unitPriceError,
      currentQuantityError: currentQuantityError ?? this.currentQuantityError,
      supplierPhoneError: supplierPhoneError ?? this.supplierPhoneError,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
