import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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
  List<Map<String, dynamic>> riwayat = [];
  
  // Variabel medis dinamis dari database backend
  double gulaDarahUser = 0.0; 
  String alergiUser = ""; 
  bool isLoadingData = true;

  final String baseUrl = kIsWeb ? "http://localhost:8000" : "http://10.0.2.2:8000";

  @override
  void initState() {
    super.initState();
    fetchDataUserTerbaru(); 
  }

  // Fungsi sinkronisasi data alergi & gula darah dari backend
  Future<void> fetchDataUserTerbaru() async {
    try {
      final res = await http.get(Uri.parse("$baseUrl/api/user/${widget.idUser}"));
      if (res.body.isNotEmpty) {
        final data = jsonDecode(res.body);
        if (data["success"] == true && data["user"] != null) {
          setState(() {
            gulaDarahUser = double.tryParse(data["user"]["gula_darah"].toString()) ?? 0.0;
            alergiUser = data["user"]["alergi"] ?? "";
            isLoadingData = false;
          });
          return;
        }
      }
    } catch (e) {
      debugPrint("Gagal sinkronisasi data medis di HomePage: $e");
    }
    setState(() => isLoadingData = false);
  }

  void tambahRiwayat(Map<String, dynamic> item) {
    setState(() {
      riwayat.add(item);
    });
  }

  void deleteRiwayat(int itemIndex) {
    setState(() {
      riwayat.removeAt(itemIndex);
    });
  }

  void logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> livePages = [
      isLoadingData 
          ? const Center(child: CircularProgressIndicator())
          : MenuPage(
              idUser: widget.idUser,
              nama: widget.nama,
              gulaDarah: gulaDarahUser, 
              alergi: alergiUser,       
            ),
      FoodPage(
        riwayat: riwayat,
        onTambah: tambahRiwayat,
        onDelete: deleteRiwayat,
      ),
      RecipePage(
        riwayat: riwayat,
        onTambah: tambahRiwayat,
      ),
      ChartPage(idUser: widget.idUser), 
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
        automaticallyImplyLeading: false, 
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () async {
              // Menunggu halaman profile ditutup, lalu refresh data rekomendasi makanan
              await Navigator.push(
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
              fetchDataUserTerbaru();
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