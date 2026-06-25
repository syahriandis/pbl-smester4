import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../color.dart';
import 'home_page.dart';

class HalamanPilihan extends StatefulWidget {
  final Map<String, dynamic> dataUser;

  const HalamanPilihan({super.key, required this.dataUser});

  @override
  State<HalamanPilihan> createState() => _HalamanPilihanState();
}

class _HalamanPilihanState extends State<HalamanPilihan> {
  String get baseUrl {
    if (kIsWeb) {
      return "http://localhost:8000";
    }
    return "http://10.0.2.2:8000";
  }

  final List<Map<String, dynamic>> daftarMakananSuka = [
    {"name": "Buah Segar", "icon": Icons.apple, "terpilih": false},
    {"name": "Sayuran Hijau", "icon": Icons.eco, "terpilih": false},
    {"name": "Olahan Susu", "icon": Icons.egg_alt, "terpilih": false},
    {"name": "Daging & Ikan", "icon": Icons.set_meal, "terpilih": false},
    {"name": "Kacang-kacangan", "icon": Icons.grain, "terpilih": false},
    {"name": "Jus Alami", "icon": Icons.local_drink, "terpilih": false},
  ];

  final List<Map<String, dynamic>> daftarAlergiMakanan = [
    {"name": "Seafood / Udang", "icon": Icons.waves, "terpilih": false},
    {"name": "Kacang Tanah", "icon": Icons.gavel, "terpilih": false},
    {"name": "Gandum / Gluten", "icon": Icons.bakery_dining, "terpilih": false},
    {"name": "Telur", "icon": Icons.egg, "terpilih": false},
    {
      "name": "Suku Sapi (Laktosa)",
      "icon": Icons.water_drop,
      "terpilih": false
    },
    {"name": "Tidak Ada Alergi", "icon": Icons.check_circle, "terpilih": false},
  ];

  Future<void> kirimPreferensiKeServer(
      List<String> suka, List<String> alergi) async {
    try {
      final String fullUrl = "$baseUrl/api/save-preference";
      debugPrint("Menghubungi API Preferensi ke: $fullUrl");

      // Konflik Berhasil Digabung Di Sini Gess! Tanda <<<<<< dan ====== sudah hilang
      debugPrint(
          "Payload dikirim: user_id=${widget.dataUser["id"]}, suka=$suka, alergi=$alergi");

      final response = await http
          .post(
            Uri.parse(fullUrl),
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json"
            },
            body: jsonEncode({
              "id_user": widget.dataUser["id"],
              "makanan_suka": suka,
              "alergi_makanan": alergi,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final resData = jsonDecode(response.body);
        debugPrint("✅ Berhasil dari Laravel: ${resData['message']}");
      } else {
        debugPrint("❌ Gagal merespon server. Status: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ Terjadi Kesalahan Koneksi/Parsing: $e");
    }
  }

  void prosesSelesai() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    List<String> pilihanSuka = daftarMakananSuka
        .where((item) => item["terpilih"] == true)
        .map((item) => item["name"] as String)
        .toList();

    List<String> pilihanAlergi = daftarAlergiMakanan
        .where((item) => item["terpilih"] == true)
        .map((item) => item["name"] as String)
        .toList();

    await kirimPreferensiKeServer(pilihanSuka, pilihanAlergi);

    if (!mounted) return;
    Navigator.pop(context);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(
          idUser: int.tryParse(
                (widget.dataUser["id"] ??
                        widget.dataUser["id_user"] ??
                        widget.dataUser["IdUser"] ??
                        0)
                    .toString(),
              ) ??
              0,
          nama: widget.dataUser["nama"] ?? widget.dataUser["name"] ?? "-",
          kategori: widget.dataUser["kategori"] ?? "-",
          email: widget.dataUser["email"] ?? "-",
          tanggalLahir: widget.dataUser["tanggal_lahir"] ?? "-",
          umur: int.tryParse(
                (widget.dataUser["umur"] ?? 0).toString(),
              ) ??
              0,
          gender: widget.dataUser["gender"] ?? "-",
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
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: daftarMakananSuka.map((item) {
                return FilterChip(
                  label: Text(item["name"]),
                  avatar: Icon(item["icon"],
                      size: 18,
                      color:
                          item["terpilih"] ? Colors.white : AppColor.primary),
                  selected: item["terpilih"],
                  selectedColor: AppColor.primary,
                  checkmarkColor: Colors.white,
                  labelStyle: TextStyle(
                      color: item["terpilih"] ? Colors.white : Colors.black87,
                      fontWeight: item["terpilih"]
                          ? FontWeight.bold
                          : FontWeight.normal),
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
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: daftarAlergiMakanan.map((item) {
                return FilterChip(
                  label: Text(item["name"]),
                  avatar: Icon(item["icon"],
                      size: 18,
                      color: item["terpilih"]
                          ? Colors.white
                          : Colors.red.shade700),
                  selected: item["terpilih"],
                  selectedColor: Colors.red.shade600,
                  checkmarkColor: Colors.white,
                  labelStyle: TextStyle(
                      color: item["terpilih"] ? Colors.white : Colors.black87,
                      fontWeight: item["terpilih"]
                          ? FontWeight.bold
                          : FontWeight.normal),
                  onSelected: (bool terpilih) {
                    setState(() {
                      if (item["name"] == "Tidak Ada Alergi" && terpilih) {
                        for (var element in daftarAlergiMakanan) {
                          element["terpilih"] = false;
                        }
                      } else if (item["name"] != "Tidak Ada Alergi" &&
                          terpilih) {
                        daftarAlergiMakanan.firstWhere((element) =>
                            element["name"] ==
                            "Tidak Ada Alergi")["terpilih"] = false;
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
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: prosesSelesai,
                child: const Text(
                  "Selesai & Masuk ke Aplikasi",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
