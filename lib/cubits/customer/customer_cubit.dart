import 'package:flutter_bloc/flutter_bloc.dart';
import 'customer_state.dart';
import 'customer_repository.dart';
import '../../models/customer.dart';

class CustomerCubit extends Cubit<CustomerState> {
  final CustomerRepository repository;
  List<Customer> customers = [];
  String currentSortOption = "Order count";

  CustomerCubit(this.repository) : super(CustomerInitial()) {
    fetchCustomers();
  }

  Future<void> fetchCustomers() async {
    emit(CustomerLoading());
    try {
      customers = await repository.getCustomersRepo();
      customers = customers.where((c) => c.deleted == 0).toList();
      emit(CustomerLoaded(customers));
    } catch (e) {
      emit(CustomerError('Failed to fetch customers: $e'));
    }
  }

  void addCustomer(Customer customer) async {
    try {
      final updatedCustomer = await repository.addCustomerRepo(customer);
      final updatedCustomers = List<Customer>.from(customers)
        ..add(updatedCustomer);
      customers = updatedCustomers;
      emit(CustomerLoaded(updatedCustomers));
    } catch (e) {
      emit(CustomerError('Failed to add customer: $e'));
    }
  }

  void deleteCustomer(int? id) async {
    try {
      await repository.deleteCustomerRepo(id);
      customers.removeWhere((customer) => customer.id == id);
      emit(CustomerDeleted(id));
      emit(CustomerLoaded(List<Customer>.from(customers)));
    } catch (e) {
      emit(CustomerError('Failed to delete customer: $e'));
    }
  }

  void filterCustomers(String filter) {
    if (filter.isEmpty) {
      emit(CustomerLoaded(customers));
    } else {
      final filtered = customers.where((customer) {
        return customer.name.toLowerCase().contains(filter.toLowerCase());
      }).toList();
      emit(CustomerFiltered(filtered)); // Emit only filtered customers
    }
  }

  void sortCustomers(String selectedSortOption) {
    currentSortOption = selectedSortOption;

    if (selectedSortOption == 'Customer name') {
      customers.sort((a, b) => a.name.compareTo(b.name));
      emit(CustomerSorted(customers, "Customer name"));
    } else if (selectedSortOption == 'Orders count') {
      customers.sort((a, b) => b.count.compareTo(a.count));
      emit(CustomerSorted(customers, "Order count"));
    }
  }

  void updateCustomer(int? id, Customer updatedCustomer) async {
    try {
      await repository.updateCustomerRepo(id, updatedCustomer);
      final index = customers.indexWhere((product) => product.id == id);

      if (index != -1) {
        customers[index] = updatedCustomer;
        emit(CustomerUpdated(updatedCustomer));
        emit(CustomerLoaded(List<Customer>.from(customers)));
      } else {
        emit(CustomerError('Customer with ID $id not found.'));
      }
    } catch (e) {
      emit(CustomerError('Failed to update customer: $e'));
    }
  }

  void incrementCustomerOrderCounts(int? id) async {
    try {
      Customer currentCustomer = await repository.getCustomerByIdRepo(id!);

      Customer updatedCustomer = Customer(
          id: currentCustomer.id,
          name: currentCustomer.name,
          address: currentCustomer.address,
          phoneNum: currentCustomer.phoneNum,
          email: currentCustomer.email,
          note: currentCustomer.note,
          count: currentCustomer.count + 1,
          deleted: currentCustomer.deleted);

      await repository.updateCustomerRepo(id, updatedCustomer);

      final index = customers.indexWhere((customer) => customer.id == id);

      if (index != -1) {
        customers[index] = updatedCustomer;
        emit(CustomerUpdated(updatedCustomer));
        emit(CustomerLoaded(List<Customer>.from(customers)));
      } else {
        emit(CustomerError('Customer with ID $id not found.'));
      }
    } catch (e) {
      emit(CustomerError('Failed to update customer: $e'));
    }
  }
}
