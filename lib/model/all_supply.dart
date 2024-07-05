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
  final String id;
  final String dispatchReceive;
  final String clientName;
  final String clientCity;
  final String modelNo;
  final String dateTime;
  final String qrCode;
  final String? reference;
  final String addBy;
  final String createdAt;
  final String updatedAt;

  Supply({
    required this.id,
    required this.dispatchReceive,
    required this.clientName,
    required this.clientCity,
    required this.modelNo,
    required this.dateTime,
    required this.qrCode,
    this.reference,
    required this.addBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Supply.fromJson(Map<String, dynamic> json) {
    return Supply(
      id: json['id'].toString(),
      dispatchReceive: json['dispatch_receive'],
      clientName: json['client_name'],
      clientCity: json['client_city'],
      modelNo: json['model_no'],
      dateTime: json['date_time'],
      qrCode: json['qr_code'],
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
      'client_name': clientName,
      'client_city': clientCity,
      'model_no': modelNo,
      'date_time': dateTime,
      'qr_code': qrCode,
      'reference': reference,
      'add_by': addBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
