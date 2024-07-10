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
  final List<Report> report;

  ClientReportData({
    required this.message,
    required this.report,
  });

  factory ClientReportData.fromJson(Map<String, dynamic> json) {
    var list = json['report'] as List;
    List<Report> reportList = list.map((i) => Report.fromJson(i)).toList();

    return ClientReportData(
      message: json['message'],
      report: reportList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'report': report.map((e) => e.toJson()).toList(),
    };
  }
}

class Report {
  final int reportCount;
  final String dispatchCount;
  final String receiveCount;

  Report({
    required this.reportCount,
    required this.dispatchCount,
    required this.receiveCount,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      reportCount: json['report_count'],
      dispatchCount: json['dispatch_count'],
      receiveCount: json['receive_count'],
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
