import 'package:flutter/material.dart';
import '../color.dart';

class MenuPage extends StatelessWidget {
  MenuPage({super.key});

  final Map<String, dynamic> menuData = {
    "Menu": {
      "icon": Icons.restaurant,
      "warna": AppColor.primaryLight,
      "data": [
        {
          "nama": "Nasi Merah",
          "gambar": "assets/nasi_merah.jpg",
          "komposisi": "Beras merah",
          "resep": "Masak beras merah ±30 menit",
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
          "resep": "Seduh tanpa gula",
          "takaran": "1 gelas"
        },
      ]
    }
  };

  void showDetail(BuildContext context, Map item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(item["nama"] ?? ""),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [

              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  item["gambar"] ?? "",
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Container(
                      height: 150,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.image),
                    );
                  },
                ),
              ),

              const SizedBox(height: 15),

              Text("Komposisi: ${item["komposisi"] ?? "-"}"),
              const SizedBox(height: 8),

              Text("Takaran: ${item["takaran"] ?? "-"}"),
              const SizedBox(height: 8),

              Text("Resep: ${item["resep"] ?? "-"}"),
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

  Widget buildCard(
    BuildContext context,
    Map item,
    Color warna,
  ) {
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
              item["gambar"] ?? "",
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  height: 100,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.image),
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              item["nama"] ?? "",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),

          const SizedBox(height: 5),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              item["komposisi"] ?? "",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),

          const Spacer(),

          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColor.primary),
              ),
              onPressed: () => showDetail(context, item),
              child: const Text("Lihat Detail"),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSection(
    BuildContext context,
    String title,
    Map section,
  ) {
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
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 5),

        const Text(
          "Menu sehat untuk kebutuhan harianmu",
          style: TextStyle(color: Colors.grey),
        ),

        const SizedBox(height: 10),

        SizedBox(
          height: 250,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: (section["data"] as List)
                .map(
                  (item) => buildCard(
                    context,
                    item,
                    section["warna"],
                  ),
                )
                .toList(),
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: menuData.entries
              .map((e) => buildSection(context, e.key, e.value))
              .toList(),
        ),
      ),
    );
  }
}