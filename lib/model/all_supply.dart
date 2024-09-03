class SupplyResponse {
  final bool error;
  final String message;
  final int status;
  final SupplyData data;

  SupplyResponse({
    required this.error,
    required this.message,
    required this.status,
    required this.data,
  });

  factory SupplyResponse.fromJson(Map<String, dynamic> json) {
    return SupplyResponse(
      error: json['error'],
      message: json['message'],
      status: json['status'],
      data: SupplyData.fromJson(json['data']),
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

class SupplyData {
  final String message;
  final List<Supply> supply;

  SupplyData({
    required this.message,
    required this.supply,
  });

  factory SupplyData.fromJson(Map<String, dynamic> json) {
    return SupplyData(
      message: json['message'],
      supply: (json['supply'] as List).map((i) => Supply.fromJson(i)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'supply': supply.map((s) => s.toJson()).toList(),
    };
  }
}

class Supply {
  final String? id;
  final String? dispatchReceive;
  final String? serialNo;
  final String? dateTime;
  final String? quarter_id;
  final String? qrCode;
  final String? isAcknowledged; // Added this field
  final String? reference;
  final String? addBy;
  final String? createdAt;
  final String? updatedAt;

  Supply({
    required this.id,
    required this.dispatchReceive,
    required this.serialNo,
    required this.dateTime,
    required this.quarter_id,
    required this.qrCode,
    required this.isAcknowledged, // Added this field
    this.reference,
    required this.addBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Supply.fromJson(Map<String, dynamic> json) {
    return Supply(
      id: json['id'].toString(),
      dispatchReceive: json['dispatch_receive'],
      serialNo: json['serial_no'],
      dateTime: json['date_time'],
      quarter_id: json['quarter_id'],
      qrCode: json['qr_code'],
      isAcknowledged: json['is_acknowledged'].toString(), // Handling boolean conversion
      reference: json['reference'],
      addBy: json['add_by'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dispatch_receive': dispatchReceive,
      'serial_no': serialNo,
      'date_time': dateTime,
      'quarter_id': quarter_id,
      'qr_code': qrCode,
      'is_acknowledged': isAcknowledged.toString(), // Convert boolean to integer for JSON
      'reference': reference,
      'add_by': addBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
