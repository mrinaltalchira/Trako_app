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
      error: json['error'] ?? false,
      message: json['message'] ?? '',
      status: json['status'] ?? 0,
      data: MachineData.fromJson(json['data'] ?? {}),
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
    var machinesList = json['machine'] as List<dynamic>? ?? [];
    List<Machine> machines = machinesList
        .map((machineJson) => Machine.fromJson(machineJson as Map<String, dynamic>))
        .toList();

    return MachineData(
      message: json['message'] ?? '',
      machines: machines,
    );
  }
}

class Machine {
  final String id;
  final String? modelName; // Nullable field
  final String? serialNo;  // Nullable field
  final String? receiveDays; // Nullable field
  final int? clientId; // Nullable field
  final String isActive;
  final int? addedBy; // Nullable field
  final String? clientName; // Nullable field
  final DateTime createdAt;
  final DateTime updatedAt;

  Machine({
    required this.id,
    this.modelName,
    this.serialNo,
    this.receiveDays,
    this.clientId,
    required this.isActive,
    this.addedBy,
    this.clientName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Machine.fromJson(Map<String, dynamic> json) {
    return Machine(
      id: json['id'].toString(),
      modelName: json['model_name'] as String?,
      serialNo: json['serial_no'] as String?,
      receiveDays: json['receive_days'] as String?,
      clientName: json['client_name'] as String?,
      clientId: json['client_id'] != null ? json['client_id'] as int : null,
      isActive: json['isActive'].toString(),
      addedBy: json['added_by'] != null ? json['added_by'] as int : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
