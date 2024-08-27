class User {
  final int id;
  final String name;
  final String email;
  final String token;
  final String phone;
  final int isActive;
  final String userRole;
  final String authority;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String machineModule;
  final String clientModule;
  final String userModule;
  final String supplyChain;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
    required this.phone,
    required this.isActive,
    required this.userRole,
    required this.authority,
    required this.createdAt,
    required this.updatedAt,
    required this.machineModule,
    required this.clientModule,
    required this.userModule,
    required this.supplyChain,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      token: json['token'],
      phone: json['phone'],
      isActive: int.parse(json['is_active']),
      userRole: json['user_role'],
      authority: json['authority'] ?? '', // adjust if authority is available in JSON
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      machineModule: json['machine_module'].toString(), // Convert '1' to true, '0' to false
      clientModule: json['client_module'], // Convert '1' to true, '0' to false
      userModule: json['user_module'], // Convert '1' to true, '0' to false
      supplyChain: json['supply_chain_module'], // Convert '1' to true, '0' to false
    );
  }
}
