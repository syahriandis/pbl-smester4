import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'login_page.dart';
import '../widgets/register_form.dart'; 

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final tanggalLahir = TextEditingController(); // Mengubah variabel umur menjadi tanggalLahir

  String? gender;

  Future<void> register() async {
    try {
      final response = await http.post(
        Uri.parse("http://localhost:8000/api/register"), 
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          "name": name.text.trim(), 
          "email": email.text.trim(),
          "password": password.text.trim(),
          "tanggal_lahir": tanggalLahir.text.trim(), // Mengirim string berformat YYYY-MM-DD
          "gender": gender ?? "", 
        },
      );

      final data = jsonDecode(response.body);

      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 201 || data["success"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registrasi berhasil")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginPage()), // Hapus kata kunci 'const' jika LoginPage memicu error compiler
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Registrasi gagal")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    tanggalLahir.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: RegisterForm(
                name: name,
                email: email,
                password: password,
                confirmPassword: confirmPassword,
                tanggalLahir: tanggalLahir, // Melempar controller tanggalLahir ke form widget
                gender: gender,
                onGenderChanged: (val) {
                  setState(() {
                    gender = val;
                  });
                },
                onRegisterPressed: () async {
                  await register();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}