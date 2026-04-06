import 'package:flutter/material.dart';
import '../color.dart';
import 'menu_page.dart';
import 'snack_page.dart';
import 'drink_page.dart';
import 'recipe_page.dart';
import 'chart_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  final String nama;
  final String kategori;

  const HomePage({
    Key? key,
    required this.nama,
    required this.kategori,
  }) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int index = 0;

  final pages = [
    MenuPage(),
    SnackPage(),
    DrinkPage(),
    RecipePage(),
    ChartPage(),
  ];

  void logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,

      appBar: AppBar(
        title: const Text("Diabetes App"),
        backgroundColor: AppColor.primary,
        actions: [
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout),
          )
        ],
      ),

      body: Column(
        children: [
          // INFO USER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColor.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Halo, ${widget.nama}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text("Kategori Gula: ${widget.kategori}"),
              ],
            ),
          ),

          Expanded(child: pages[index]),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColor.primary,
        unselectedItemColor: Colors.grey,
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: "Menu"),
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: "Snack"),
          BottomNavigationBarItem(icon: Icon(Icons.local_drink), label: "Minum"),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Resep"),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: "Chart"),
        ],
      ),
    );
  }
}