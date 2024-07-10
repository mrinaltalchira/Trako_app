class SupplySpinnerResponse {
  final bool error;
  final String message;
  final int status;
  final Data data;

  SupplySpinnerResponse({
    required this.error,
    required this.message,
    required this.status,
    required this.data,
  });

  factory SupplySpinnerResponse.fromJson(Map<String, dynamic> json) {
    return SupplySpinnerResponse(
      error: json['error'],
      message: json['message'],
      status: json['status'],
      data: Data.fromJson(json['data']),
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

class Data {
  final List<String> clientName;
  final List<String> clientCity;
  final List<String> modelNo;
  final List<SupplyClient> clients;

  Data({
    required this.clientName,
    required this.clientCity,
    required this.modelNo,
    required this.clients,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      clientName: List<String>.from(json['client_name']),
      clientCity: List<String>.from(json['client_city']),
      modelNo: List<String>.from(json['model_no']),
      clients: (json['clients'] as List)
          .map((clientJson) => SupplyClient.fromJson(clientJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'client_name': clientName,
      'client_city': clientCity,
      'model_no': modelNo,
      'clients': clients.map((client) => client.toJson()).toList(),
    };
  }
}

class SupplyClient {
  final int id;
  final String name;
  final String city;

  SupplyClient({
    required this.id,
    required this.name,
    required this.city,
  });

  factory SupplyClient.fromJson(Map<String, dynamic> json) {
    return SupplyClient(
      id: json['id'],
      name: json['name'],
      city: json['city'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'city': city,
    };
  }
}
