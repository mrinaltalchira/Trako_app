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
    List<Machine> machines =
    machinesList.map((machineJson) => Machine.fromJson(machineJson)).toList();

    return MachineData(
      message: json['message'],
      machines: machines,
    );
  }
}

class Machine {
  final String id;
  final String modelName;
  final String modelCode;
  final String addBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  Machine({
    required this.id,
    required this.modelName,
    required this.modelCode,
    required this.addBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Machine.fromJson(Map<String, dynamic> json) {
    return Machine(
      id: json['id'].toString(),
      modelName: json['model_name'],
      modelCode: json['model_code'],
      addBy: json['add_by'].toString(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
