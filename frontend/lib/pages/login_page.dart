import 'package:flutter/material.dart';
import '../color.dart';

import 'register_page.dart';
import 'halaman_pilihan.dart'; 
import '../widgets/login_form.dart'; 

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController email = TextEditingController();
  final password = TextEditingController();

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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HalamanPilihan(dataUser: user), 
                  ),
                );
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