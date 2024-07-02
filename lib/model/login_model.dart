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
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      token: json['token'],
      phone: json['phone'],
      isActive: json['is_active'],
      userRole: json['user_role'],
      authority: json['authority'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}