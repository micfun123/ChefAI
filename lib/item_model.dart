class Item {
  int? id;
  String name;
  double amount;
  String unit;
  String? expirationDate;
  String dateAdded;

  Item({
    this.id,
    required this.name,
    required this.amount,
    required this.unit,
    this.expirationDate,
    required this.dateAdded,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'unit': unit,
      'expirationDate': expirationDate,
      'dateAdded': dateAdded,
    };
  }

  static Item fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      name: map['name'],
      amount: map['amount'],
      unit: map['unit'],
      expirationDate: map['expirationDate'],
      dateAdded: map['dateAdded'],
    );
  }
}
