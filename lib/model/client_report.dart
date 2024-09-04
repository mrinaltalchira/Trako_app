import 'dart:convert';

class ClientReportResponse {
  final bool error;
  final String message;
  final int status;
  final ClientReportData data;

  ClientReportResponse({
    required this.error,
    required this.message,
    required this.status,
    required this.data,
  });

  factory ClientReportResponse.fromJson(Map<String, dynamic> json) {
    return ClientReportResponse(
      error: json['error'],
      message: json['message'],
      status: json['status'],
      data: ClientReportData.fromJson(json['data']),
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

class ClientReportData {
  final String message;
  final Report report;

  ClientReportData({
    required this.message,
    required this.report,
  });

  factory ClientReportData.fromJson(Map<String, dynamic> json) {
    return ClientReportData(
      message: json['message'],
      report: Report.fromJson(json['report']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'report': report.toJson(),
    };
  }
}

class Report {
  final int? reportCount; // Nullable
  final int? dispatchCount; // Nullable
  final int? receiveCount; // Nullable

  Report({
    this.reportCount,
    this.dispatchCount,
    this.receiveCount,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      reportCount: json['report_count'] != null ? json['report_count'] as int : null,
      dispatchCount: json['dispatch_count'] != null ? json['dispatch_count'] as int : null,
      receiveCount: json['receive_count'] != null ? json['receive_count'] as int : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'report_count': reportCount,
      'dispatch_count': dispatchCount,
      'receive_count': receiveCount,
    };
  }
}
