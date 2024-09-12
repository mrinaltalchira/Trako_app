class ClientReportResponse {
  final bool error;
  final String message;
  final ClientReportData? data; // Nullable

  ClientReportResponse({
    required this.error,
    required this.message,
    this.data,
  });

  factory ClientReportResponse.fromJson(Map<String, dynamic> json) {
    return ClientReportResponse(
      error: json['error'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? ClientReportData.fromJson(json['data']) : null, // Null check for data
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'message': message,
      'data': data?.toJson(), // Null-aware operator for data
    };
  }
}

class ClientReportData {
  final String message;
  final Report? report; // Nullable

  ClientReportData({
    required this.message,
    this.report,
  });

  factory ClientReportData.fromJson(Map<String, dynamic> json) {
    return ClientReportData(
      message: json['message'] ?? '',
      report: json['report'] != null ? Report.fromJson(json['report']) : null, // Null check for report
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'report': report?.toJson(), // Null-aware operator for report
    };
  }
}

class Report {
  final String totalMachinesAssigned; // Using String to handle both int and String values
  final String dispatchCount; // Using String to handle both int and String values
  final String receiveCount; // Using String to handle both int and String values

  Report({
    required this.totalMachinesAssigned,
    required this.dispatchCount,
    required this.receiveCount,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      totalMachinesAssigned: (json['totalMachinesAssigned'] != null ? json['totalMachinesAssigned'].toString() : '0'), // Null check and conversion to String
      dispatchCount: (json['dispatch_count'] != null ? json['dispatch_count'].toString() : '0'), // Null check and conversion to String
      receiveCount: (json['receive_count'] != null ? json['receive_count'].toString() : '0'), // Null check and conversion to String
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalMachinesAssigned': totalMachinesAssigned,
      'dispatch_count': dispatchCount,
      'receive_count': receiveCount,
    };
  }
}
