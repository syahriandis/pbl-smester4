import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterForm extends StatelessWidget {
  final TextEditingController name;
  final TextEditingController email;
  final TextEditingController password;
  final TextEditingController confirmPassword;
  final TextEditingController umur;

  final String? gender;
  final Function(String?) onGenderChanged;
  final VoidCallback onSuccess;

  const RegisterForm({
    super.key,
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.umur,
    required this.gender,
    required this.onGenderChanged,
    required this.onSuccess,
  });

  InputDecoration inputStyle(String hint, IconData icon) {
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

  Future<void> register(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse("http://localhost:8000/api/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nama": name.text,
          "email": email.text,
          "password": password.text,
          "umur": umur.text,
          "gender": gender,
        }),
      );

      final data = jsonDecode(response.body);

      if (data["success"] == true) {
        onSuccess();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"])),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),

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

          const SizedBox(height: 30),

          // NAME
          TextField(
            controller: name,
            decoration: inputStyle("Nama Lengkap", Icons.person),
          ),

          const SizedBox(height: 18),

          // EMAIL
          TextField(
            controller: email,
            decoration: inputStyle("Email", Icons.email),
          ),

          const SizedBox(height: 18),

          // PASSWORD
          TextField(
            controller: password,
            obscureText: true,
            decoration: inputStyle("Password", Icons.lock),
          ),

          const SizedBox(height: 18),

          // CONFIRM PASSWORD
          TextField(
            controller: confirmPassword,
            obscureText: true,
            decoration: inputStyle("Konfirmasi Password", Icons.lock_outline),
          ),

          const SizedBox(height: 18),

          // UMUR
          TextField(
            controller: umur,
            keyboardType: TextInputType.number,
            decoration: inputStyle("Umur", Icons.cake),
          ),

          const SizedBox(height: 18),

          // GENDER
          DropdownButtonFormField<String>(
            value: gender,
            decoration: inputStyle("Pilih Gender", Icons.people),
            items: ["Laki-laki", "Perempuan"]
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ))
                .toList(),
            onChanged: onGenderChanged,
          ),

          const SizedBox(height: 30),

          // BUTTON REGISTER
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () {
                if (password.text != confirmPassword.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Password tidak sama"),
                    ),
                  );
                  return;
                }

                register(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
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
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Login",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}