import 'package:flutter/material.dart';
import '../color.dart';

class SnackDrinkPage extends StatefulWidget {
  const SnackDrinkPage({super.key});

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

  // =========================
  // 🔢 HITUNG GULA
  // =========================
  double hitungGula(double jumlah, double takaran, double gulaPerSaji) {
    if (takaran == 0) return 0;
    return (jumlah / takaran) * gulaPerSaji;
  }

  String kategoriGula(double gula) {
    if (gula <= 25) return "Aman ✅";
    if (gula <= 50) return "Hati-hati ⚠️";
    return "Terlalu Tinggi ❌";
  }

  // =========================
  // 🔥 INPUT DIALOG
  // =========================
  void showInputDialog(BuildContext context, String title) {
    final namaCtrl = TextEditingController();
    final gulaCtrl = TextEditingController();
    final takaranCtrl = TextEditingController();
    final jumlahCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Tambah $title"),
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
                decoration: const InputDecoration(labelText: "Gula per Sajian"),
              ),
              TextField(
                controller: takaranCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Takaran"),
              ),
              TextField(
                controller: jumlahCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Jumlah konsumsi"),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primary,
            ),
            onPressed: () {
              double gula = hitungGula(
                double.tryParse(jumlahCtrl.text) ?? 0,
                double.tryParse(takaranCtrl.text) ?? 1,
                double.tryParse(gulaCtrl.text) ?? 0,
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

  // =========================
  // 🧃 LIST WIDGET
  // =========================
  Widget buildList(
    List<String> items,
    IconData icon,
    String subtitle,
    String type,
  ) {
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
              leading: Icon(icon, color: AppColor.primary),
              title: Text(e),
              subtitle: Text(subtitle),
            ),
          );
        }),

        const SizedBox(height: 20),

        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primary,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          onPressed: () => showInputDialog(context, type),
          icon: const Icon(Icons.add),
          label: Text("Tambah $type"),
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
            "Cemilan & Minuman",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColor.primary,
            ),
          ),
        ),

        // TAB BAR
        TabBar(
          controller: _tabController,
          labelColor: AppColor.primary,
          indicatorColor: AppColor.primary,
          tabs: const [
            Tab(text: "Snack"),
            Tab(text: "Minuman"),
          ],
        ),

        // CONTENT
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              buildList(
                snacks,
                Icons.fastfood,
                "Rekomendasi snack sehat",
                "Snack",
              ),
              buildList(
                drinks,
                Icons.local_drink,
                "Minuman aman diabetes",
                "Minuman",
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}