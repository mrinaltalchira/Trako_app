class LoginModel {
  bool error;
  String message;
  int status;
  Data data;

  LoginModel({
    required this.error,
    required this.message,
    required this.status,
    required this.data,
  });
}

class Data {
  String message;
  User user;

  Data({
    required this.message,
    required this.user,
  });
}

class User {
  int userId;
  String name;
  String email;
  String phone;
  int isActive;
  String userRole;
  String authority;
  DateTime createdAt;
  DateTime updatedAt;

  User({
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.isActive,
    required this.userRole,
    required this.authority,
    required this.createdAt,
    required this.updatedAt,
  });
}
