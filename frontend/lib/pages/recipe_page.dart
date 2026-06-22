import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart'; // ✔ Cukup pakai ini gess, ga perlu dart:io atau show-showan
import '../color.dart';

class RecipePage extends StatefulWidget {
  final List<Map<String, dynamic>> riwayat;
  final Function(Map<String, dynamic>) onTambah;

  const RecipePage({
    super.key,
    required this.riwayat,
    required this.onTambah,
  });

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  List<dynamic> resep = [];
  bool isLoading = true;

  // ✔ URL Otomatis: persis seperti logika halaman loginmu gess!
  final String baseUrl = kIsWeb ? "http://localhost:8000" : "http://10.0.2.2:8000";

  @override
  void initState() {
    super.initState();
    fetchResep();
  }

  Future<void> fetchResep() async {
    try {
      // Tinggal gabungkan baseUrl dengan endpoint resep kamu gess
      final response = await http.get(Uri.parse("$baseUrl/api/resep"));

      if (response.statusCode == 200) {
        final dataJawab = json.decode(response.body);
        setState(() {
          resep = dataJawab['data'];
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      debugPrint("Error fetch data: $e");
      setState(() => isLoading = false);
    }
  }

  void tambahResep(BuildContext context, Map<String, dynamic> item) {
    final Map<String, dynamic> itemData = {
      "nama": item["nama"],
      "gambar": item["gambar"],
      "gula": 0.0, 
      "kalori": 0,
    };

    widget.onTambah(itemData);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${item['nama']} masuk ke riwayat gess!"),
        backgroundColor: AppColor.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void showDetail(BuildContext context, Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(item["nama"] ?? "", style: const TextStyle(fontWeight: FontWeight.bold)),
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
                          color: Colors.grey[100],
                          child:  Icon(Icons.restaurant_menu_rounded, size: 40, color: Colors.grey[400]),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildDetailSection(Icons.gavel_rounded, Colors.orange, "Takaran Bahan", item["komposisi"] ?? "-"),
                  const Divider(height: 24),
                  _buildDetailSection(Icons.menu_book_rounded, AppColor.primary, "Cara Membuat", item["cara"] ?? "-"),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                tambahResep(context, item);
                Navigator.pop(context);
              },
              child: const Text("Pilih Menu Ini", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailSection(IconData icon, Color iconColor, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(left: 28),
          child: Text(content, style: TextStyle(fontSize: 14, color: Colors.grey[800], height: 1.3)),
        ),
      ],
    );
  }

  Widget buildCard(BuildContext context, Map<String, dynamic> item) {
    return Container(
      width: 155,
      margin: const EdgeInsets.only(right: 14, bottom: 6, top: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Color.fromARGB(10, 0, 0, 0), blurRadius: 8, offset: Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: SizedBox(
              width: double.infinity,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                child: Image.asset(
                  item["gambar"] ?? "",
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Container(
                      color: Colors.grey[100],
                      child: Icon(Icons.restaurant_rounded, size: 36, color: Colors.grey[400]),
                    );
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: Text(
              item["nama"] ?? "",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
            child: Text(
              item["komposisi"] ?? "",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11, color: Colors.grey[600], height: 1.2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
            child: SizedBox(
              width: double.infinity,
              height: 32,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  side: BorderSide(color: Colors.grey[300]!),
                  padding: EdgeInsets.zero,
                ),
                onPressed: () => showDetail(context, item),
                child:  Text(
                  "Detail",
                  style: TextStyle(fontSize: 11, color: Colors.grey[700], fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : LayoutBuilder(
            builder: (context, constraints) {
              bool isMobile = constraints.maxWidth < 600;

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.fromLTRB(16, 20, 16, 4),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(color: Color.fromARGB(8, 0, 0, 0), blurRadius: 6, offset: Offset(0, 2))
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColor.primary.withAlpha(30),
                            child: Icon(Icons.menu_book_rounded, color: AppColor.primary),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Katalog Resep",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Resep sehat untuk kebutuhan harianmu",
                                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    isMobile
                        ? GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(16),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              mainAxisExtent: 260, 
                            ),
                            itemCount: resep.length,
                            itemBuilder: (context, index) {
                              return buildCard(context, Map<String, dynamic>.from(resep[index]));
                            },
                          )
                        : SizedBox(
                            height: 270,
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              itemCount: resep.length,
                              itemBuilder: (context, index) {
                                return buildCard(context, Map<String, dynamic>.from(resep[index]));
                              },
                            ),
                          ),
                  ],
                ),
              );
            },
          ),
    );
  }
}