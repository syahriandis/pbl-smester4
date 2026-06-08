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
  final Map<String, dynamic> menuData = {};

  List<dynamic> menu = [];
  bool isLoading = true;

  final String apiKey = "0a15aa99961b4273b52d6a443bf551be";

  @override
  void initState() {
    super.initState();
    fetchMenu();
  }

  Future<void> fetchMenu() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.spoonacular.com/recipes/complexSearch?apiKey=$apiKey&number=6&diet=low-carb'));

      final data = jsonDecode(response.body);
      List temp = data['results'] ?? [];

      for (var item in temp) {
        final res = await http.get(Uri.parse(
            'https://api.spoonacular.com/recipes/${item['id']}/nutritionWidget.json?apiKey=$apiKey'));

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

  void showDetail(BuildContext context, dynamic item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
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
                    child: item["image"] != null
                        ? CachedNetworkImage(
                            imageUrl: item["image"].toString().replaceAll("http://", "https://"),
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(color: Colors.grey[200]),
                            errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
                          )
                        : Image.asset(item["gambar"] ?? "", fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: CircleAvatar(
                      backgroundColor: const Color.fromARGB(128, 0, 0, 0),
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
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
                      item["nama"] ?? item["title"] ?? "",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 12),
                    if (item["calories"] != null) ...[
                      const Text(
                        "Kandungan Nutrisi",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildNutrientBadge("🔥 Kalori", item["calories"], Colors.orange[50]!, Colors.orange[800]!),
                          _buildNutrientBadge("🍞 Karbo", item["carbs"], Colors.amber[50]!, Colors.amber[800]!),
                          _buildNutrientBadge("💪 Protein", item["protein"], Colors.red[50]!, Colors.red[800]!),
                        ],
                      ),
                    ] else ...[
                      _buildDetailRow("Komposisi", item["komposisi"]),
                      _buildDetailRow("Takaran", item["takaran"]),
                      _buildDetailRow("Resep", item["resep"]),
                    ],
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 11, color: textColor, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 13, color: textColor, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black87, fontSize: 14),
          children: [
            TextSpan(text: "$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: value ?? "-"),
          ],
        ),
      ),
    );
  }

  Widget buildCard(BuildContext context, Map item, Color warna) {
    return GestureDetector(
      onTap: () => showDetail(context, item),
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 14, bottom: 4),
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
              child: Image.asset(
                item["gambar"],
                height: 110,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                item["nama"] ?? "",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSection(String title, Map section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColor.primaryLight.withValues(alpha: 0.2),
              child: Icon(section["icon"], color: AppColor.primaryLight, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.5),
            ),
          ],
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 180,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: (section["data"] as List)
                .map((item) => buildCard(context, item, section["warna"]))
                .toList(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Menu Sehat", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (menuData.isNotEmpty) ...[
              ...menuData.entries.map((e) => buildSection(e.key, e.value)),
              const SizedBox(height: 24),
            ],
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.green[50],
                  child: Icon(Icons.cloud_download, color: Colors.green[700], size: 20),
                ),
                const SizedBox(width: 12),
                const Text(
                  "Rekomendasi Low-Carb (API)",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                ),
              ],
            ),
            const SizedBox(height: 14),
            if (isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: CircularProgressIndicator(),
                ),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: menu.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.78,
                ),
                itemBuilder: (_, i) {
                  final item = menu[i];

                  return GestureDetector(
                    onTap: () => showDetail(context, item),
                    child: Container(
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
                          Expanded(
                            child: SizedBox(
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                                child: CachedNetworkImage(
                                  imageUrl: item["image"].toString().replaceAll("http://", "https://"),
                                  fit: BoxFit.cover,
                                  placeholder: (_, __) => Container(color: Colors.grey[100]),
                                  errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              item["title"] ?? "",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                height: 1.2,
                              ),
                            ),
                          ),
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