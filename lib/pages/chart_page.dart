import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../color.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  final List<Map<String, dynamic>> data = [];

  double get totalGula => data.fold(0, (s, e) => s + e["gula"]);
  double get totalKalori => data.fold(0, (s, e) => s + e["kalori"]);
  int get totalMakan => data.length;

  double toDouble(TextEditingController c) {
    return double.tryParse(c.text) ?? 0;
  }

  double hitung(double jml, double tkr, double perSaji) {
    return tkr == 0 ? 0 : (jml / tkr) * perSaji;
  }

  Widget input(TextEditingController c, String label) {
    return TextField(
      controller: c,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text("Tambah Konsumsi"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nama,
                decoration: InputDecoration(
                  labelText: "Nama",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              input(jumlah, "Jumlah"),
              const SizedBox(height: 12),
              input(takaran, "Takaran"),
              const SizedBox(height: 12),
              input(gula, "Gula / saji"),
              const SizedBox(height: 12),
              input(kalori, "Kalori / saji"),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primary,
            ),
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
    final colors = [Colors.blue, Colors.red, Colors.orange];

    return SizedBox(
      height: 260,
      child: BarChart(
        BarChartData(
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= labels.length || value.toInt() < 0) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      labels[value.toInt()],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
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
                  width: 24,
                  borderRadius: BorderRadius.circular(8),
                )
              ],
            );
          }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Mengikuti background milik HomePage

      // ✔️ DIUBAH: appBar di sini dihapus total agar tidak menabrak / terbalik posisinya

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian Diagram Konsumsi (Putih) langsung tampil di paling atas isi body
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Diagram Konsumsi",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  buildChart(),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Bagian List Data
            Expanded(
              child: data.isEmpty
                  ? const Center(
                      child: Text(
                        "Belum ada data konsumsi",
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (_, i) {
                        final e = data[i];

                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppColor.primaryLight,
                              child: const Icon(Icons.restaurant),
                            ),
                            title: Text(
                              e["nama"],
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "Gula: ${e["gula"].toStringAsFixed(1)} g\n"
                              "Kalori: ${e["kalori"].toStringAsFixed(1)} kkal",
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: tambahData,
        backgroundColor: AppColor.primary,
        child: const Icon(Icons.add),
      ),
    );
  }
}