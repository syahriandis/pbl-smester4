import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import '../color.dart';

class MenuPage extends StatefulWidget {
  final int idUser;
  final String nama;
  final double gulaDarah; 

  const MenuPage({
    super.key,
    required this.idUser,
    required this.nama,
    required this.gulaDarah, 
  });

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<dynamic> menuSarapan = [];
  List<dynamic> menuSiang = [];
  List<dynamic> menuMalam = [];
  List<dynamic> menuCemilan = [];
  List<dynamic> menuMinuman = [];

  bool isLoading = true;
  final String apiKey = "0a15aa99961b4273b52d6a443bf551be";

  @override
  void initState() {
    super.initState();
    fetchAllMenus(); 
  }

  Future<void> fetchAllMenus() async {
    setState(() => isLoading = true);

    String kriteriaNutrisi = "";
    if (widget.gulaDarah > 140) {
      kriteriaNutrisi = "&maxCarbs=30&maxSugar=5&diet=low-carb";
    } else if (widget.gulaDarah < 70) {
      kriteriaNutrisi = "&minCarbs=20&maxCarbs=60";
    } else {
      kriteriaNutrisi = "&maxCarbs=50&diet=healthy";
    }

    try {
      await Future.wait([
        _getMenuByCategory("breakfast", kriteriaNutrisi).then((data) => menuSarapan = data),
        _getMenuByCategory("lunch", kriteriaNutrisi).then((data) => menuSiang = data),
        _getMenuByCategory("main course", kriteriaNutrisi).then((data) => menuMalam = data),
        _getMenuByCategory("snack", kriteriaNutrisi).then((data) => menuCemilan = data),
        _getMenuByCategory("beverage", kriteriaNutrisi).then((data) => menuMinuman = data),
      ]);

      if (mounted) {
        setState(() => isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<List<dynamic>> _getMenuByCategory(String type, String nutrisi) async {
    final url = 'https://api.spoonacular.com/recipes/complexSearch?apiKey=$apiKey&number=4&type=$type$nutrisi';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List results = data['results'] ?? [];

      for (var item in results) {
        final resNutri = await http.get(Uri.parse(
            'https://api.spoonacular.com/recipes/${item['id']}/nutritionWidget.json?apiKey=$apiKey'));
        if (resNutri.statusCode == 200) {
          final nutri = jsonDecode(resNutri.body);
          item['calories'] = nutri['calories'];
          item['carbs'] = nutri['carbs'];
          item['protein'] = nutri['protein'];
        }
      }
      return results;
    }
    return [];
  }

  String _bypasCorsUrl(String originalUrl) {
    String securedUrl = originalUrl.replaceAll("http://", "https://");
    return "https://cors-anywhere.herokuapp.com/$securedUrl";
  }

  Widget _buildCategorySection(String title, IconData icon, Color color, List<dynamic> data) {
    if (data.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: color.withAlpha(25),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 10),
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        SizedBox(
          height: 190,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              return GestureDetector(
                onTap: () => showDetail(context, item),
                child: Container(
                  width: 150,
                  margin: const EdgeInsets.only(right: 12, bottom: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(12),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        child: CachedNetworkImage(
                          imageUrl: _bypasCorsUrl(item["image"].toString()),
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(color: Colors.grey[100]),
                          errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item["title"] ?? "",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, height: 1.2),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item["calories"] != null ? "${item["calories"]}" : "Nutrisi siap",
                              style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _pilihDanUpdateGulaDarah(String menuTitle) async {
    int nilaiGulaBaru = widget.gulaDarah.toInt() + (widget.gulaDarah < 70 ? 25 : 15);
    final tanggalHariIni = DateTime.now().toIso8601String().split("T")[0];

    try {
      final response = await http.post(
        Uri.parse("http://127.0.0.1:8000/api/gula-darah"),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "id_user": widget.idUser,
          "tanggal": tanggalHariIni,
          "waktu": "Setelah Makan",
          "nilai_gula": nilaiGulaBaru,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("✅ Gula darah berhasil di-update dari pilihan menu.");
      }
    } catch (e) {
      debugPrint("Gagal update otomatis dari menu: $e");
    }
  }

  void showDetail(BuildContext context, dynamic item) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: EdgeInsets.zero,
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: CachedNetworkImage(
                      imageUrl: _bypasCorsUrl(item["image"].toString()),
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(color: Colors.grey[200]),
                      errorWidget: (_, __, ___) => const Icon(Icons.broken_image, size: 40),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: CircleAvatar(
                      backgroundColor: const Color.fromARGB(128, 0, 0, 0),
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(dialogContext),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item["title"] ?? "Menu Sehat",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    if (item["calories"] != null) ...[
                      const Text(
                        "Kandungan Nutrisi Sesuai Porsi",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildNutrientBadge("🔥 Kalori", item["calories"], Colors.orange[50]!, Colors.orange[800]!),
                          _buildNutrientBadge("🍞 Karbo", item["carbs"] ?? "-", Colors.amber[50]!, Colors.amber[800]!),
                          _buildNutrientBadge("💪 Protein", item["protein"] ?? "-", Colors.red[50]!, Colors.red[800]!),
                        ],
                      ),
                    ],
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.check_circle, color: Colors.white),
                        label: const Text("Pilih & Konsumsi Menu Ini", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        onPressed: () async {
                          Navigator.pop(dialogContext);
                          
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => const Center(child: CircularProgressIndicator()),
                          );

                          await _pilihDanUpdateGulaDarah(item["title"] ?? "Menu");

                          if (context.mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Berhasil memilih ${item['title']}. Data grafik gula darah Anda telah diperbarui!"),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNutrientBadge(String label, String value, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 11, color: textColor, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 12, color: textColor, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text("Rekomendasi Menu ${widget.nama}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCategorySection("Sarapan Sehat", Icons.wb_sunny, Colors.amber.shade700, menuSarapan),
                  _buildCategorySection("Makan Siang", Icons.light_mode, Colors.orange.shade700, menuSiang),
                  _buildCategorySection("Makan Malam", Icons.nightlight_round, Colors.indigo.shade700, menuMalam),
                  _buildCategorySection("Cemilan Sehat", Icons.cookie, Colors.brown.shade600, menuCemilan),
                  _buildCategorySection("Minuman Segar", Icons.local_cafe, Colors.teal.shade700, menuMinuman),
                ],
              ),
            ),
    );
  }
}