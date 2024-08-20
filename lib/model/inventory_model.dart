class InventoryModel {
  final String id;
  final String name;
  final int quantity;
  final double price;
  final String description;

  InventoryModel(
    this.id,
    this.name,
    this.quantity,
    this.price,
    this.description,
  );

  factory InventoryModel.fromMap(Map map) {
    return InventoryModel(
      map['id'],
      map['name'],
      map['quantity'],
      map['price'],
      map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'price': price,
      'description': description,
    };
  }
}
