import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import '../color.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {

  // =========================
  // 🔥 DATA DUMMY (OFFLINE)
  // =========================
  final Map<String, dynamic> menuData = {
    "Menu": {
      "icon": Icons.restaurant,
      "warna": AppColor.primaryLight,
      "data": [
        {
          "nama": "Nasi Merah",
          "gambar": "assets/nasi_merah.jpg",
          "komposisi": "Beras merah",
          "resep": "Masak 30 menit",
          "takaran": "100 gram"
        },
        {
          "nama": "Ayam Rebus",
          "gambar": "assets/ayam.jpg",
          "komposisi": "Ayam",
          "resep": "Rebus tanpa minyak",
          "takaran": "1 potong"
        },
      ]
    },
    "Cemilan": {
      "icon": Icons.cake,
      "warna": Colors.purple.shade100,
      "data": [
        {
          "nama": "Pisang Rebus",
          "gambar": "assets/pisang.jpg",
          "komposisi": "Pisang",
          "resep": "Rebus hingga matang",
          "takaran": "1 buah"
        },
      ]
    },
    "Minuman": {
      "icon": Icons.local_drink,
      "warna": Colors.blue.shade100,
      "data": [
        {
          "nama": "Teh Hijau",
          "gambar": "assets/teh.jpg",
          "komposisi": "Teh",
          "resep": "Tanpa gula",
          "takaran": "1 gelas"
        },
      ]
    }
  };

  // =========================
  // 🔥 DATA API (ONLINE)
  // =========================
  List<dynamic> menu = [];
  bool isLoading = true;

  final String apiKey = "YOUR_API_KEY"; // ganti sendiri

  @override
  void initState() {
    super.initState();
    fetchMenu();
  }

  Future<void> fetchMenu() async {
    try {
      final response = await http.get(Uri.parse(
        'https://api.spoonacular.com/recipes/complexSearch?apiKey=$apiKey&number=6&diet=low-carb'
      ));

      final data = jsonDecode(response.body);
      List temp = data['results'];

      for (var item in temp) {
        final res = await http.get(Uri.parse(
          'https://api.spoonacular.com/recipes/${item['id']}/nutritionWidget.json?apiKey=$apiKey'
        ));

        if (res.statusCode == 200) {
          final nutri = jsonDecode(res.body);
          item['calories'] = nutri['calories'];
          item['carbs'] = nutri['carbs'];
          item['protein'] = nutri['protein'];
        }
      }

      setState(() {
        menu = temp;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  // =========================
  // 🔥 DETAIL DIALOG
  // =========================
  void showDetail(BuildContext context, dynamic item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                item["nama"] ?? item["title"] ?? "",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 10),

              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: item["image"] != null
                    ? CachedNetworkImage(
                        imageUrl: item["image"].toString().replaceAll("http://", "https://"),
                      )
                    : Image.asset(item["gambar"] ?? ""),
              ),

              const SizedBox(height: 10),

              if (item["calories"] != null) ...[
                Text("🔥 Kalori: ${item["calories"]}"),
                Text("🍞 Karbo: ${item["carbs"]}"),
                Text("💪 Protein: ${item["protein"]}"),
              ] else ...[
                Text("Komposisi: ${item["komposisi"] ?? "-"}"),
                Text("Takaran: ${item["takaran"] ?? "-"}"),
                Text("Resep: ${item["resep"] ?? "-"}"),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tutup"),
          )
        ],
      ),
    );
  }

  // =========================
  // 🔥 CARD DUMMY
  // =========================
  Widget buildCard(BuildContext context, Map item, Color warna) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: warna,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [

          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16),
            ),
            child: Image.asset(
              item["gambar"],
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 10),

          Text(item["nama"]),
        ],
      ),
    );
  }

  // =========================
  // 🔥 SECTION DUMMY
  // =========================
  Widget buildSection(String title, Map section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColor.primaryLight,
              child: Icon(section["icon"]),
            ),
            const SizedBox(width: 10),
            Text(title,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ],
        ),

        const SizedBox(height: 10),

        SizedBox(
          height: 250,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: (section["data"] as List)
                .map((item) => buildCard(context, item, section["warna"]))
                .toList(),
          ),
        ),
      ],
    );
  }

  // =========================
  // 🔥 BUILD UI
  // =========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [

            // 🔥 OFFLINE SECTION
            ...menuData.entries.map(
              (e) => buildSection(e.key, e.value),
            ),

            const SizedBox(height: 20),

            // 🔥 ONLINE SECTION
            if (isLoading)
              const CircularProgressIndicator()
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: menu.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (_, i) {
                  final item = menu[i];

                  return GestureDetector(
                    onTap: () => showDetail(context, item),
                    child: Card(
                      child: Column(
                        children: [
                          Expanded(
                            child: CachedNetworkImage(
                              imageUrl: item["image"]
                                  .toString()
                                  .replaceAll("http://", "https://"),
                            ),
                          ),
                          Text(item["title"]),
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