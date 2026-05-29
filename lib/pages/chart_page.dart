import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../color.dart';
import 'login_page.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  final List<Map<String, dynamic>> data = [];

  // TOTAL
  double get totalGula => data.fold(0, (s, e) => s + e["gula"]);
  double get totalKalori => data.fold(0, (s, e) => s + e["kalori"]);
  int get totalMakan => data.length;

  double toDouble(TextEditingController c) =>
      double.tryParse(c.text) ?? 0;

  double hitung(double jml, double tkr, double perSaji) =>
      tkr == 0 ? 0 : (jml / tkr) * perSaji;

  Widget input(TextEditingController c, String label) {
    return TextField(
      controller: c,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label),
    );
  }

  void tambahData() {
    final nama = TextEditingController();
    final jumlah = TextEditingController();
    final takaran = TextEditingController();
    final gula = TextEditingController();
    final kalori = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Tambah Konsumsi"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: nama, decoration: const InputDecoration(labelText: "Nama")),
              input(jumlah, "Jumlah"),
              input(takaran, "Takaran"),
              input(gula, "Gula / saji"),
              input(kalori, "Kalori / saji"),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              final jml = toDouble(jumlah);
              final tkr = toDouble(takaran);

              setState(() {
                data.add({
                  "nama": nama.text,
                  "gula": hitung(jml, tkr, toDouble(gula)),
                  "kalori": hitung(jml, tkr, toDouble(kalori)),
                });
              });

              Navigator.pop(context);
            },
            child: const Text("Simpan"),
          )
        ],
      ),
    );
  }

  Widget buildChart() {
    final values = [
      totalMakan.toDouble(),
      totalGula,
      totalKalori / 10,
    ];

    final labels = ["Makan", "Gula", "Kalori"];

    final colors = [
      Colors.blue,
      Colors.red,
      Colors.orange,
    ];

    return SizedBox(
      height: 230,
      child: BarChart(
        BarChartData(
          borderData: FlBorderData(show: false),

          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  return Text(labels[value.toInt()]);
                },
              ),
            ),
          ),

          barGroups: List.generate(3, (i) {
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: values[i],
                  color: colors[i],
                  width: 20,
                  borderRadius: BorderRadius.circular(6),
                )
              ],
            );
          }),
        ),
      ),
    );
  }

  void logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Diagram Konsumsi"),
        backgroundColor: AppColor.primary,
        actions: [
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout),
          )
        ],
      ),

      body: Column(
        children: [
          const SizedBox(height: 10),
          buildChart(),

          Expanded(
            child: ListView(
              children: data.map((e) {
                return ListTile(
                  title: Text(e["nama"]),
                  subtitle: Text(
                    "Gula: ${e["gula"].toStringAsFixed(1)} g | "
                    "Kalori: ${e["kalori"].toStringAsFixed(1)} kkal",
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: tambahData,
        backgroundColor: AppColor.primary,
        child: const Icon(Icons.add),
      ),
    );
  }
}