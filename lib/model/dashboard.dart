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
      List<GraphData> graphData;
      Details details;

      DashboardData({
        required this.graphData,
        required this.details,
      });

      factory DashboardData.fromJson(Map<String, dynamic> json) {
        var graphDataList = json['graphData'] as List;
        List<GraphData> graphData =
        graphDataList.map((data) => GraphData.fromJson(data)).toList();

        return DashboardData(
          graphData: graphData,
          details: Details.fromJson(json['details']),
        );
      }
    }

    class GraphData {
      String month;
      String dispatch;
      String receive;

      GraphData({
        required this.month,
        required this.dispatch,
        required this.receive,
      });

      factory GraphData.fromJson(Map<String, dynamic> json) {
        return GraphData(
          month: json['month'].toString(),
          dispatch: json['dispatch'].toString(),
          receive: json['receive'].toString(),
        );
      }
    }

    class Details {
      String totalDistribute;
      String totalReturn;
      String todayDistribute;
      String todayReturn;

      Details({
        required this.totalDistribute,
        required this.totalReturn,
        required this.todayDistribute,
        required this.todayReturn,
      });

      factory Details.fromJson(Map<String, dynamic> json) {
        return Details(
          totalDistribute: json['total_distribute'].toString(),
          totalReturn: json['total_return'].toString(),
          todayDistribute: json['today_distribute'].toString(),
          todayReturn: json['today_return'].toString(),
        );
      }
    }
