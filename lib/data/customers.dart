import 'package:business_assistant/data/products.dart';

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
      orders: []),
  //add another customer
  Customer(
      customerID: 3,
      name: 'Ali',
      address: 'Tunisia',
      phone_num: "123456789",
      email: 'email@gmail.com',
      orders: []),

  Customer(
      customerID: 4,
      name: 'Sara',
      address: 'Morocco',
      phone_num: "123456789",
      email: 'anything@gmail.com',
      orders: []),
  // he cannot have an order once created!
  Customer(
      customerID: 5,
      name: 'John',
      address: 'USA',
      phone_num: "555123456",
      email: 'john@example.com',
      orders: []),
  //add another customer
  Customer(
      customerID: 6,
      name: 'Jane',
      address: 'Canada',
      phone_num: "555987654",
      email: 'jane@example.com',
      orders: []),
  //add another customer
  Customer(
      customerID: 7,
      name: 'Ahmed',
      address: 'Saudi Arabia',
      phone_num: "555678901",
      email: 'ahmed@example.com',
      orders: []),
];
