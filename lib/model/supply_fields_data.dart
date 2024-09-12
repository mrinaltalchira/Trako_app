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
  final List<String> serialNo;
  final List<SupplyClient> clients;

  Data({
    required this.clientName,
    required this.clientCity,
    required this.serialNo,
    required this.clients,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      clientName: List<String>.from(json['client_name']),
      clientCity: List<String>.from(json['client_city']),
      serialNo: List<String>.from(json['serial_no']),
      clients: (json['clients'] as List)
          .map((clientJson) => SupplyClient.fromJson(clientJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'client_name': clientName,
      'client_city': clientCity,
      'serial_no': serialNo,
      'clients': clients.map((client) => client.toJson()).toList(),
    };
  }
}

class SupplyClient {
  final String id;
  final String name;
  final String city;
  final List<ClientsMachine> machines;

  SupplyClient({
    required this.id,
    required this.name,
    required this.city,
    required this.machines,
  });

  factory SupplyClient.fromJson(Map<String, dynamic> json) {
    return SupplyClient(
      id: json['id'].toString(), // JSON 'id' is an integer
      name: json['name'],
      city: json['city'],
      machines: (json['machines'] as List)
          .map((machineJson) => ClientsMachine.fromJson(machineJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'city': city,
      'machines': machines.map((machine) => machine.toJson()).toList(),
    };
  }
}

class ClientsMachine {
  final String id;
  final String modelName;
  final String serialNo;
  final String receiveDays;
  final String clientId;
  final String isActive;
  final String addedBy;
  final String createdAt;
  final String updatedAt;

  ClientsMachine({
    required this.id,
    required this.modelName,
    required this.serialNo,
    required this.receiveDays,
    required this.clientId,
    required this.isActive,
    required this.addedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ClientsMachine.fromJson(Map<String, dynamic> json) {
    return ClientsMachine(
      id: json['id'].toString(), // JSON 'id' is an integer
      modelName: json['model_name'],
      serialNo: json['serial_no'],
      receiveDays: json['receive_days'],
      clientId: json['client_id'].toString(), // JSON 'client_id' is an integer
      isActive: json['isActive'],
      addedBy: json['added_by'].toString(), // JSON 'added_by' is an integer
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'model_name': modelName,
      'serial_no': serialNo,
      'receive_days': receiveDays,
      'client_id': clientId,
      'isActive': isActive,
      'added_by': addedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
