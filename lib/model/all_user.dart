class ApiResponse {
  bool error;
  String message;
  int status;
  ApiData data;

  ApiResponse({
    required this.error,
    required this.message,
    required this.status,
    required this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      error: json['error'] ?? false,
      message: json['message'] ?? "",
      status: json['status'] ?? 0,
      data: ApiData.fromJson(json['data'] ?? {}),
    );
  }
}

class ApiData {
  String message;
  List<User> users;

  ApiData({
    required this.message,
    required this.users,
  });

  factory ApiData.fromJson(Map<String, dynamic> json) {
    List<dynamic> userList = json['user'] ?? [];
    List<User> users = userList.map((e) => User.fromJson(e)).toList();

    return ApiData(
      message: json['message'] ?? "",
      users: users,
    );
  }
}

class User {
  int id;
  String name;
  String email;
  String token;
  String phone;
  String isActive;
  String userRole;
  String createdAt;
  String updatedAt;
  String machineModule;
  String clientModule;
  String userModule;

  User({
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

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      email: json['email'] ?? "",
      token: json['token'] ?? "",
      phone: json['phone'] ?? "",
      isActive: json['is_active'] ?? "",
      userRole: json['user_role'] ?? "",
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
      machineModule: json['machine_module'] ?? "",
      clientModule: json['client_module'] ?? "",
      userModule: json['user_module'] ?? "",
    );
  }
}
