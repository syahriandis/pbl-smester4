import 'package:flutter/material.dart';
import '../color.dart';

import 'register_page.dart';
import 'halaman_pilihan.dart';
import 'home_page.dart';
import '../widgets/login_form.dart';

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
                // 🌟 PROSES FILTER SEBELUM PINDAH HALAMAN 🌟
                // Mengecek field is_profile_completed (atau fallback ke is_personalized)
                var statusProfil = user["is_profile_completed"] ?? user["is_personalized"];
                
                // Konversi aman mendeteksi boolean dari Laravel/MySQL (bisa berupa true, 1, atau string)
                bool isProfileCompleted = (statusProfil == true || 
                                           statusProfil == 1 || 
                                           statusProfil == "1" || 
                                           statusProfil == "true");

                if (!context.mounted) return;

                if (isProfileCompleted) {
                  // JIKA USER LAMA (SUDAH PERNAH ISI) -> LANGSUNG MASUK HOMEPAGE
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HomePage(
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