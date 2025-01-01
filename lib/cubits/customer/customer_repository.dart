import 'package:business_assistant/database/db_order.dart';

import '/models/customer.dart';
import '/database/db_customer.dart';

class CustomerRepository {
  Future<List<Customer>> getCustomersRepo() async {
    return await showCustomers();
  }

  Future<Customer> addCustomerRepo(Customer customer) async {
    int id = await insertCustomer(customer.toMap());
    return customer.copyWith(id: id);
  }

  Future<void> deleteCustomerRepo(int? id) async {
    await deleteCustomer(id);
  }

  Future<void> updateCustomerRepo(int? id, Customer customer) async {
    await updateCustomer(customer);
  }

  Future<Customer> getCustomerByIdRepo(int? id) async {
    Map<String, dynamic> customerData = await getOneCustomer(id!);
    return Customer.fromMap(customerData);
  }
}
