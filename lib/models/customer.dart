class Customer {
  final int id;
  late final String name;
  late final String address;
  late final String phoneNum;
  late final String email;
  late final String note;
  final int deleted;
  final int ordersCountValue;

  // Constructor with required named parameters
  Customer({
    required this.id,
    required this.name,
    required this.address,
    required this.phoneNum,
    required this.email,
    required this.note,
    required this.deleted,
    this.ordersCountValue = 0,
  });

  // Factory method for creating a Customer from a map
  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'] as int,
      name: map['name'] as String,
      address: map['address'] as String,
      phoneNum: map['phone_num'] as String,
      email: map['email'] as String,
      note: map['note'] ?? '',
      deleted: map['deleted'] as int,
      ordersCountValue: map['ordersCountValue'] ?? 0,
    );
  }

  // Convert a Customer object to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone_num': phoneNum,
      'email': email,
      'note': note,
      'deleted': deleted,
      'ordersCountValue': ordersCountValue,
    };
  }

  // Override toString to provide a detailed string representation
  @override
  String toString() {
    return 'Customer{id: $id, name: $name, address: $address, phoneNum: $phoneNum, '
        'email: $email, note: $note, deleted: $deleted, ordersCountValue: $ordersCountValue}';
  }
}
