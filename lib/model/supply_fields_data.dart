class SupplySpinnerResponse {
  bool error;
  String message;
  int status;
  SupplySpinnerData data;

  SupplySpinnerResponse({
    required this.error,
    required this.message,
    required this.status,
    required this.data,
  });

  factory SupplySpinnerResponse.fromJson(Map<String, dynamic> json) {
    return SupplySpinnerResponse(
      error: json['error']?? false,
      message: json['message']?? "",
      status: json['status']?? 0,
      data: SupplySpinnerData.fromJson(json['data']?? {}),
    );
  }
}

class SupplySpinnerData {
  List<String> clientNames;
  List<String> clientCities;
  List<String> modelNos;

  SupplySpinnerData({
    required this.clientNames,
    required this.clientCities,
    required this.modelNos,
  });

  factory SupplySpinnerData.fromJson(Map<String, dynamic> json) {
    return SupplySpinnerData(
      clientNames: List<String>.from(json['client_name']?? []),
      clientCities: List<String>.from(json['client_city']?? []),
      modelNos: List<String>.from(json['model_no']?? []),
    );
  }
}