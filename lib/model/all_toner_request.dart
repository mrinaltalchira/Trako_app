import 'dart:convert';

// Class representing each toner request
class AllTonerRequest {
  final int id;
  final String? serialNo;
  final String color;
  final int quantity;
  final String lastCounter;
  final String reqBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  AllTonerRequest({
    required this.id,
    this.serialNo,
    required this.color,
    required this.quantity,
    required this.lastCounter,
    required this.reqBy,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method to create an instance from JSON
  factory AllTonerRequest.fromJson(Map<String, dynamic> json) {
    return AllTonerRequest(
      id: json['id'],
      serialNo: json['serial_no'],
      color: json['color'],
      quantity: json['quantity'],
      lastCounter: json['last_counter'],
      reqBy: json['req_by'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serial_no': serialNo,
      'color': color,
      'quantity': quantity,
      'last_counter': lastCounter,
      'req_by': reqBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

// Class representing the API response
class ApiResponse {
  final bool error;
  final String message;
  final int status;
  final List<AllTonerRequest> data;

  ApiResponse({
    required this.error,
    required this.message,
    required this.status,
    required this.data,
  });

  // Factory method to create an instance from JSON
  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      error: json['error'],
      message: json['message'],
      status: json['status'],
      data: List<AllTonerRequest>.from(
        json['data'].map((item) => AllTonerRequest.fromJson(item)),
      ),
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'message': message,
      'status': status,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

// Example usage
void main() {
  // Example JSON response
  String jsonResponse = '''
  {
    "error": false,
    "message": "Success",
    "status": 200,
    "data": [
        {
            "id": 1,
            "serial_no": null,
            "color": "Magenta",
            "quantity": 1,
            "last_counter": "22",
            "req_by": "2",
            "created_at": "2024-09-04T05:16:00.000000Z",
            "updated_at": "2024-09-04T05:16:00.000000Z"
        },
        ...
    ]
  }
  ''';

  // Parsing the JSON response
  final Map<String, dynamic> jsonMap = jsonDecode(jsonResponse);
  final ApiResponse apiResponse = ApiResponse.fromJson(jsonMap);

  print(apiResponse.message); // Output: Success
  print(apiResponse.data[0].color); // Output: Magenta
}
