import 'package:flutter/material.dart';
import '../color.dart';
import 'menu_page.dart';
import 'food_page.dart'; 
import 'recipe_page.dart';
import 'chart_page.dart';
import 'profile_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  final String nama;
  final String kategori;
  final String email;
  final String umur;
  final String gender;

  const HomePage({
    super.key,
    required this.nama,
    required this.kategori,
    required this.email,
    required this.umur,
    required this.gender,
  });

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int index = 0;

  final pages = [
    MenuPage(),
    FoodPage(), // 🔥 gabungan snack + drink
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
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfilePage(
                    nama: widget.nama,
                    email: widget.email,
                    umur: widget.umur,
                    gender: widget.gender,
                  ),
                ),
              );
            },
          ),
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColor.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text("Halo, ${widget.nama}"),
          ),

          Expanded(
            child: IndexedStack(
              index: index,
              children: pages,
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        type: BottomNavigationBarType.fixed,
        items:  [
          BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: "Menu"),
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: "Food"),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Resep"),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: "Chart"),
        ],
      ),
    );
  }
}