class Product {
  int id;
  String name;
  double unitPrice;
  int quantity;
  bool deleted;
  String supplierName;
  String supplierPhoneNum;
  String supplierAddress;
  String productDescription;
  int minimumQuantity;
  String? additionalInfo;
  String productImage;

  Product({
    required this.id,
    required this.name,
    required this.unitPrice,
    required this.quantity,
    required this.deleted,
    required this.supplierName,
    required this.supplierPhoneNum,
    required this.supplierAddress,
    required this.productDescription,
    required this.minimumQuantity,
    this.additionalInfo,
    required this.productImage,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      unitPrice: map['unit_price'],
      quantity: map['quantity'],
      deleted: map['deleted'] == 1,
      supplierName: map['supplier_name'],
      supplierPhoneNum: map['supplier_phone_num'],
      supplierAddress: map['supplier_address'],
      productDescription: map['product_description'],
      minimumQuantity: map['minimum_quantity'],
      additionalInfo: map['additional_info'],
      productImage: map['product_image'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'unit_price': unitPrice,
      'quantity': quantity,
      'deleted': deleted ? 1 : 0, // Store 1 for true, 0 for false
      'supplier_name': supplierName,
      'supplier_phone_num': supplierPhoneNum,
      'supplier_address': supplierAddress,
      'product_description': productDescription,
      'minimum_quantity': minimumQuantity,
      'additional_info': additionalInfo,
      'product_image': productImage,
    };
  }
}
