  class DashboardResponse {
    bool success;
    String message;
    DashboardData data;

    DashboardResponse({
      required this.success,
      required this.message,
      required this.data,
    });

    factory DashboardResponse.fromJson(Map<String, dynamic> json) {
      return DashboardResponse(
        success: json['success'],
        message: json['message'],
        data: DashboardData.fromJson(json['data']),
      );
    }
  }

  class DashboardData {
    String totalDistribute;
    String totalReturn;
    String todayDistribute;
    String todayReturn;

    DashboardData({
      required this.totalDistribute,
      required this.totalReturn,
      required this.todayDistribute,
      required this.todayReturn,
    });

    factory DashboardData.fromJson(Map<String, dynamic> json) {
      return DashboardData(
        totalDistribute: json['total_distribute'].toString(),
        totalReturn: json['total_return'].toString(),
        todayDistribute: json['today_distribute'].toString(),
        todayReturn: json['today_return'].toString(),
      );
    }
  }