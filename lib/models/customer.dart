class Customer {
  final int? id;
  late final String name;
  late final String address;
  late final String phoneNum;
  late final String email;
  late final String note;
  final int deleted;
  final int count;

  // Constructor with required named parameters
  Customer({
    this.id,
    required this.name,
    required this.address,
    required this.phoneNum,
    required this.email,
    required this.note,
    required this.deleted,
    this.count = 0,
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
      count: map['ordersCountValue'] ?? 0,
    );
  }

  // Convert a Customer object to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'phone_num': phoneNum,
      'email': email,
      'note': note,
      'deleted': deleted,
      'count': count,
    };
  }

  // Override toString to provide a detailed string representation
  @override
  String toString() {
    return 'Customer{id: $id, name: $name, address: $address, phoneNum: $phoneNum, '
        'email: $email, note: $note, deleted: $deleted, count: $count}';
  }

  Customer copyWith({
    int? id,
    String? name,
    String? address,
    String? phoneNum,
    String? email,
    String? note,
    int? deleted,
    int? count,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      phoneNum: phoneNum ?? this.phoneNum,
      email: email ?? this.email,
      note: note ?? this.note,
      deleted: deleted ?? this.deleted,
      count: count ?? this.count,
    );
  }
}
