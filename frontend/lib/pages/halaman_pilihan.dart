import 'package:flutter/material.dart';
import '../color.dart'; 
import 'home_page.dart'; // <-- 1. Ubah import dari chart_page ke home_page

class HalamanPilihan extends StatefulWidget {
  // 2. Tambahkan variabel untuk menampung data user dari halaman login
  final Map<String, dynamic> dataUser;

  const HalamanPilihan({super.key, required this.dataUser});

  @override
  State<HalamanPilihan> createState() => _HalamanPilihanState();
}

class _HalamanPilihanState extends State<HalamanPilihan> {
  final List<Map<String, dynamic>> daftarMakananSuka = [
    {"nama": "Buah Segar", "icon": Icons.apple, "terpilih": false},
    {"nama": "Sayuran Hijau", "icon": Icons.eco, "terpilih": false},
    {"nama": "Olahan Susu", "icon": Icons.egg_alt, "terpilih": false},
    {"nama": "Daging & Ikan", "icon": Icons.set_meal, "terpilih": false},
    {"nama": "Kacang-kacangan", "icon": Icons.grain, "terpilih": false},
    {"nama": "Jus Alami", "icon": Icons.local_drink, "terpilih": false},
  ];

  final List<Map<String, dynamic>> daftarAlergiMakanan = [
    {"nama": "Seafood / Udang", "icon": Icons.waves, "terpilih": false},
    {"nama": "Kacang Tanah", "icon": Icons.gavel, "terpilih": false},
    {"nama": "Gandum / Gluten", "icon": Icons.bakery_dining, "terpilih": false},
    {"nama": "Telur", "icon": Icons.egg, "terpilih": false},
    {"nama": "Susu Sapi (Laktosa)", "icon": Icons.water_drop, "terpilih": false},
    {"nama": "Tidak Ada Alergi", "icon": Icons.check_circle, "terpilih": false},
  ];

  void prosesSelesai() {
    List<String> pilihanSuka = daftarMakananSuka
        .where((item) => item["terpilih"] == true)
        .map((item) => item["nama"] as String)
        .toList();

    List<String> pilihanAlergi = daftarAlergiMakanan
        .where((item) => item["terpilih"] == true)
        .map((item) => item["nama"] as String)
        .toList();

    debugPrint("Makanan yang disukai: $pilihanSuka");
    debugPrint("Alergi makanan: $pilihanAlergi");

    // 3. DIUBAH: Sekarang pindah ke HomePage dengan membawa data user bawaan login
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(
          id: widget.dataUser["id"],                      
          nama: widget.dataUser["nama"],
          kategori: "-",
          email: widget.dataUser["email"],
          tanggalLahir: widget.dataUser["tanggal_lahir"], 
          umur: widget.dataUser["umur"],                  
          gender: widget.dataUser["gender"],
        ),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Personalisasi Akun"),
        backgroundColor: AppColor.primary, 
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Halo! Yuk sesuaikan aplikasimu 🌟",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Pilih preferensimu agar kami bisa memberikan rekomendasi menu makanan yang tepat dan aman untukmu.",
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 25),
            const Text(
              "Jenis makanan apa yang kamu suka?",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: daftarMakananSuka.map((item) {
                return FilterChip(
                  label: Text(item["nama"]),
                  avatar: Icon(
                    item["icon"], 
                    size: 18, 
                    color: item["terpilih"] ? Colors.white : AppColor.primary 
                  ),
                  selected: item["terpilih"],
                  selectedColor: AppColor.primary, 
                  checkmarkColor: Colors.white,
                  labelStyle: TextStyle(
                    color: item["terpilih"] ? Colors.white : Colors.black87,
                    fontWeight: item["terpilih"] ? FontWeight.bold : FontWeight.normal
                  ),
                  onSelected: (bool terpilih) {
                    setState(() {
                      item["terpilih"] = terpilih;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            const Divider(thickness: 1),
            const SizedBox(height: 15),
            const Text(
              "Apakah kamu memiliki alergi makanan?",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: daftarAlergiMakanan.map((item) {
                return FilterChip(
                  label: Text(item["nama"]),
                  avatar: Icon(
                    item["icon"], 
                    size: 18, 
                    color: item["terpilih"] ? Colors.white : Colors.red.shade700
                  ),
                  selected: item["terpilih"],
                  selectedColor: Colors.red.shade600,
                  checkmarkColor: Colors.white,
                  labelStyle: TextStyle(
                    color: item["terpilih"] ? Colors.white : Colors.black87,
                    fontWeight: item["terpilih"] ? FontWeight.bold : FontWeight.normal
                  ),
                  onSelected: (bool terpilih) {
                    setState(() {
                      if (item["nama"] == "Tidak Ada Alergi" && terpilih) {
                        for (var element in daftarAlergiMakanan) {
                          element["terpilih"] = false;
                        }
                      } else if (item["nama"] != "Tidak Ada Alergi" && terpilih) {
                        daftarAlergiMakanan.firstWhere((element) => element["nama"] == "Tidak Ada Alergi")["terpilih"] = false;
                      }
                      item["terpilih"] = terpilih;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primary, 
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: prosesSelesai,
                child: const Text(
                  "Selesai & Masuk ke Aplikasi",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}