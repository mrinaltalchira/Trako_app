import 'dart:convert';

class AcknowledgementResponse {
  final bool error;
  final String message;
  final int status;
  final AcknowledgementData data;

  AcknowledgementResponse({
    required this.error,
    required this.message,
    required this.status,
    required this.data,
  });

  factory AcknowledgementResponse.fromJson(Map<String, dynamic> json) {
    return AcknowledgementResponse(
      error: json['error'] as bool,
      message: json['message'] as String,
      status: json['status'] as int,
      data: AcknowledgementData.fromJson(json['data'] as Map<String, dynamic>),
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

class AcknowledgementData {
  final List<AcknowledgementModel> acknowledgement;

  AcknowledgementData({
    required this.acknowledgement,
  });

  factory AcknowledgementData.fromJson(Map<String, dynamic> json) {
    var list = json['acknowledgement'] as List<dynamic>? ?? [];
    List<AcknowledgementModel> acknowledgementList =
    list.map((i) => AcknowledgementModel.fromJson(i as Map<String, dynamic>)).toList();

    return AcknowledgementData(
      acknowledgement: acknowledgementList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'acknowledgement': acknowledgement.map((i) => i.toJson()).toList(),
    };
  }
}

class AcknowledgementModel {
  final int id;
  final String qrCode;
  final String dateTime;
  final String? reference;
  final String addedBy;
  final String createdAt;
  final String updatedAt;

  AcknowledgementModel({
    required this.id,
    required this.qrCode,
    required this.dateTime,
    this.reference,
    required this.addedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AcknowledgementModel.fromJson(Map<String, dynamic> json) {
    return AcknowledgementModel(
      id: json['id'] as int,
      qrCode: json['qr_code'] as String,
      dateTime: json['date_time'] as String,
      reference: json['reference'] as String?,
      addedBy: json['added_by'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'qr_code': qrCode,
      'date_time': dateTime,
      'reference': reference,
      'added_by': addedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
