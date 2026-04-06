import 'package:flutter/material.dart';
import '../color.dart';

class SnackPage extends StatelessWidget {
  final List<String> snacks = [
    "Almond",
    "Yogurt",
    "Apel",
  ];

  double hitungGula(double jumlah, double takaran, double gulaPerSaji) {
    return (jumlah / takaran) * gulaPerSaji;
  }

  String kategoriGula(double gula) {
    if (gula <= 25) return "Aman ✅";
    if (gula <= 50) return "Hati-hati ⚠️";
    return "Terlalu Tinggi ❌";
  }

  void showInputDialog(BuildContext context) {
    final namaCtrl = TextEditingController();
    final gulaCtrl = TextEditingController();
    final takaranCtrl = TextEditingController();
    final jumlahCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Tambah Snack dari Luar"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: namaCtrl,
                decoration: InputDecoration(labelText: "Nama Snack"),
              ),
              TextField(
                controller: gulaCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Gula per Sajian (g)"),
              ),
              TextField(
                controller: takaranCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Takaran Sajian"),
              ),
              TextField(
                controller: jumlahCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Jumlah Dikonsumsi"),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              double gula = hitungGula(
                double.parse(jumlahCtrl.text),
                double.parse(takaranCtrl.text),
                double.parse(gulaCtrl.text),
              );

              String status = kategoriGula(gula);

              Navigator.pop(context);

              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text("Hasil"),
                  content: Text(
                    "Total Gula: ${gula.toStringAsFixed(1)} g\nStatus: $status",
                  ),
                ),
              );
            },
            child: Text("Hitung"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rekomendasi Snack"),
        backgroundColor: AppColor.primary,
      ),

      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          // 🔹 LIST REKOMENDASI
          ...snacks.map((e) {
            return Card(
              color: AppColor.primaryLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                title: Text(e),
                leading: Icon(Icons.fastfood, color: AppColor.primary),
                subtitle: Text("Rekomendasi untuk gula darah stabil"),
              ),
            );
          }).toList(),

          SizedBox(height: 20),

          // 🔥 BUTTON TAMBAH DARI LUAR
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primary,
              padding: EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: () => showInputDialog(context),
            icon: Icon(Icons.add),
            label: Text("Tambah Snack dari Luar"),
          ),
        ],
      ),
    );
  }
}