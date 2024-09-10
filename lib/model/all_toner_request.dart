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

// Class representing pagination
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

  // Factory method to create an instance from JSON
  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      total: json['total'],
      currentPage: json['current_page'],
      lastPage: json['last_page'],
      perPage: json['per_page'],
      nextPageUrl: json['next_page_url'],
      prevPageUrl: json['prev_page_url'],
    );
  }

  // Method to convert an instance to JSON
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

// Class representing the API response data
class TonerRequestData {
  final List<AllTonerRequest> tonerRequests;
  final Pagination pagination;

  TonerRequestData({
    required this.tonerRequests,
    required this.pagination,
  });

  // Factory method to create an instance from JSON
  factory TonerRequestData.fromJson(Map<String, dynamic> json) {
    return TonerRequestData(
      tonerRequests: List<AllTonerRequest>.from(
        json['toner_requests'].map((item) => AllTonerRequest.fromJson(item)),
      ),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'toner_requests': tonerRequests.map((item) => item.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}

// Class representing the full API response
class ApiResponse {
  final bool error;
  final String message;
  final int status;
  final TonerRequestData data;

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
      data: TonerRequestData.fromJson(json['data']),
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'message': message,
      'status': status,
      'data': data.toJson(),
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
    "data": {
        "toner_requests": [
            {
                "id": 1,
                "serial_no": null,
                "color": "Magenta",
                "quantity": 1,
                "last_counter": "22",
                "req_by": "2",
                "created_at": "2024-09-04T05:16:00.000000Z",
                "updated_at": "2024-09-04T05:16:00.000000Z"
            }
        ],
        "pagination": {
          "total": 23,
          "current_page": 1,
          "last_page": 3,
          "per_page": 10,
          "next_page_url": "http://example.com/api/toner-requests?page=2",
          "prev_page_url": null
        }
    }
  }
  ''';

  // Parsing the JSON response
  final Map<String, dynamic> jsonMap = jsonDecode(jsonResponse);
  final ApiResponse apiResponse = ApiResponse.fromJson(jsonMap);

  print(apiResponse.message); // Output: Success
  print(apiResponse.data.tonerRequests[0].color); // Output: Magenta
  print(apiResponse.data.pagination.total); // Output: 23
}
