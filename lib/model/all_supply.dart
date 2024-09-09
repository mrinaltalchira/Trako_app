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
      error: json['error'] as bool,
      message: json['message'] as String,
      status: json['status'] as int,
      data: SupplyData.fromJson(json['data'] as Map<String, dynamic>),
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
  final Pagination? pagination;

  SupplyData({
    required this.message,
    required this.supply,
    this.pagination,
  });

  factory SupplyData.fromJson(Map<String, dynamic> json) {
    return SupplyData(
      message: json['message'] as String,
      supply: (json['supply'] as List)
          .map((item) => Supply.fromJson(item as Map<String, dynamic>))
          .toList(),
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'supply': supply.map((s) => s.toJson()).toList(),
      'pagination': pagination?.toJson(),
    };
  }
}

class Supply {
  final String? id;
  final String? dispatchReceive;
  final String? serialNo;
  final String? dateTime;
  final String? quarterId;
  final String? qrCode;
  final String? isAcknowledged;
  final String? reference;
  final String? addBy;
  final String? createdAt;
  final String? updatedAt;

  Supply({
    this.id,
    this.dispatchReceive,
    this.serialNo,
    this.dateTime,
    this.quarterId,
    this.qrCode,
    this.isAcknowledged,
    this.reference,
    this.addBy,
    this.createdAt,
    this.updatedAt,
  });

  factory Supply.fromJson(Map<String, dynamic> json) {
    return Supply(
      id: json['id'].toString(),
      dispatchReceive: json['dispatch_receive'].toString(),
      serialNo: json['serial_no'].toString(),
      dateTime: json['date_time'].toString(),
      quarterId: json['quarter_id'].toString(),
      qrCode: json['qr_code'].toString(),
      isAcknowledged: json['is_acknowledged'].toString(),
      reference: json['reference'].toString(),
      addBy: json['add_by'].toString(),
      createdAt: json['created_at'].toString(),
      updatedAt: json['updated_at'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dispatch_receive': dispatchReceive,
      'serial_no': serialNo,
      'date_time': dateTime,
      'quarter_id': quarterId,
      'qr_code': qrCode,
      'is_acknowledged': isAcknowledged,
      'reference': reference,
      'add_by': addBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class Pagination {
  final int? total;
  final int? currentPage;
  final int? lastPage;
  final int? perPage;
  final String? nextPageUrl;
  final String? prevPageUrl;

  Pagination({
    this.total,
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.nextPageUrl,
    this.prevPageUrl,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      total: json['total'] as int?,
      currentPage: json['current_page'] as int?,
      lastPage: json['last_page'] as int?,
      perPage: json['per_page'] as int?,
      nextPageUrl: json['next_page_url'] as String?,
      prevPageUrl: json['prev_page_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'current_page': currentPage,
      'last_page': lastPage,
      'per_page': perPage,
      'next_page_url': nextPageUrl,
      'prev_page_url': prevPageUrl,
    };
  }
}
