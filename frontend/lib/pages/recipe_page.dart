import 'package:flutter/material.dart';
import '../color.dart';

class RecipePage extends StatelessWidget {
  RecipePage({super.key});

  final List<Map<String, String>> resep = [
    {
      "nama": "Sup Sayur",
      "gambar": "assets/sup.jpg",
      "komposisi": "Wortel, Kol, Kentang, Air",
      "cara": "Rebus semua bahan hingga matang"
    },
    {
      "nama": "Ayam Rebus",
      "gambar": "assets/ayam.jpg",
      "komposisi": "Ayam tanpa kulit, Air",
      "cara": "Rebus ayam hingga matang tanpa minyak"
    },
  ];

  void showDetail(BuildContext context, Map<String, String> item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(item["nama"] ?? ""),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
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

                  const Text(
                    "Komposisi",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 5),

                  Text(item["komposisi"] ?? "-"),

                  const SizedBox(height: 10),

                  const Text(
                    "Cara Membuat",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 5),

                  Text(item["cara"] ?? "-"),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Tutup"),
            ),
          ],
        );
      },
    );
  }

  Widget buildCard(BuildContext context, Map<String, String> item) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),

      decoration: BoxDecoration(
        color: AppColor.primaryLight, // ✔ FIX DI SINI
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
                side: BorderSide(color: AppColor.primary), // ✔ FIX
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () => showDetail(context, item),
              child: const Text("Lihat Detail"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background, // ✔ FIX

      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColor.primaryLight,
                  child: const Icon(Icons.menu_book),
                ),
                const SizedBox(width: 10),
                const Text(
                  "Resep",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 5),

            const Text(
              "Resep sehat untuk kebutuhan harianmu",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 10),

            SizedBox(
              height: 250,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: resep
                    .map((item) => buildCard(context, item))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}