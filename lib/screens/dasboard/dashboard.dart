import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tonner_app/color/colors.dart';

class StaticData {
  static List<Map<String, dynamic>> categories = [
    {
      "id": 1,
      "title": "Total Distribute\n20",
      "icon": "assets/images/ic_tracesci.png"
    },
    {
      "id": 2,
      "title": "Total Return\n25",
      "icon": "assets/images/ic_tracesci.png"
    },
    {
      "id": 3,
      "title": "Today's Distribute\n10",
      "icon": "assets/images/ic_tracesci.png"
    },
    {
      "id": 4,
      "title": "Today's Return\n10",
      "icon": "assets/images/ic_tracesci.png"
    },
  ];
}
class CategoriesDashboard extends StatelessWidget {
  const CategoriesDashboard({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
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
                      int categoryId = StaticData.categories[index]["id"];
                      showSnackBar(context, "Clicked on - id_${categoryId}");

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
                            StaticData.categories[index]["icon"],
                            width: 80,
                            height: 40,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            StaticData.categories[index]["title"],
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: StaticData.categories.length,
              ),
              SizedBox(height: 24.0),
              AspectRatio(
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
                        gradient: LinearGradient(
                          colors: [colorFirstGrad, colorMixGrad, colorSecondGrad],
                        ),
                        isCurved: true,
                        curveSmoothness: 0.6,
                        isStrokeCapRound: true,
                        belowBarData: BarAreaData(show: true),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.0),
            ],
          ),
        ),
      ),
    );
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 1),
      ),
    );
  }
}
