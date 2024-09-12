class TonerColorResponse {
  final bool error;
  final String message;
  final int status;
  final Data data;

  TonerColorResponse({
    required this.error,
    required this.message,
    required this.status,
    required this.data,
  });

  factory TonerColorResponse.fromJson(Map<String, dynamic> json) {
    return TonerColorResponse(
      error: json['error'],
      message: json['message'],
      status: json['status'],
      data: Data.fromJson(json['data']),
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

class Data {
  final String message;
  final TonerColors? tonerColors; // Make this nullable

  Data({
    required this.message,
    this.tonerColors, // Allow this to be null
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      message: json['message'],
      tonerColors: json['toner_colors'] != null
          ? TonerColors.fromJson(json['toner_colors'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'toner_colors': tonerColors?.toJson(),
    };
  }
}

class TonerColors {
  final String serialNo;
  final String color;

  TonerColors({
    required this.serialNo,
    required this.color,
  });

  factory TonerColors.fromJson(Map<String, dynamic> json) {
    return TonerColors(
      serialNo: json['serial_no'],
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serial_no': serialNo,
      'color': color,
    };
  }
}
