class MachineResponse {
  final bool error;
  final String message;
  final int status;
  final MachineData data;

  MachineResponse({
    required this.error,
    required this.message,
    required this.status,
    required this.data,
  });

  factory MachineResponse.fromJson(Map<String, dynamic> json) {
    return MachineResponse(
      error: json['error'],
      message: json['message'],
      status: json['status'],
      data: MachineData.fromJson(json['data']),
    );
  }
}

class MachineData {
  final String message;
  final List<Machine> machines;

  MachineData({
    required this.message,
    required this.machines,
  });

  factory MachineData.fromJson(Map<String, dynamic> json) {
    var machinesList = json['machine'] as List;
    List<Machine> machines = machinesList
        .map((machineJson) => Machine.fromJson(machineJson))
        .toList();

    return MachineData(
      message: json['message'],
      machines: machines,
    );
  }
}

class Machine {
  final String id;
  final String modelName;
  final String serialNo; // Updated field name
  final String receiveDays; // Updated field name
  final int? clientId; // Updated field type
  final String isActive;
  final int? addedBy; // Updated field type
  final String clientName; // Updated field type
  final DateTime createdAt;
  final DateTime updatedAt;

  Machine({
    required this.clientName,
    required this.id,
    required this.modelName,
    required this.serialNo, // Updated field name
    required this.receiveDays, // Updated field name
    required this.clientId, // Updated field type
    required this.isActive,
    required this.addedBy, // Updated field type
    required this.createdAt,
    required this.updatedAt,
  });

  factory Machine.fromJson(Map<String, dynamic> json) {
    return Machine(
      id: json['id'].toString(),
      modelName: json['model_name'],
      serialNo: json['serial_no'],
      // Updated field name
      receiveDays: json['receive_days'],
      clientName: json['client_name'],
      // Updated field name
      clientId: json['client_id'] != null ? json['client_id'] as int : null,
      // Updated field type
      isActive: json['isActive'].toString(),
      addedBy: json['added_by'] != null ? json['added_by'] as int : null,
      // Updated field type
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
