class Client {
  final String id; // Assuming the API returns id as String
  final String name;
  final String city;
  final String email;
  final String phone;
  final String address;
  final String machines;
  final String? contactPerson;
  final String addBy; // Nullable String for add_by field
  final DateTime createdAt;
  final DateTime updatedAt;
  final String isActive;

  Client({
    required this.id,
    required this.name,
    required this.city,
    required this.email,
    required this.phone,
    required this.address,
    required this.machines,
    this.contactPerson,
    required this.addBy,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    print(json['isActive'].toString() + "kjdfbdzljkfb");
    return Client(
      id: json['id'].toString(),
      name: json['name'],
      city: json['city'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
       machines: json['machines'],
      contactPerson: json['contact_person'],
      addBy: json['add_by'],
      createdAt: DateTime.parse(json['created_at']), // Parse datetime directly
      updatedAt: DateTime.parse(json['updated_at']), // Convert to string before parsing
      isActive: json['isActive'].toString() // Assuming the API returns is_active as 1 for true
    );
  }
}
