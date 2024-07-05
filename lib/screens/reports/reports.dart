import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:tonner_app/color/colors.dart';

class MyReportScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10,bottom:20),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "My Report",
                  style: TextStyle(
                    fontSize: 24.0,
                    color: colorMixGrad, // Replace with your colorSecondGrad
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                  'Suspendisse varius enim in eros elementum tristique. '
                  'Duis cursus, mi quis viverra ornare, eros dolor interdum nulla, '
                  'ut commodo diam libero vitae erat. Aenean faucibus nibh et justo '
                  'cursus id rutrum lorem imperdiet.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Pie Chart',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            PieChartSample2(), // Add the pie chart widget
            SizedBox(height: 20),
            Text(
              'Dummy Text',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Toner Receive: 100\n'
                  'Toner Distributed: 80\n'
                  'Client: ABC Company\n'
                  'Machine: XYZ Model',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class PieChartSample2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: 30,
              color: Colors.green,
              title: 'Toner Receive',
              radius: 80,
              titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            PieChartSectionData(
              value: 20,
              color: Colors.blue,
              title: 'Toner Distributed',
              radius: 80,
              titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            PieChartSectionData(
              value: 25,
              color: Colors.orange,
              title: 'Client',
              radius: 80,
              titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            PieChartSectionData(
              value: 25,
              color: Colors.red,
              title: 'Machine',
              radius: 80,
              titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
