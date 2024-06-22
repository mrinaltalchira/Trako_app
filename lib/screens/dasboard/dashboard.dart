import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tonner_app/color/colors.dart';
import 'package:tonner_app/globals.dart';


class StaticData {
  static List<Map<String, dynamic>> categories = [
    {
      "id": 1,
      "title": "Total Distribute\n           20",
      "icon": "assets/images/ic_tracesci.png"
    },
    {
      "id": 2,
      "title": "Total Return\n       25",
      "icon": "assets/images/ic_tracesci.png"
    },
    {
      "id": 3,
      "title": "Today's Distribute\n               10",
      "icon": "assets/images/ic_tracesci.png"
    },
    {
      "id": 4,
      "title": "Today's Return \n         10",
      "icon": "assets/images/ic_tracesci.png"
    },
  ];
}

class CategoriesDashboard extends StatelessWidget {
  const CategoriesDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 10,),
            const Text(
              "Watch list \nToner count",
              style: TextStyle(
                fontSize: 24.0,
                color: colorFirstGrad,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 25.0,
                crossAxisSpacing: 25.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    // Handle onTap for each category item
                    int categoryId = StaticData.categories[index]["id"];
                    String categoryTitle =
                        StaticData.categories[index]["title"];
                    showSnackBar(context, "Clicked on - id_${categoryId}");

                    // You can navigate to another screen or perform any action here
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(245, 246, 250, 1),
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          StaticData.categories[index]["icon"],
                          width: 100,
                          height: 50,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          StaticData.categories[index]["title"],
                        )
                      ],
                    ),
                  ),
                );
              },
              itemCount: StaticData.categories.length,
            ),
            AspectRatio(
              aspectRatio: 2.0,
              child: LineChart(
                LineChartData(lineBarsData: [
                  LineChartBarData(
                      spots: const [
                        FlSpot(0, 0),
                        FlSpot(2, 5),
                        FlSpot(3, 10),
                        FlSpot(4, 5),
                        FlSpot(5, 2),
                        FlSpot(6, 14),
                      ],
                      gradient: const LinearGradient(colors: [
                        colorFirstGrad,
                        colorMixGrad,
                        colorSecondGrad
                      ]),
                      isCurved: true,
                      curveSmoothness: 0.6,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(show: true))
                ]),
              ),
            ),
            const SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}
