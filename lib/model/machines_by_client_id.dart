class MachineByClientIdResponse {
  final bool error;
  final String message;
  final int status;
  final Data data;

  MachineByClientIdResponse({
    required this.error,
    required this.message,
    required this.status,
    required this.data,
  });

  factory MachineByClientIdResponse.fromJson(Map<String, dynamic> json) {
    return MachineByClientIdResponse(
      error: json['error'] ?? false,
      message: json['message'] ?? '',
      status: json['status'] ?? 0,
      data: json['data'] != null ? Data.fromJson(json['data']) : Data(machines: []),
    );
  }
}

class Data {
  final List<MachineByClientId> machines;

  Data({
    required this.machines,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      machines: json['machines'] != null
          ? List<MachineByClientId>.from(
          (json['machines'] as List).map((machineJson) => MachineByClientId.fromJson(machineJson as Map<String, dynamic>)))
          : [],
    );
  }
}

class MachineByClientId {
  final int id;
  final int clientId;
  final String modelName;
  final String serialNo;
  final int assignedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  MachineByClientId({
    required this.id,
    required this.clientId,
    required this.modelName,
    required this.serialNo,
    required this.assignedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MachineByClientId.fromJson(Map<String, dynamic> json) {
    return MachineByClientId(
      id: json['id'] ?? 0,
      clientId: json['client_id'] ?? 0,
      modelName: json['model_name'] ?? '',
      serialNo: json['serial_no'] ?? '',
      assignedBy: json['assigned_by'] ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at']) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'model_name': modelName,
      'serial_no': serialNo,
      'assigned_by': assignedBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
