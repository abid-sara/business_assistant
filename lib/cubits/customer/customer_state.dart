import 'package:equatable/equatable.dart';
import '../../models/customer.dart';

abstract class CustomerState extends Equatable {
  final String currentSortOption;

  const CustomerState({this.currentSortOption = "Order count"});
  @override
  List<Object?> get props => [];
}

class CustomerInitial extends CustomerState {}

class CustomerLoading extends CustomerState {}

class CustomerLoaded extends CustomerState {
  final List<Customer> customers;

  const CustomerLoaded(this.customers);

  @override
  List<Object?> get props => [customers];
}

class CustomerError extends CustomerState {
  final String message;

  const CustomerError(this.message);

  @override
  List<Object?> get props => [message];
}

class CustomerUpdated extends CustomerState {
  final Customer updatedCustomer;
  const CustomerUpdated(this.updatedCustomer);

  @override
  List<Object?> get props => [updatedCustomer];
}

class CustomerFiltered extends CustomerState {
  final List<Customer> filteredCustomers;
  const CustomerFiltered(this.filteredCustomers);

  @override
  List<Object?> get props => [filteredCustomers];
}

class CustomerSorted extends CustomerState {
  final List<Customer> sortedCustomers;

  const CustomerSorted(this.sortedCustomers, String sortOption)
      : super(currentSortOption: sortOption);

  @override
  List<Object?> get props => [sortedCustomers, currentSortOption];
}

class CustomerDeleted extends CustomerState {
  final int? deletedCustomerId;

  const CustomerDeleted(this.deletedCustomerId);
}

class ValidationState extends CustomerState {
  final String customerPhoneError;
  final String customerEmailError;
  final String customerNameError;

  const ValidationState(
      {this.customerPhoneError = '',
      this.customerEmailError = '',
      this.customerNameError = ''});

  ValidationState copyWith({
    String? customerPhoneError,
    String? customerEmailError,
    String? customerNameError,
  }) {
    return ValidationState(
      customerPhoneError: customerPhoneError ?? this.customerPhoneError,
      customerEmailError: customerEmailError ?? this.customerEmailError,
      customerNameError: customerNameError ?? this.customerNameError,
    );
  }
}
