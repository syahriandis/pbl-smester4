import 'package:flutter/material.dart';
import '../color.dart';

import 'register_page.dart';
<<<<<<< Updated upstream
import 'halaman_pilihan.dart';
import 'home_page.dart';
import '../widgets/login_form.dart';
=======
import 'halaman_pilihan.dart'; 
import 'home_page.dart'; // ✔ Pastikan import HomePage lo udah bener gess
import '../widgets/login_form.dart'; 
>>>>>>> Stashed changes

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColor.primary,
              AppColor.primaryLight,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: LoginForm(
              email: email,
              password: password,
              onLoginSuccess: (user) {
<<<<<<< Updated upstream
                final isPersonalized =
                    user['is_personalized'].toString() == '1';

                if (!isPersonalized) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HalamanPilihan(dataUser: user),
                    ),
                  );
                } else {
=======
                // 🌟 PROSES FILTER SEBELUM PINDAH HALAMAN 🌟
                var statusProfil = user["is_profile_completed"];
                
                // Konversi aman mendeteksi boolean dari Laravel/MySQL (bisa berupa true, 1, atau string)
                bool isProfileCompleted = (statusProfil == true || 
                                           statusProfil == 1 || 
                                           statusProfil == "1" || 
                                           statusProfil == "true");

                if (!context.mounted) return;

                if (isProfileCompleted) {
                  // JIKA USER LAMA (SUDAH PERNAH ISI) -> LANGSUNG MASUK HOMEPAGE
>>>>>>> Stashed changes
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HomePage(
<<<<<<< Updated upstream
                        idUser: user['id'],
                        nama: user['name'] ?? '',
                        kategori: user['kategori'] ?? '',
                        email: user['email'] ?? '',
                        tanggalLahir: user['tanggal_lahir'] ?? '',
                        umur: user['umur'] ?? 0,
                        gender: user['gender'] ?? '',
                      ),
=======
                        idUser: int.tryParse(user["id"].toString()) ?? 0,
                        nama: user["nama"] ?? user["name"] ?? "-",
                        kategori: user["kategori"] ?? "-",
                        email: user["email"] ?? "-",
                        tanggalLahir: user["tanggal_lahir"] ?? "-",
                        umur: int.tryParse((user["umur"] ?? 0).toString()) ?? 0,
                        gender: user["gender"] ?? "-",
                      ), 
                    ),
                  );
                } else {
                  // JIKA USER BARU -> WAJIB MASUK HALAMAN PILIHAN DULU
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HalamanPilihan(dataUser: user), 
>>>>>>> Stashed changes
                    ),
                  );
                }
              },
              onRegister: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RegisterPage(),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}