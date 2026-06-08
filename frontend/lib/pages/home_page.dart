import 'package:flutter/material.dart';
import '../color.dart';

import 'menu_page.dart';
import 'food_page.dart';
import 'recipe_page.dart';
import 'chart_page.dart';
import 'profile_page.dart';
import 'login_page.dart';
import 'riwayat_page.dart';

import '../widgets/search_bar.dart';
import '../widgets/home_banner.dart';

class HomePage extends StatefulWidget {
  final int id; 
  final String nama;
  final String kategori;
  final String email;
  final String tanggalLahir; 
  final int umur; 
  final String gender;

  const HomePage({
    super.key,
    required this.id,
    required this.nama,
    required this.kategori,
    required this.email,
    required this.tanggalLahir,
    required this.umur,
    required this.gender,
  });

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int index = 0;
  List<String> riwayat = [];
  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      MenuPage(),
      FoodPage(),
      RecipePage(),
      ChartPage(),
      RiwayatPage(riwayat: riwayat, onDelete: deleteRiwayat),
    ];
  }

  void logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
      (route) => false,
    );
  }

  void deleteRiwayat(int index) {
    setState(() {
      riwayat.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        title: const Text("SobatGula"),
        backgroundColor: AppColor.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfilePage(
                    id: widget.id, 
                    nama: widget.nama,
                    email: widget.email,
                    tanggalLahir: widget.tanggalLahir, 
                    umur: widget.umur, 
                    gender: widget.gender,
                  ),
                ),
              );
            },
          ),
          IconButton(icon: const Icon(Icons.logout), onPressed: logout),
        ],
      ),
      body: Column(
        children: [
          
          if (index == 0) ...[
            SearchBarWidget(onChanged: (q) {}),
            HomeBanner(nama: widget.nama),
          ],
          
          Expanded(
            child: IndexedStack(index: index, children: pages),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        type: BottomNavigationBarType.fixed,
        onTap: (i) => setState(() => index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: "Menu"),
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: "Cemilan"),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Resep"),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: "Grafik"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "Riwayat"),
        ],
      ),
    );
  }
}