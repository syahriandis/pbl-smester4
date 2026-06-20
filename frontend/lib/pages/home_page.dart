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
  final int idUser; 
  final String nama;
  final String kategori;
  final String email;
  final String tanggalLahir; 
  final int umur; 
  final String gender;

  const HomePage({
    super.key,
    required this.idUser,
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
  
  // Tampungan data riwayat menggunakan format List<Map> agar muat data objek dari API Laravel
  List<Map<String, dynamic>> riwayat = [];

  // Fungsi jembatan untuk menambah makanan/minuman yang diklik dari FoodPage
  void tambahRiwayat(Map<String, dynamic> item) {
    setState(() {
      riwayat.add(item);
    });
  }

  // Fungsi untuk menghapus item riwayat berdasarkan index-nya
  void deleteRiwayat(int itemIndex) {
    setState(() {
      riwayat.removeAt(itemIndex);
    });
  }

  void logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) =>  LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Konflik Berhasil Digabung: Array livePages dipasok data paling fresh beserta parameter ChartPage kawan lu
    final List<Widget> livePages = [
      const MenuPage(),
      FoodPage(
        riwayat: riwayat,
        onTambah: tambahRiwayat,
        onDelete: deleteRiwayat,
      ),
      RecipePage(),
      ChartPage(idUser: widget.idUser), // Fitur kawan lu aman di sini gess!
      RiwayatPage(
        riwayat: riwayat, 
        onDelete: deleteRiwayat,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        title: const Text("SobatGula", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColor.primary,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false, // Biar ga ada tombol back setelah masuk dari HalamanPilihan
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfilePage(
                    id: widget.idUser, 
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
          // Search bar dan banner hanya ngetem di tab Menu (index 0) gess
          if (index == 0) ...[
            SearchBarWidget(onChanged: (q) {}),
            HomeBanner(nama: widget.nama),
          ],
          
          Expanded(
            child: IndexedStack(
              index: index, 
              children: livePages,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColor.primary,
        unselectedItemColor: Colors.grey,
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