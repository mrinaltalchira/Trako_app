class ClientResponse {
  bool? error;
  String? message;
  int? status;
  ClientData? data;

  ClientResponse({
    this.error,
    this.message,
    this.status,
    this.data,
  });

  factory ClientResponse.fromJson(Map<String, dynamic> json) {
    return ClientResponse(
      error: json['error'],
      message: json['message'],
      status: json['status'],
      data: json['data'] != null ? ClientData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'message': message,
      'status': status,
      'data': data?.toJson(),
    };
  }
}

class ClientData {
  String? message;
  List<Client>? clients;
  Pagination? pagination;

  ClientData({
    this.message,
    this.clients,
    this.pagination,
  });

  factory ClientData.fromJson(Map<String, dynamic> json) {
    return ClientData(
      message: json['message'],
      clients: json['clients'] != null
          ? List<Client>.from(json['clients'].map((client) => Client.fromJson(client)))
          : null,
      pagination: json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'clients': clients?.map((client) => client.toJson()).toList(),
      'pagination': pagination?.toJson(),
    };
  }
}

class Client {
  int? id;
  String? name;
  String? city;
  String? email;
  String? phone;
  String? address;
  String? contactPerson;
  String? machines;
  String? addBy;
  String? createdAt;
  String? updatedAt;
  String? isActive;

  Client({
    this.id,
    this.name,
    this.city,
    this.email,
    this.phone,
    this.address,
    this.contactPerson,
    this.machines,
    this.addBy,
    this.createdAt,
    this.updatedAt,
    this.isActive,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'],
      name: json['name'].toString(),
      city: json['city'].toString(),
      email: json['email'].toString(),
      phone: json['phone'].toString(),
      address: json['address'].toString(),
      contactPerson: json['contact_person'].toString(),
      machines: json['machines'].toString(),
      addBy: json['add_by'].toString(),
      createdAt: json['created_at'].toString(),
      updatedAt: json['updated_at'].toString(),
      isActive: json['isActive'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'city': city,
      'email': email,
      'phone': phone,
      'address': address,
      'contact_person': contactPerson,
      'machines': machines,
      'add_by': addBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'isActive': isActive,
    };
  }
}

class Pagination {
  int? total;
  int? currentPage;
  int? lastPage;
  int? perPage;
  String? nextPageUrl;
  String? prevPageUrl;

  Pagination({
    this.total,
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.nextPageUrl,
    this.prevPageUrl,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      total: json['total'],
      currentPage: json['current_page'],
      lastPage: json['last_page'],
      perPage: json['per_page'],
      nextPageUrl: json['next_page_url'],
      prevPageUrl: json['prev_page_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'current_page': currentPage,
      'last_page': lastPage,
      'per_page': perPage,
      'next_page_url': nextPageUrl,
      'prev_page_url': prevPageUrl,
    };
  }
}
