class AllUsersApiResponse {
  bool error;
  String message;
  int status;
  ApiData data;

  AllUsersApiResponse({
    required this.error,
    required this.message,
    required this.status,
    required this.data,
  });

  factory AllUsersApiResponse.fromJson(Map<String, dynamic> json) {
    return AllUsersApiResponse(
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
  Pagination pagination;

  ApiData({
    required this.message,
    required this.users,
    required this.pagination,
  });

  factory ApiData.fromJson(Map<String, dynamic> json) {
    List<dynamic> userList = json['users'] ?? [];
    List<User> users = userList.map((e) => User.fromJson(e)).toList();

    return ApiData(
      message: json['message'] ?? "",
      users: users,
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
    );
  }
}

class User {
  int id;
  String name;
  String email;
  String phone;
  String token;
  String isActive;
  String userRole;
  String createdAt;
  String updatedAt;
  String machineModule;
  String clientModule;
  String acknowledgeModule;
  String tonerRequestModule;
  String dispatchModule;
  String receiveModule;
  String userModule; // Added userModule field

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.token,
    required this.isActive,
    required this.userRole,
    required this.createdAt,
    required this.updatedAt,
    required this.machineModule,
    required this.clientModule,
    required this.acknowledgeModule,
    required this.tonerRequestModule,
    required this.dispatchModule,
    required this.receiveModule,
    required this.userModule, // Initialize userModule field
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      email: json['email'] ?? "",
      phone: json['phone'] ?? "",
      token: json['token'] ?? "",
      isActive: json['is_active'] ?? "",
      userRole: json['user_role'] ?? "",
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
      machineModule: json['machine_module'] ?? "",
      clientModule: json['client_module'] ?? "",
      acknowledgeModule: json['acknowledge_module'] ?? "",
      tonerRequestModule: json['toner_request_module'] ?? "",
      dispatchModule: json['dispatch_module'] ?? "",
      receiveModule: json['receive_module'] ?? "",
      userModule: json['user_module'] ?? "", // Parse userModule field
    );
  }
}

class Pagination {
  int total;
  int currentPage;
  int lastPage;
  int perPage;
  String? nextPageUrl;
  String? prevPageUrl;

  Pagination({
    required this.total,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    this.nextPageUrl,
    this.prevPageUrl,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      total: json['total'] ?? 0,
      currentPage: json['current_page'] ?? 0,
      lastPage: json['last_page'] ?? 0,
      perPage: json['per_page'] ?? 0,
      nextPageUrl: json['next_page_url'] as String?,
      prevPageUrl: json['prev_page_url'] as String?,
    );
  }
}
