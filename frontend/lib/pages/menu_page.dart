import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../color.dart';

class MenuPage extends StatefulWidget {
  final int idUser;
  final String nama;
  final double gulaDarah;
  final String alergi;

  const MenuPage({
    super.key,
    required this.idUser,
    required this.nama,
    required this.gulaDarah,
    required this.alergi,
  });

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<Map<String, dynamic>> menuSarapan = [];
  List<Map<String, dynamic>> menuSiang = [];
  List<Map<String, dynamic>> menuMalam = [];
  List<Map<String, dynamic>> menuSnack = [];
  List<Map<String, dynamic>> menuMinuman = [];

  bool isLoading = true;

  String get baseUrl {
    if (kIsWeb) return "http://localhost:8000";
    return "http://10.0.2.2:8000";
  }

  @override
  void initState() {
    super.initState();
    fetchDataDariDatabase();
  }

  Future<void> fetchDataDariDatabase() async {
    setState(() => isLoading = true);

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/rekomendasi/${widget.idUser}"),
        headers: {"Accept": "application/json"},
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);

        if (result["success"] == true) {
          final data = result["data"];

          setState(() {
            menuSarapan =
                List<Map<String, dynamic>>.from(data["sarapan"] ?? []);
            menuSiang = List<Map<String, dynamic>>.from(data["siang"] ?? []);
            menuMalam = List<Map<String, dynamic>>.from(data["malam"] ?? []);

            // 🔥 FIX PENTING: backend biasanya "snack" bukan "cemilan"
            menuSnack = List<Map<String, dynamic>>.from(
                data["snack"] ?? data["cemilan"] ?? []);

            menuMinuman =
                List<Map<String, dynamic>>.from(data["minuman"] ?? []);
          });
        }
      }
    } catch (e) {
      debugPrint("ERROR: $e");
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Rekomendasi Menu")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(12),
              children: [
                _buildSection("Sarapan", menuSarapan),
                _buildSection("Siang", menuSiang),
                _buildSection("Malam", menuMalam),
                _buildSection("Snack", menuSnack),
                _buildSection("Minuman", menuMinuman),
              ],
            ),
    );
  }

  Widget _buildSection(
      String title, List<Map<String, dynamic>> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style:
              const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        if (items.isEmpty)
          const Text("Tidak ada rekomendasi",
              style: TextStyle(color: Colors.grey)),

        ...items.map((item) {
          return Card(
            child: ListTile(
              leading: Image.network(
                item["gambar"] ?? "",
                width: 50,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.image_not_supported),
              ),
              title: Text(item["nama"] ?? "-"),
              subtitle: Text(
                "Kalori: ${item["kalori"]} | Gula: ${item["gula"]}",
              ),
              onTap: () => showDetail(context, item, Colors.blue),
            ),
          );
        }),
        const SizedBox(height: 16),
      ],
    );
  }

  void showDetail(
    BuildContext context,
    Map<String, dynamic> item,
    Color themeColor,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
              item["gambar"] ?? "",
              height: 150,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.image_not_supported, size: 80),
            ),
            const SizedBox(height: 10),
            Text(
              item["nama"] ?? "-",
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text("Kalori: ${item["kalori"]}"),
            Text("Protein: ${item["protein"]}"),
            Text("Karbo: ${item["karbo"]}"),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primary,
                foregroundColor: AppColor.white,
              ),
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Tutup"),
            )
          ],
        ),
      ),
    );
  }
}