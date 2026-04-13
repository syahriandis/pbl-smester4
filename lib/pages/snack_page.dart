import 'package:flutter/material.dart';
import '../color.dart';

class SnackDrinkPage extends StatefulWidget {
  const SnackDrinkPage({Key? key}) : super(key: key);

  @override
  State<SnackDrinkPage> createState() => _SnackDrinkPageState();
}

class _SnackDrinkPageState extends State<SnackDrinkPage>
    with SingleTickerProviderStateMixin {

  late TabController _tabController;

  final List<String> snacks = ["Almond", "Yogurt", "Apel"];
  final List<String> drinks = ["Air putih", "Teh tanpa gula", "Jus alpukat"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  // 🔢 HITUNG GULA
  double hitungGula(double jumlah, double takaran, double gulaPerSaji) {
    return (jumlah / takaran) * gulaPerSaji;
  }

  String kategoriGula(double gula) {
    if (gula <= 25) return "Aman ✅";
    if (gula <= 50) return "Hati-hati ⚠️";
    return "Terlalu Tinggi ❌";
  }

  // 🔥 DIALOG INPUT (DIPAKAI UNTUK KEDUA TAB)
  void showInputDialog(BuildContext context, String title) {
    final namaCtrl = TextEditingController();
    final gulaCtrl = TextEditingController();
    final takaranCtrl = TextEditingController();
    final jumlahCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Tambah $title dari Luar"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: namaCtrl,
                decoration: InputDecoration(labelText: "Nama $title"),
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
                  title: const Text("Hasil"),
                  content: Text(
                    "Total Gula: ${gula.toStringAsFixed(1)} g\nStatus: $status",
                  ),
                ),
              );
            },
            child: const Text("Hitung"),
          )
        ],
      ),
    );
  }

  // 🧃 WIDGET LIST
  Widget buildList(List<String> items, IconData icon, String subtitle, String type) {
    return ListView(
      padding: const EdgeInsets.all(10),
      children: [
        ...items.map((e) {
          return Card(
            color: AppColor.primaryLight,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              title: Text(e),
              leading: Icon(icon, color: AppColor.primary),
              subtitle: Text(subtitle),
            ),
          );
        }).toList(),

        const SizedBox(height: 20),

        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primary,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          onPressed: () => showInputDialog(context, type),
          icon: const Icon(Icons.add),
          label: Text("Tambah $type dari Luar"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // HEADER
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            "Cemilan",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColor.primary,
            ),
          ),
        ),

        // TAB
        TabBar(
          controller: _tabController,
          labelColor: AppColor.primary,
          tabs: const [
            Tab(text: "Snack"),
            Tab(text: "Minuman"),
          ],
        ),

        // ISI + SWIPE
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              buildList(
                snacks,
                Icons.fastfood,
                "Rekomendasi untuk gula stabil",
                "Snack",
              ),
              buildList(
                drinks,
                Icons.local_drink,
                "Aman untuk penderita diabetes",
                "Minuman",
              ),
            ],
          ),
        ),
      ],
    );
  }
}