class Client {
  int id;
  String name;
  String city;
  String email;
  String phone;
  String address;
  String contactPerson;
  String? addBy;
  bool isActive;
  DateTime createdAt;
  DateTime updatedAt;

  Client({
    required this.id,
    required this.name,
    required this.city,
    required this.email,
    required this.phone,
    required this.address,
    required this.contactPerson,
    required this.addBy,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'],
      name: json['name'],
      city: json['city'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      contactPerson: json['contact_person'],
      addBy: json['add_by'], // Assuming 'add_by' is nullable in your JSON
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
