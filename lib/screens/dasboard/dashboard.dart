// import 'package:Trako/color/colors.dart';
// import 'package:Trako/model/dashboard.dart';
// import 'package:Trako/network/ApiService.dart';
// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
//
// class CategoriesDashboard extends StatefulWidget {
//   const CategoriesDashboard({Key? key}) : super(key: key);
//
//   @override
//   State<CategoriesDashboard> createState() => _CategoriesDashboardState();
// }
//
// double parseValueSafely(String value) {
//   try {
//     return double.parse(value);
//   } catch (e) {
//     print('Error parsing value: $value, Error: $e');
//     return 0.0; // Return a default value or handle the error case
//   }
// }
//
// class _CategoriesDashboardState extends State<CategoriesDashboard> {
//   late Future<DashboardResponse> dashboardFuture;
//   final ApiService _apiService = ApiService();
//   List<GraphData>  graphData = [];
//
//   @override
//   void initState() {
//     super.initState();
//     dashboardFuture = getDashboard();
//   }
//
//   Future<DashboardResponse> getDashboard() async {
//     try {
//       return await _apiService.getDashboard();
//     } catch (e) {
//       print('Error fetching dashboard: $e');
//       throw Exception('Failed to fetch dashboard data.');
//     }
//   }
//
//   String getCategoryTitle(int index, Details data) {
//     switch (index) {
//       case 0:
//         return "Total Distribute\n${data.totalDistribute}";
//       case 1:
//         return "Total Return\n${data.totalReturn}";
//       case 2:
//         return "Today's Distribute\n${data.todayDistribute}";
//       case 3:
//         return "Today's Return\n${data.todayReturn}";
//       default:
//         return "";
//     }
//   }
//
//   Future<void> _refreshData() async {
//     setState(() {
//       dashboardFuture = getDashboard();
//     });
//     await dashboardFuture;
//   }
//
//   Details defaultData = Details(
//     totalDistribute: "0",
//     totalReturn: "0",
//     todayDistribute: "0",
//     todayReturn: "0",
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder<DashboardResponse>(
//         future: dashboardFuture,
//         builder: (context, snapshot) {
//           Details data = defaultData;
//
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             print('Error: ${snapshot.error}');
//           } else if (snapshot.hasData) {
//             data = snapshot.data!.data.details;
//             graphData = snapshot.data!.data.graphData;
//           }
//
//           print('Response data: $graphData');
//
//           return RefreshIndicator(
//             onRefresh: _refreshData,
//             child: ListView(
//               physics: AlwaysScrollableScrollPhysics(),
//               children: [
//                 SingleChildScrollView(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 16.0, vertical: 16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         const Text(
//                           "Dashboard",
//                           style: TextStyle(
//                             fontSize: 24.0,
//                             color: colorFirstGrad,
//                             fontWeight: FontWeight.w600,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                         SizedBox(height: 16.0),
//                         GridView.builder(
//                           physics: NeverScrollableScrollPhysics(),
//                           shrinkWrap: true,
//                           gridDelegate:
//                               SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 2,
//                             mainAxisSpacing: 16.0,
//                             crossAxisSpacing: 16.0,
//                             childAspectRatio: 1.2,
//                           ),
//                           itemBuilder: (BuildContext context, int index) {
//                             return GestureDetector(
//                               onTap: () {
//                                 // Handle onTap for each category item
//                                 // You can navigate to another screen or perform any action here
//                               },
//                               child: Card(
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(18.0),
//                                 ),
//                                 elevation: 3.0,
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Image.asset(
//                                       'assets/images/ic_trako.png',
//                                       width: 80,
//                                       height: 40,
//                                       fit: BoxFit.contain,
//                                     ),
//                                     SizedBox(height: 8.0),
//                                     Text(
//                                       snapshot.hasError
//                                           ? ""
//                                           : getCategoryTitle(index, data),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           },
//                           itemCount: 4,
//                         ),
//                         SizedBox(height: 24.0),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: AspectRatio(
//                             aspectRatio: 1.0,
//                             // Adjusted aspect ratio for LineChart
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.stretch,
//                               children: [
//                                 Container(
//                             decoration: BoxDecoration(
//                             color: colorMixGrad.withOpacity(.08),
//                             borderRadius:
//                             BorderRadius.circular(5.0),
//                           ),
//                                  child: Padding(
//                                    padding: const EdgeInsets.all(8.0),
//                                    child: const Center(
//                                        child: Text(
//                                          'Monthly Dispatch and Receive Analysis',
//                                          style: TextStyle(fontSize: 18),
//                                        )),
//                                  ),
//                                 ),
//                                 SizedBox(
//                                   height: 20,
//                                 ),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceEvenly,
//                                   children: [
//                                     Container(
//                                       decoration: BoxDecoration(
//                                         color: Colors.blue.withOpacity(0.00),
//                                         borderRadius:
//                                             BorderRadius.circular(5.0),
//                                       ),
//                                       padding: EdgeInsets.symmetric(
//                                           horizontal: 12.0, vertical: 8.0),
//                                       child: Row(
//                                         children: [
//                                           Container(
//                                             width: 12.0,
//                                             height: 12.0,
//                                             color: Colors.blue,
//                                           ),
//                                           SizedBox(width: 4.0),
//                                           Text(
//                                             'Receive',
//                                             style: TextStyle(
//                                                 color: Colors.blue,
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     Container(
//                                       decoration: BoxDecoration(
//                                         color: Colors.orange.withOpacity(0.0),
//                                         borderRadius:
//                                             BorderRadius.circular(5.0),
//                                       ),
//                                       padding: EdgeInsets.symmetric(
//                                           horizontal: 12.0, vertical: 8.0),
//                                       child: Row(
//                                         children: [
//                                           Container(
//                                             width: 12.0,
//                                             height: 12.0,
//                                             color: Colors.pink,
//                                           ),
//                                           SizedBox(width: 4.0),
//                                           Text(
//                                             'Dispatch',
//                                             style: TextStyle(
//                                                 color: Colors.pink,
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Expanded(
//                                   child: SfCartesianChart(
//                                     primaryXAxis: CategoryAxis(),
//
//                                     legend: Legend(isVisible: false),
//                                     // Enable tooltip
//                                     tooltipBehavior:
//                                         TooltipBehavior(enable: true),
//                                     series: <ChartSeries>[
//                                       LineSeries<GraphData, String>(
//                                         dataSource: graphData,
//                                         xValueMapper: (GraphData data, _) =>
//                                             data.month,
//                                         yValueMapper: (GraphData data, _) =>
//                                             parseValueSafely(data.receive),
//                                         name: 'Receive',
//                                         // Enable data label
//                                         dataLabelSettings:
//                                             DataLabelSettings(isVisible: true),
//                                       ),
//                                       LineSeries<GraphData, String>(
//                                         dataSource: graphData,
//                                         xValueMapper: (GraphData data, _) =>
//                                             data.month,
//                                         yValueMapper: (GraphData data, _) =>
//                                             parseValueSafely(data.dispatch),
//                                         name: 'Dispatch',
//                                         // Enable data label
//                                         dataLabelSettings: DataLabelSettings(isVisible: true),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 SizedBox(height: 8.0),
//                               ],
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 24.0),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }


import 'package:Trako/color/colors.dart';
import 'package:Trako/model/dashboard.dart';
import 'package:Trako/network/ApiService.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CategoriesDashboard extends StatefulWidget {
  const CategoriesDashboard({Key? key}) : super(key: key);

  @override
  State<CategoriesDashboard> createState() => _CategoriesDashboardState();
}

class _CategoriesDashboardState extends State<CategoriesDashboard> {
  late Future<DashboardResponse> dashboardFuture;
  final ApiService _apiService = ApiService();
  List<GraphData> graphData = [];
  final numberFormat = NumberFormat("#,##0");

  @override
  void initState() {
    super.initState();
    dashboardFuture = getDashboard();
  }

  Future<DashboardResponse> getDashboard() async {
    try {
      return await _apiService.getDashboard();
    } catch (e) {
      print('Error fetching dashboard: $e');
      throw Exception('Failed to fetch dashboard data.');
    }
  }

  DashboardMetric getCategoryMetric(int index, Details data) {
    switch (index) {
      case 0:
        return DashboardMetric(
          title: "Total Distribution",
          value: data.totalDistribute,
          icon: Icons.local_shipping_outlined,
          color: const Color(0xFF1E88E5),
          trend: 12.5,
        );
      case 1:
        return DashboardMetric(
          title: "Total Returns",
          value: data.totalReturn,
          icon: Icons.assignment_return_outlined,
          color: const Color(0xFF43A047),
          trend: -5.2,
        );
      case 2:
        return DashboardMetric(
          title: "Today's Distribution",
          value: data.todayDistribute,
          icon: Icons.inventory_2_outlined,
          color: const Color(0xFFFFB300),
          trend: 8.7,
        );
      case 3:
        return DashboardMetric(
          title: "Today's Returns",
          value: data.todayReturn,
          icon: Icons.assignment_returned_outlined,
          color: const Color(0xFF8E24AA),
          trend: 3.1,
        );
      default:
        return DashboardMetric(
          title: "",
          value: "0",
          icon: Icons.error_outline,
          color: Colors.grey,
          trend: 0,
        );
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      dashboardFuture = getDashboard();
    });
    await dashboardFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: FutureBuilder<DashboardResponse>(
        future: dashboardFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: LoadingIndicator(),
            );
          }

          if (snapshot.hasError) {
            return ErrorView(
              error: snapshot.error.toString(),
              onRetry: _refreshData,
            );
          }

          final data = snapshot.data?.data.details ?? defaultData;
          graphData = snapshot.data?.data.graphData ?? [];

          return RefreshIndicator(
            onRefresh: _refreshData,
            color: colorFirstGrad,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const DashboardHeader(),
                        const SizedBox(height: 32),
                        MetricsGrid(
                          data: data,
                          getCategoryMetric: getCategoryMetric, // Pass the method here
                        ),
                        const SizedBox(height: 32),
                        AnalyticsChart(graphData: graphData),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}


class DashboardHeader extends StatelessWidget {
  const DashboardHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Distribution Analytics',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          DateFormat('EEEE, MMMM d, y').format(DateTime.now()),
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

class MetricsGrid extends StatelessWidget {
  final Details data;
  final DashboardMetric Function(int index, Details data) getCategoryMetric;

  const MetricsGrid({Key? key, required this.data, required this.getCategoryMetric}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 24.0,
        crossAxisSpacing: 24.0,
        childAspectRatio: 1.1,
      ),
      itemBuilder: (context, index) {
        final metric = getCategoryMetric(index, data); // Use the passed function
        return MetricCard(metric: metric);
      },
      itemCount: 4,
    );
  }
}


