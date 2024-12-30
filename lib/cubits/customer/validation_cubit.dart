import 'package:business_assistant/cubits/customer/customer_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ValidationCustomerCubit extends Cubit<ValidationState> {
  ValidationCustomerCubit() : super(const ValidationState());

  void validateCustomerPhoneNumber(String value) {
    String error = '';
    if (value == '' || value.isEmpty) {
      error = 'Please enter the customer phone\n number';
    } else if (!RegExp(r'^[0-9]*$').hasMatch(value) || value.length != 10) {
      error = 'Please enter a valid phone number\n with 10 digits';
    }
    emit(state.copyWith(customerPhoneError: error));
  }

  void validateCustomerEmail(String value) {
    String error = '';

    if (value == '' || value.isEmpty) {
      error = 'Please enter the email of the customer';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      error = 'Enter a valid email address';
    }
    emit(state.copyWith(customerEmailError: error));
  }

  void validateCustomerName(String value) {
    String error = '';
    if (value == '' || value.isEmpty) {
      error = 'Please enter the name of the customer';
    } else if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      error = 'Name cannot contain special characters';
    }
    emit(state.copyWith(customerNameError: error));
  }

  void clearForm() {
    emit(const ValidationState());
  }
}
