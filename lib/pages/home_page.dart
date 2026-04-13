import 'package:flutter/material.dart';
import '../color.dart';
import 'menu_page.dart';
import 'snack_page.dart';
import 'recipe_page.dart';
import 'chart_page.dart';
import 'login_page.dart';
import 'account_page.dart';

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

  late final pages = [
    MenuPage(),
    SnackDrinkPage(),
    RecipePage(),
    ChartPage(),
    AccountPage(),
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

      appBar: index == 3
      ? null
      : AppBar(
        title: const Text("Diabetes App"),
        backgroundColor: AppColor.primary,
        actions: [
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout),
          )
        ],
      ),

      body: pages[index], // <-- langsung tampilkan page

      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColor.primary,
        unselectedItemColor: Colors.grey,
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: "Menu"),
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: "Cemilan"),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Resep"),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: "Chart"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Akun"),
        ],
      ),
    );
  }
}