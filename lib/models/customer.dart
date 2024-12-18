class Customer {
  final int id;
  final String name;
  final String address;
  final String phone_num;
  final String email;

  Customer({
    required this.id,
    required this.name,
    required this.address,
    required this.phone_num,
    required this.email,
  });

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'],
      name: map['name'],
      address: map['address'],
      phone_num: map["phone_num"],
      email: map["email"],
    );
  }
}
