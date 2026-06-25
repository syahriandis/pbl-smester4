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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HomePage(
                        idUser: user['id'],
                        nama: user['name'] ?? '',
                        kategori: user['kategori'] ?? '',
                        email: user['email'] ?? '',
                        tanggalLahir: user['tanggal_lahir'] ?? '',
                        umur: user['umur'] ?? 0,
                        gender: user['gender'] ?? '',
                      ),
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