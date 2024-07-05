class UserResponse {
  final bool error;
  final String message;
  final int status;
  final UserData data;

  UserResponse({
    required this.error,
    required this.message,
    required this.status,
    required this.data,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      error: json['error'],
      message: json['message'],
      status: json['status'],
      data: UserData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'message': message,
      'status': status,
      'data': data.toJson(),
    };
  }
}

class UserData {
  final int id;
  final String name;
  final String email;
  final String token;
  final String phone;
  final String isActive;
  final String userRole;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String machineModule;
  final String clientModule;
  final String userModule;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
    required this.phone,
    required this.isActive,
    required this.userRole,
    required this.createdAt,
    required this.updatedAt,
    required this.machineModule,
    required this.clientModule,
    required this.userModule,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      token: json['token'],
      phone: json['phone'],
      isActive: json['is_active'],
      userRole: json['user_role'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      machineModule: json['machine_module'],
      clientModule: json['client_module'],
      userModule: json['user_module'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'token': token,
      'phone': phone,
      'is_active': isActive,
      'user_role': userRole,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'machine_module': machineModule,
      'client_module': clientModule,
      'user_module': userModule,
    };
  }
}
