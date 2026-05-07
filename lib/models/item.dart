class Item {
  String id;
  String name;
  int quantity;
  String condition; // 'baik' | 'rusak'
  String location;

  Item({
    required this.id,
    required this.name,
    required this.quantity,
    required this.condition,
    required this.location,
  });

  // Buat Item dari Map (JSON)
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] as String,
      name: json['name'] as String,
      quantity: json['quantity'] as int,
      condition: json['condition'] as String,
      location: json['location'] as String,
    );
  }

  // Konversi Item ke Map (untuk disimpan ke JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'condition': condition,
      'location': location,
    };
  }

  @override
  String toString() {
    return 'Item(id: $id, name: $name, qty: $quantity, '
        'condition: $condition, location: $location)';
  }
}
