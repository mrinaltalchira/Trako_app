class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String isActive;
  final String userRole;
  final String token;
  final String machineModule;
  final String clientModule;
  final String userModule;
  final String supplyChain;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.isActive,
    required this.userRole,
    required this.token,
    required this.machineModule,
    required this.clientModule,
    required this.userModule,
    required this.supplyChain,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    try {
      return User(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        phone: json['phone'] ?? '',
        isActive: json['is_active'] ?? '0',
        userRole: json['user_role'] ?? '',
        token: json['token'] ?? '',
        machineModule: json['machine_module'] ?? '0',
        clientModule: json['client_module'] ?? '0',
        userModule: json['user_module'] ?? '0',
        supplyChain: json['supply_chain'] ?? '0',
        createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
        updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      );
    } catch (e) {
      print("Error parsing User JSON: $e");
      throw Exception('Error parsing User data');
    }
  }
}
