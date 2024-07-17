import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:Trako/color/colors.dart';
import 'package:Trako/model/dashboard.dart';
import 'package:Trako/network/ApiService.dart';

class CategoriesDashboard extends StatefulWidget {
  const CategoriesDashboard({Key? key}) : super(key: key);

  @override
  State<CategoriesDashboard> createState() => _CategoriesDashboardState();
}

class _CategoriesDashboardState extends State<CategoriesDashboard> {
  late Future<DashboardResponse> dashboardFuture;
  final ApiService _apiService = ApiService();

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

  String getCategoryTitle(int index, DashboardData data) {
    switch (index) {
      case 0:
        return "Total Distribute\n${data.totalDistribute}";
      case 1:
        return "Total Return\n${data.totalReturn}";
      case 2:
        return "Today's Distribute\n${data.todayDistribute}";
      case 3:
        return "Today's Return\n${data.todayReturn}";
      default:
        return "";
    }
  }
  Future<void> _refreshData() async {
    setState(() {
      dashboardFuture = getDashboard();
    });
    await dashboardFuture;
  }

  DashboardData defaultData = DashboardData(
    totalDistribute: "0",
    totalReturn: "0",
    todayDistribute: "0",
    todayReturn: "0",
  );


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: FutureBuilder<DashboardResponse>(
        future: dashboardFuture,
        builder: (context, snapshot) {
          DashboardData data = defaultData;

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            data = snapshot.data!.data;
          }

          return RefreshIndicator(onRefresh: _refreshData, child: ListView(
            physics: AlwaysScrollableScrollPhysics(),
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Dashboard",
                        style: TextStyle(
                          fontSize: 24.0,
                          color: colorFirstGrad,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.0),
                      GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16.0,
                          crossAxisSpacing: 16.0,
                          childAspectRatio: 1.2,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              // Handle onTap for each category item
                              // You can navigate to another screen or perform any action here
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                              elevation: 3.0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/ic_trako.png',
                                    width: 80,
                                    height: 40,
                                    fit: BoxFit.contain,
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    snapshot.hasError ? "" : getCategoryTitle(index, data),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        itemCount: 4,
                      ),
                      SizedBox(height: 24.0),
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: AspectRatio(
                          aspectRatio: 1.8, // Adjusted aspect ratio for LineChart
                          child: LineChart(
                            LineChartData(
                              lineBarsData: [
                                LineChartBarData(
                                  spots: [
                                    FlSpot(0, 0),
                                    FlSpot(2, 5),
                                    FlSpot(3, 10),
                                    FlSpot(4, 5),
                                    FlSpot(5, 2),
                                    FlSpot(6, 14),
                                  ],
                                  gradient: const LinearGradient(
                                    colors: [colorFirstGrad, colorMixGrad, colorSecondGrad],
                                  ),
                                  isCurved: true,
                                  curveSmoothness: 0.6,
                                  isStrokeCapRound: true,
                                  belowBarData: BarAreaData(show: true),
                                ),
                              ],
                              titlesData: FlTitlesData(
                                show: true,
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 22,
                                      getTitlesWidget: (value, meta) {
                                        final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                                        final interval = 1; // interval between x-axis values
                                        final monthIndex = (value.toInt() / interval).toInt() % months.length; // use the divided value as the index
                                        // return the SideTitleWidget with the correct month label
                                        return SideTitleWidget(
                                          axisSide: meta.axisSide,
                                          child: Text(
                                            months[monthIndex],
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      final maxValue = 500; // maximum value on the y-axis
                                      final interval = maxValue / 5; // interval between titles
                                      final titleValue = value * interval;
                                      return SideTitleWidget(
                                        axisSide: meta.axisSide,
                                        child: Text(
                                          titleValue.toInt().toString(),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: false,
                                  ),
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: false,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ),
                      ),
                      SizedBox(height: 24.0),
                    ],
                  ),
                ),
              )
            ],
          ));
        },
      ),
    );
  }
}
