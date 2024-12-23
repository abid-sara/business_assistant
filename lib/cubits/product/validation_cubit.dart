import 'package:business_assistant/cubits/product/product_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_input/image_input.dart';


class ValidationCubit extends Cubit<ValidationState> {
  ValidationCubit() : super(ValidationState());

  void validateMinThreshold(String value) {
    String error = '';
    if (value.isEmpty) {
      error = 'Please enter the min threshold';
    } else if (!RegExp(r'^[0-9]*$').hasMatch(value)) {
      error = 'Please enter a valid number';
    }
    emit(state.copyWith(minThresholdError: error));
  }

  void validateUnitPrice(String value) {
    String error = '';
    if (value.isEmpty) {
      error = 'Please enter a unit price';
    } else if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(value)) {
      error = 'Please enter a valid number';
    }
    emit(state.copyWith(unitPriceError: error));
  }

  void validateCurrentQuantity(String value) {
    String error = '';
    if (value.isEmpty) {
      error = 'Please enter the current quantity';
    } else if (!RegExp(r'^[0-9]*$').hasMatch(value)) {
      error = 'Please enter a valid number';
    }
    emit(state.copyWith(currentQuantityError: error));
  }

  void validateSupplierPhoneNumber(String value) {
    String error = '';
    if (value.isEmpty) {
      error = 'Please enter the supplier phone number';
    } else if (!RegExp(r'^[0-9]*$').hasMatch(value) || value.length != 10) {
      error = 'Please enter a valid phone number with 10 digits';
    }
    emit(state.copyWith(supplierPhoneError: error));
  }

  void updateImageInput(XFile image) {
    emit(state.copyWith(
      imageInputImages: [image],
      imagePath: image.path,
    ));
  }

  void clearForm() {
    emit(ValidationState());
  }
}
