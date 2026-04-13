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
  List<dynamic> menu = [];
  bool isLoading = true;

  final String apiKey = "4b42705d9667427893b40d1fbcfb7fed"; // 🔴 GANTI API KEY

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

      // ambil nutrisi tiap menu
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
      print("ERROR API: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void showDetail(BuildContext context, dynamic item) {
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item["title"],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: (item["image"] ?? "")
                        .replaceAll("http://", "https://"),
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) {
                      print("ERROR DETAIL: $url");
                      return const Icon(Icons.broken_image, size: 50);
                    },
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  "Nutrisi",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 6),

                Text("🔥 Kalori: ${item["calories"] ?? '-'}"),
                Text("🍞 Karbohidrat: ${item["carbs"] ?? '-'}"),
                Text("💪 Protein: ${item["protein"] ?? '-'}"),

                const SizedBox(height: 12),

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
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: menu.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (_, i) {
        final item = menu[i];

        return GestureDetector(
          onTap: () => showDetail(context, item),
          child: Container(
            decoration: BoxDecoration(
              color: AppColor.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: (item["image"] ?? "")
                          .replaceAll("http://", "https://"),
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) {
                        print("ERROR GRID: $url");
                        return const Icon(Icons.broken_image, size: 50);
                      },
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(6),
                  child: Text(
                    item["title"],
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),

                Text(
                  "🔥 ${item["calories"] ?? '-'}",
                  style: const TextStyle(fontSize: 11),
                ),

                const SizedBox(height: 6),
              ],
            ),
          ),
        );
      },
    );
  }
}