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
  final Pagination pagination;

  MachineData({
    required this.message,
    required this.machines,
    required this.pagination,
  });

  factory MachineData.fromJson(Map<String, dynamic> json) {
    var machinesList = json['machines'] as List<dynamic>? ?? [];
    List<Machine> machines = machinesList
        .map((machineJson) => Machine.fromJson(machineJson as Map<String, dynamic>))
        .toList();

    return MachineData(
      message: json['message'] ?? '',
      machines: machines,
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
    );
  }
}

class Machine {
  final String id;
  final String? modelName; // Nullable field
  final String? serialNo;  // Nullable field
  final String isActive;
  final int? addedBy; // Nullable field
  final DateTime createdAt;
  final DateTime updatedAt;

  Machine({
    required this.id,
    this.modelName,
    this.serialNo,
    required this.isActive,
    this.addedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Machine.fromJson(Map<String, dynamic> json) {
    return Machine(
      id: json['id'].toString(),
      modelName: json['model_name'] as String?,
      serialNo: json['serial_no'] as String?,
      isActive: json['isActive'].toString(),
      addedBy: json['added_by'] != null ? json['added_by'] as int : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class Pagination {
  final int total;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final String? nextPageUrl;
  final String? prevPageUrl;

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
