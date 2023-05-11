import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Graph extends StatefulWidget {
  const Graph({Key? key}) : super(key: key);

  @override
  State<Graph> createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  final databaseReference = FirebaseDatabase.instance.reference();
  List<FlSpot> dataPoints = [];
  Timer? timer;

  @override
  void initState() {
    super.initState();
    fetchData();
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => fetchData());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> fetchData() async {
    DataSnapshot dataSnapshot =
        (await databaseReference.child("usage").once()) as DataSnapshot;
    Map<dynamic, dynamic> values = dataSnapshot as Map;

    setState(() {
      dataPoints = [];
      int index = 0;
      values.forEach((key, value) {
        double timeInHours = index * 5.0;
        dataPoints.add(FlSpot(timeInHours, double.parse(value.toString())));
        index++;
      });
    });
  }

  Widget buildLineChart() {
    return LineChart(LineChartData(
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        drawVerticalLine: true,
        horizontalInterval: 10, // Set the interval of the y-axis to 10
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          margin: 8,
          getTitles: (value) {
            if (value % 5 == 0) {
              return value.toInt().toString();
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,

          margin: 8,
          interval: 10, // Set the interval for y-axis titles
          getTitles: (value) {
            return value.toInt().toString();
          },
        ),
      ),
      minX: 0,
      maxX: 5 * (dataPoints.length - 1).toDouble(),
      minY: 0,
      maxY: 100,
      lineBarsData: [
        LineChartBarData(
          spots: dataPoints,
          isCurved: true,
          colors: [Colors.blue],
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(show: true), // Show data points
          belowBarData: BarAreaData(show: false),
        )
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Data Usage Live Graph')),
      body: Center(child: buildLineChart()),
    );
  }
}
