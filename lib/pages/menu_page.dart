import 'package:flutter/material.dart';
import '../color.dart';

class MenuPage extends StatelessWidget {
  MenuPage({super.key});

  final List<Map<String, String>> menu = [
    {
      "nama": "Nasi Merah",
      "gambar": "assets/nasi_merah.jpg",
      "komposisi": "Beras merah",
      "cara": "Masak seperti nasi biasa"
    },
    {
      "nama": "Ayam Rebus",
      "gambar": "assets/ayam.jpg",
      "komposisi": "Ayam",
      "cara": "Rebus hingga matang"
    },
    {
      "nama": "Sayur Bayam",
      "gambar": "assets/bayam.jpg",
      "komposisi": "Bayam",
      "cara": "Rebus sebentar"
    },
    {
      "nama": "Ikan Bakar",
      "gambar": "assets/ikan.jpg",
      "komposisi": "Ikan",
      "cara": "Bakar hingga matang"
    },
  ];

  void showDetail(BuildContext context, Map<String, String> item) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item["nama"]!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(item["gambar"]!),
                ),

                const SizedBox(height: 8),

                const Text("Komposisi", style: TextStyle(fontWeight: FontWeight.bold)),
                Text(item["komposisi"]!),

                const SizedBox(height: 8),

                const Text("Cara Membuat", style: TextStyle(fontWeight: FontWeight.bold)),
                Text(item["cara"]!),

                const SizedBox(height: 10),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Tutup"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: menu.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // 🔥 SUPER KECIL (4 kolom)
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (_, i) {
        final item = menu[i];

        return GestureDetector(
          onTap: () => showDetail(context, item),

          child: Container(
            decoration: BoxDecoration(
              color: AppColor.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                // GAMBAR
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(10),
                    ),
                    child: Image.asset(
                      item["gambar"]!,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // NAMA (KECIL)
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    item["nama"]!,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),

                // KOMPOSISI MINI
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    item["komposisi"]!,
                    style: const TextStyle(fontSize: 8),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                const SizedBox(height: 3),
              ],
            ),
          ),
        );
      },
    );
  }
}