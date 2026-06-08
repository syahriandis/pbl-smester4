import 'package:flutter/material.dart';
import '../color.dart';

class FoodPage extends StatefulWidget {
  const FoodPage({super.key});

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  List<Map<String, dynamic>> drinks = [
    {
      "nama": "Air Putih",
      "gambar": "assets/air.jpg",
      "takaran": "250 ml",
      "gula": 0,
    },
    {
      "nama": "Teh Hijau",
      "gambar": "assets/teh.jpg",
      "takaran": "250 ml",
      "gula": 0,
    },
    {
      "nama": "Jus Alpukat",
      "gambar": "assets/alpukat.jpg",
      "takaran": "200 ml",
      "gula": 5,
    },
  ];

  List<Map<String, dynamic>> snacks = [
    {
      "nama": "Almond",
      "gambar": "assets/almond.jpg",
      "takaran": "30 g",
      "gula": 1,
    },
    {
      "nama": "Yogurt",
      "gambar": "assets/yogurt.jpg",
      "takaran": "100 g",
      "gula": 5,
    },
    {
      "nama": "Apel",
      "gambar": "assets/apel.jpg",
      "takaran": "150 g",
      "gula": 10,
    },
  ];

  int get totalDrinkSugar =>
      drinks.fold(0, (sum, item) => sum + (item["gula"] as int));

  int get totalSnackSugar =>
      snacks.fold(0, (sum, item) => sum + (item["gula"] as int));

  Widget warningBox(int total) {
    if (total <= 15) {
      return const SizedBox();
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.red[100]!),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_rounded,
            color: Colors.red[700],
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Peringatan: Total konsumsi gula terlalu tinggi!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.red[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void tambahMenu(bool isDrink) {
    TextEditingController nama = TextEditingController();
    TextEditingController takaran = TextEditingController();
    TextEditingController gula = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            isDrink ? "Tambah Minuman" : "Tambah Snack",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nama,
                  decoration: InputDecoration(
                    labelText: "Nama Menu",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: takaran,
                  decoration: InputDecoration(
                    labelText: "Takaran (misal: 250 ml, 50 g)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: gula,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Kandungan Gula (gram)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Batal",
                style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              onPressed: () {
                final item = {
                  "nama": nama.text,
                  "gambar": "",
                  "takaran": takaran.text,
                  "gula": int.tryParse(gula.text) ?? 0,
                };

                setState(() {
                  if (isDrink) {
                    drinks.add(item);
                  } else {
                    snacks.add(item);
                  }
                });

                Navigator.pop(context);
              },
              child: const Text("Tambah", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void showDetail(Map item) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            item["nama"],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.scale, color: Colors.grey, size: 20),
                  const SizedBox(width: 8),
                  Text("Takaran Saji: ${item["takaran"]}", style: const TextStyle(fontSize: 15)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.cookie, color: Colors.amber, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    "Kandungan Gula: ${item["gula"]} g",
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Tutup", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  Widget buildCard(Map item, Color indicatorColor) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 14, bottom: 6, top: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(10, 0, 0, 0),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: item["gambar"] != ""
                ? Image.asset(
                    item["gambar"],
                    height: 95,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 95,
                    width: double.infinity,
                    color: Colors.grey[100],
                    child: Icon(
                      Icons.fastfood_rounded,
                      size: 36,
                      color: Colors.grey[400],
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
            child: Text(
              item["nama"],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: indicatorColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "${item["gula"]} g Gula",
                style: TextStyle(
                  fontSize: 11,
                  color: indicatorColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: SizedBox(
              width: double.infinity,
              height: 32,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  side: BorderSide(color: Colors.grey[300]!),
                  padding: EdgeInsets.zero,
                ),
                onPressed: () => showDetail(item),
                child: Text(
                  "Detail",
                  style: TextStyle(fontSize: 12, color: Colors.grey[700], fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSugarDashboard(int totalAmount) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(8, 0, 0, 0),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Akumulasi Gula",
                style: TextStyle(fontSize: 12, color: Colors.grey[50], fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              Text(
                "$totalAmount gram",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: totalAmount > 15 ? Colors.red[50] : Colors.green[50],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              totalAmount > 15 ? "Overlimit" : "Aman",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: totalAmount > 15 ? Colors.red[700] : Colors.green[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: AppColor.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          titleSpacing: 0, 
          title: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Color.fromARGB(179, 255, 255, 255),
            indicatorWeight: 3,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            tabs: [
              Tab(text: "Minuman"),
              Tab(text: "Snack"),
            ],
          ),
        ),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              backgroundColor: AppColor.primaryLight,
              foregroundColor: Colors.white,
              elevation: 4,
              onPressed: () {
                final tabIndex = DefaultTabController.of(context).index;
                tambahMenu(tabIndex == 0);
              },
              child: const Icon(Icons.add, size: 28),
            );
          },
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  warningBox(totalDrinkSugar),
                  _buildSugarDashboard(totalDrinkSugar),
                  SizedBox(
                    height: 240,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: drinks.length,
                      itemBuilder: (context, index) {
                        return buildCard(drinks[index], Colors.blue[700]!);
                      },
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  warningBox(totalSnackSugar),
                  _buildSugarDashboard(totalSnackSugar),
                  SizedBox(
                    height: 240,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: snacks.length,
                      itemBuilder: (context, index) {
                        return buildCard(snacks[index], Colors.orange[700]!);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}