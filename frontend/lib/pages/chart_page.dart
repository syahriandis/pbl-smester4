import 'dart:convert';

import 'package:aplikasi_diabetes/pages/login_page.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../color.dart';

class ChartPage extends StatefulWidget {
  final int idUser;

  const ChartPage({
    super.key,
    required this.idUser,
  });

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  final TextEditingController gulaController = TextEditingController();

  String waktuDipilih = "Pagi";
  String filterGrafik = "7 Hari";
  String jumlahRiwayat = "10";

  bool isLoading = false;

  List<Map<String, dynamic>> riwayatGula = [];

  final String baseUrl = "http://127.0.0.1:8000/api";

  @override
  void initState() {
    super.initState();
    ambilDataGula();
  }

  Future<void> ambilDataGula() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/gula-darah/${widget.idUser}"),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        setState(() {
          riwayatGula = List<Map<String, dynamic>>.from(body['data']);
        });
      }
    } catch (e) {
      debugPrint("Error ambil data gula: $e");
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> tambahData() async {
    if (gulaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nilai gula darah wajib diisi")),
      );
      return;
    }

    int? nilai = int.tryParse(gulaController.text);

    if (nilai == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Masukkan angka yang valid")),
      );
      return;
    }

    final tanggalHariIni = DateTime.now().toIso8601String().split("T")[0];

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/gula-darah"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "id_user": widget.idUser,
          "tanggal": tanggalHariIni,
          "waktu": waktuDipilih,
          "nilai_gula": nilai,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        gulaController.clear();
        await ambilDataGula();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Data gula darah berhasil disimpan")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal simpan data: ${response.body}")),
        );
      }
    } catch (e) {
      debugPrint("Error simpan data gula: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tidak bisa terhubung ke server")),
      );
    }
  }

  Future<void> hapusData(int id) async {
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/gula-darah/$id"),
      );

      if (response.statusCode == 200) {
        await ambilDataGula();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Data berhasil dihapus")),
        );
      }
    } catch (e) {
      debugPrint("Error hapus data: $e");
    }
  }

  List<Map<String, dynamic>> getDataValid() {
    return riwayatGula.where((data) {
      return data["tanggal"] != null &&
          data["nilai_gula"] != null &&
          data["tanggal"].toString().isNotEmpty &&
          data["nilai_gula"].toString().isNotEmpty;
    }).toList();
  }

  List<Map<String, dynamic>> getDataGrafik() {
    final now = DateTime.now();
    final dataValid = getDataValid();

    if (filterGrafik == "Hari Ini") {
      return dataValid.where((data) {
        final tanggal = DateTime.tryParse(data["tanggal"].toString());

        if (tanggal == null) return false;

        return tanggal.year == now.year &&
            tanggal.month == now.month &&
            tanggal.day == now.day;
      }).toList();
    }

    final tujuhHariLalu = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(const Duration(days: 6));

    return dataValid.where((data) {
      final tanggal = DateTime.tryParse(data["tanggal"].toString());

      if (tanggal == null) return false;

      final tanggalOnly = DateTime(
        tanggal.year,
        tanggal.month,
        tanggal.day,
      );

      return tanggalOnly.isAfter(tujuhHariLalu) ||
          tanggalOnly.isAtSameMomentAs(tujuhHariLalu);
    }).toList();
  }

  String formatTanggal(dynamic tanggalValue) {
    final date = DateTime.tryParse(tanggalValue?.toString() ?? '');

    if (date == null) {
      return "-";
    }

    return "${date.day}/${date.month}";
  }

  String getStatus(int nilai) {
    if (nilai < 70) {
      return "Rendah";
    } else if (nilai <= 140) {
      return "Normal";
    } else if (nilai <= 199) {
      return "Waspada";
    } else {
      return "Tinggi";
    }
  }

  Color getStatusColor(int nilai) {
    if (nilai < 70) {
      return Colors.blue;
    } else if (nilai <= 140) {
      return Colors.green;
    } else if (nilai <= 199) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  double getRataRata(List<Map<String, dynamic>> data) {
    if (data.isEmpty) return 0;

    int total = 0;

    for (var item in data) {
      total += int.tryParse(item["nilai_gula"].toString()) ?? 0;
    }

    return total / data.length;
  }

  List<Map<String, dynamic>> getRiwayatTampil() {
    final semuaRiwayat = getDataValid().reversed.toList();

    if (jumlahRiwayat == "Semua") {
      return semuaRiwayat;
    }

    return semuaRiwayat.take(int.parse(jumlahRiwayat)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final dataGrafik = getDataGrafik();
    final riwayatTampil = getRiwayatTampil();

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
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    filterGrafik == "Hari Ini"
                        ? "Grafik Gula Darah Hari Ini"
                        : "Grafik Gula Darah 7 Hari Terakhir",
                    style: TextStyle(
                      color: AppColor.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ChoiceChip(
                        label: const Text("Hari Ini"),
                        selected: filterGrafik == "Hari Ini",
                        onSelected: (value) {
                          setState(() {
                            filterGrafik = "Hari Ini";
                          });
                        },
                      ),
                      const SizedBox(width: 10),
                      ChoiceChip(
                        label: const Text("7 Hari"),
                        selected: filterGrafik == "7 Hari",
                        onSelected: (value) {
                          setState(() {
                            filterGrafik = "7 Hari";
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    height: 260,
                    child: dataGrafik.isEmpty
                        ? const Center(
                            child: Text("Belum ada data gula darah"),
                          )
                        : LineChart(
                            LineChartData(
                              minY: 50,
                              maxY: 250,
                              gridData: const FlGridData(show: true),
                              borderData: FlBorderData(show: true),
                              titlesData: FlTitlesData(
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                leftTitles: const AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 40,
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 35,
                                    getTitlesWidget: (value, meta) {
                                      int index = value.toInt();

                                      if (index >= 0 &&
                                          index < dataGrafik.length) {
                                        return Text(
                                          filterGrafik == "Hari Ini"
                                              ? dataGrafik[index]["waktu"]
                                                      ?.toString() ??
                                                  "-"
                                              : formatTanggal(
                                                  dataGrafik[index]["tanggal"],
                                                ),
                                          style: const TextStyle(fontSize: 11),
                                        );
                                      }

                                      return const SizedBox();
                                    },
                                  ),
                                ),
                              ),
                              lineBarsData: [
                                LineChartBarData(
                                  isCurved: true,
                                  color: AppColor.primary,
                                  barWidth: 4,
                                  dotData: const FlDotData(show: true),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    color:
                                        AppColor.primary.withValues(alpha: 0.2),
                                  ),
                                  spots: List.generate(
                                    dataGrafik.length,
                                    (index) => FlSpot(
                                      index.toDouble(),
                                      double.tryParse(
                                            dataGrafik[index]["nilai_gula"]
                                                .toString(),
                                          ) ??
                                          0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColor.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Rata-rata gula darah: ${getRataRata(dataGrafik).toStringAsFixed(1)} mg/dL",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),

                  const SizedBox(height: 25),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Catat Kadar Gula Darah",
                      style: TextStyle(
                        color: AppColor.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: gulaController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Nilai gula darah",
                      hintText: "Contoh: 120",
                      suffixText: "mg/dL",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  DropdownButtonFormField<String>(
                    value: waktuDipilih,
                    decoration: InputDecoration(
                      labelText: "Waktu pemeriksaan",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: "Pagi", child: Text("Pagi")),
                      DropdownMenuItem(value: "Siang", child: Text("Siang")),
                      DropdownMenuItem(value: "Malam", child: Text("Malam")),
                    ],
                    onChanged: (value) {
                      setState(() {
                        waktuDipilih = value!;
                      });
                    },
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: tambahData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        "Simpan Data",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Riwayat Gula Darah",
                        style: TextStyle(
                          color: AppColor.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      DropdownButton<String>(
                        value: jumlahRiwayat,
                        items: const [
                          DropdownMenuItem(value: "5", child: Text("5")),
                          DropdownMenuItem(value: "10", child: Text("10")),
                          DropdownMenuItem(
                            value: "Semua",
                            child: Text("Semua"),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            jumlahRiwayat = value!;
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  riwayatTampil.isEmpty
                      ? const Text("Belum ada riwayat gula darah")
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: riwayatTampil.length,
                          itemBuilder: (context, index) {
                            final data = riwayatTampil[index];

                            final int id =
                                int.tryParse(data["id"].toString()) ?? 0;
                            final int nilai =
                                int.tryParse(data["nilai_gula"].toString()) ??
                                    0;

                            final String status = getStatus(nilai);

                            return Card(
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: getStatusColor(nilai),
                                  child: const Icon(
                                    Icons.bloodtype,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(
                                  "${data["tanggal"] ?? "-"} - ${data["waktu"] ?? "-"}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text("$nilai mg/dL"),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      status,
                                      style: TextStyle(
                                        color: getStatusColor(nilai),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: id == 0
                                          ? null
                                          : () {
                                              hapusData(id);
                                            },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
    );
  }
}