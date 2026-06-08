import 'package:aplikasi_diabetes/pages/login_page.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../color.dart';

class ChartPage extends StatelessWidget {
  const ChartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<double> gulaDarah = [110, 120, 115, 130, 125, 140, 135];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Grafik Gula Darah"),
        backgroundColor: AppColor.primary,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 10),

            Text(
              "Grafik Gula Darah Mingguan",
              style: TextStyle(
                color: AppColor.primary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(show: true),

                  titlesData: FlTitlesData(
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const days = [
                            "Sen", "Sel", "Rab", "Kam", "Jum", "Sab", "Min"
                          ];
                          if (value.toInt() >= 0 &&
                              value.toInt() < days.length) {
                            return Text(days[value.toInt()]);
                          }
                          return const Text("");
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),

                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      color: AppColor.primary,
                      barWidth: 4,
                      dotData: FlDotData(show: true),

                      spots: List.generate(
                        gulaDarah.length,
                        (index) => FlSpot(
                          index.toDouble(),
                          gulaDarah[index],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}