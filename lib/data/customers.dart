import 'orders.dart';

class Customer {
  int customerID;
  String name;
  String address;
  String phone_num;
  String email;
  String note;
  List<Order> orders;
  Customer(
      {required this.customerID,
      required this.name,
      required this.orders,
      required this.address,
      required this.phone_num,
      required this.email,
      this.note = ''}); // as default the note is empty

  int ordersCount() {
    return orders.length;
  }

  bool addOrder(Order order) {
    orders.add(order);
    return true;
  }
}

//creating a dummy customers list
List<Customer> customers = [
  Customer(
      customerID: 1,
      name: 'Ahmed',
      address: 'Algeria',
      phone_num: "123456789",
      email: 'hello@gmail.com',
      orders: []), //no orders for now for this customer
  //add another customer
  Customer(
      customerID: 2,
      name: 'Mohamed',
      address: 'Egypt',
      phone_num: "987654321",
      email: 'hello@there.com',
      orders: []), //no orders for now for this customer
];
