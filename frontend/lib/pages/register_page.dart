import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final name = TextEditingController();
  final umur = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  String? gender;

  Future<void> register() async {
    try {
      final response = await http.post(
        Uri.parse("http://127.0.0.1:8000/api/register"),
        headers: {
          "Accept": "application/json",
        },
        body: {
          "username": name.text,
          "email": email.text,
          "password": password.text,
          "umur": umur.text,
          "jenis_kelamin" : gender ?? "",
        },
      );

      final data = jsonDecode(response.body);

      if (!mounted) return;

      if (data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registrasi berhasil")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => LoginPage(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? "Registrasi gagal")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tidak bisa terhubung ke server")),
      );
    }
  }

  InputDecoration inputStyle({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF4CAF50),
              Color(0xFF81C784),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Icon(
                        Icons.person_add_alt_1,
                        size: 80,
                        color: Colors.green,
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "Buat Akun",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Silakan isi data diri Anda",
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 30),

                      TextFormField(
                        controller: name,
                        validator: (v) =>
                            v!.isEmpty ? "Nama wajib diisi" : null,
                        decoration: inputStyle(
                          hint: "Nama Lengkap",
                          icon: Icons.person,
                        ),
                      ),

                      const SizedBox(height: 18),

                      TextFormField(
                        controller: email,
                        validator: (v) =>
                            v!.isEmpty ? "Email wajib diisi" : null,
                        decoration: inputStyle(
                          hint: "Email",
                          icon: Icons.email,
                        ),
                      ),

                      const SizedBox(height: 18),

                      TextFormField(
                        controller: password,
                        obscureText: true,
                        validator: (v) =>
                            v!.isEmpty ? "Password wajib diisi" : null,
                        decoration: inputStyle(
                          hint: "Password",
                          icon: Icons.lock,
                        ),
                      ),

                      const SizedBox(height: 18),

                      TextFormField(
                        controller: confirmPassword,
                        obscureText: true,
                        validator: (v) => v!.isEmpty
                            ? "Konfirmasi password wajib diisi"
                            : null,
                        decoration: inputStyle(
                          hint: "Konfirmasi Password",
                          icon: Icons.lock_outline,
                        ),
                      ),

                      const SizedBox(height: 18),

                      TextFormField(
                        controller: umur,
                        keyboardType: TextInputType.number,
                        decoration: inputStyle(
                          hint: "Umur",
                          icon: Icons.cake,
                        ),
                      ),

                      const SizedBox(height: 18),

                      DropdownButtonFormField<String>(
                        value: gender,
                        decoration: inputStyle(
                          hint: "Pilih Gender",
                          icon: Icons.people,
                        ),
                        items: ["Laki-laki", "Perempuan"]
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            gender = val;
                          });
                        },
                      ),

                      const SizedBox(height: 30),

                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (password.text != confirmPassword.text) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Password tidak sama"),
                                  ),
                                );
                                return;
                              }

                              await register();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            "Daftar",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Sudah punya akun?"),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}