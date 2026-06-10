import 'dart:convert';
import 'package:flutter/foundation.dart'; // Dibutuhkan untuk kIsWeb
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
  final tanggalLahir = TextEditingController(); 

  String? gender;

  // Menggunakan 'get' agar nilainya dinamis saat dipanggil
  String get baseUrl {
    if (kIsWeb) {
      return "http://localhost:8000";
    }
    return "http://10.0.2.2:8000";
  }

  Future<void> register() async {
    try {
      debugPrint("Menghubungi API ke: $baseUrl/api/register");

      // Mengubah request menjadi JSON murni agar serasi dengan backend
      final response = await http.post(
        Uri.parse("$baseUrl/api/register"), 
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json", // Diubah ke JSON
        },
        body: jsonEncode({
          "name": name.text.trim(), 
          "email": email.text.trim(),
          "password": password.text.trim(),
          "tanggal_lahir": tanggalLahir.text.trim(), 
          "gender": gender ?? "", 
        }),
      );

      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Isi Respon Mentah: ${response.body}");

      if (response.body.isEmpty) {
        throw const FormatException("Respon dari server kosong. Periksa CORS di Laravel.");
      }

      final data = jsonDecode(response.body);

      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 201 || data["success"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registrasi berhasil")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginPage()), 
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Registrasi gagal")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      debugPrint("❌ Detail Error: $e");
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
                tanggalLahir: tanggalLahir, 
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