class MetricCard extends StatelessWidget {
  final DashboardMetric metric;
  final NumberFormat numberFormat = NumberFormat('#,###');

  MetricCard({Key? key, required this.metric}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12), // Reduce padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Let the column take minimum space
          children: [
            Icon(
              metric.icon,
              size: 28, // Optionally reduce icon size
              color: metric.color,
            ),
            const SizedBox(height: 8), // Keep this, but can be adjusted
            Text(
              metric.title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              numberFormat.format(int.parse(metric.value)),
              style: TextStyle(
                fontSize: 20, // Optionally reduce font size
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

}


class AnalyticsChart extends StatelessWidget {
  final List<GraphData> graphData;

  const AnalyticsChart({Key? key, required this.graphData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Distribution Trends',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            const ChartLegend(),
            const SizedBox(height: 24),
            SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey[200]!,
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) => Text(
                          value.toInt().toString(),
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) => Text(
                          graphData[value.toInt()].month,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: _getChartSeries(graphData),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
  List<LineChartBarData> _getChartSeries(List<GraphData> data) {
    return [
      LineChartBarData(
        spots: data
            .asMap()
            .entries
            .map((e) => FlSpot(e.key.toDouble(), parseValueSafely(e.value.receive)))
            .toList(),
        isCurved: true,
        color: const Color(0xFF1E88E5),
        barWidth: 3,
        isStrokeCapRound: true,
        belowBarData: BarAreaData(show: false),
        dotData: FlDotData(show: true),
      ),
      LineChartBarData(
        spots: data
            .asMap()
            .entries
            .map((e) => FlSpot(e.key.toDouble(), parseValueSafely(e.value.dispatch)))
            .toList(),
        isCurved: true,
        color: const Color(0xFFE91E63),
        barWidth: 3,
        isStrokeCapRound: true,
        belowBarData: BarAreaData(show: false),
        dotData: FlDotData(show: true),
      ),
    ];
  }

  double parseValueSafely(dynamic value) {
    return value != null ? double.tryParse(value.toString()) ?? 0.0 : 0.0;
  }
 }

class ChartLegend extends StatelessWidget {
  const ChartLegend({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        LegendItem(
          label: 'Receive',
          color: Color(0xFF1E88E5),
        ),
        SizedBox(width: 24),
        LegendItem(
          label: 'Dispatch',
          color: Color(0xFFE91E63),
        ),
      ],
    );
  }
}

class LegendItem extends StatelessWidget {
  final String label;
  final Color color;

  const LegendItem({
    Key? key,
    required this.label,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(colorFirstGrad),
        ),
        const SizedBox(height: 16),
        Text(
          'Loading dashboard...',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

class ErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const ErrorView({
    Key? key,
    required this.error,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load dashboard',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorFirstGrad,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardMetric {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final double trend;

  const DashboardMetric({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.trend,
  });
}

final defaultData = Details(
  totalDistribute: "0",
  totalReturn: "0",
  todayDistribute: "0",
  todayReturn: "0",
);

double parseValueSafely(String value) {
  try {
    return double.parse(value);
  } catch (e) {
    print('Error parsing value: $value, Error: $e');
    return 0.0;
  }
}