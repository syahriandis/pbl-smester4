import 'package:flutter/material.dart';
import '../color.dart';
import 'home_page.dart';

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
  String? kategoriGula;
  bool isHidden = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        title: const Text("Register"),
        backgroundColor: AppColor.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [

              Text(
                "Buat Akun",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColor.primary,
                ),
              ),

              const SizedBox(height: 20),

              // Nama
              TextFormField(
                controller: name,
                validator: (value) =>
                    value!.isEmpty ? "Nama wajib diisi" : null,
                decoration: const InputDecoration(
                  labelText: "Nama",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              // Email
              TextFormField(
                controller: email,
                validator: (value) {
                  if (value!.isEmpty) return "Email wajib diisi";
                  if (!value.contains("@")) return "Email tidak valid";
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              // Password
              TextFormField(
                controller: password,
                obscureText: isHidden,
                validator: (value) {
                  if (value!.isEmpty) return "Password wajib diisi";
                  if (value.length < 6) return "Minimal 6 karakter";
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Password",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                        isHidden ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        isHidden = !isHidden;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Konfirmasi Password
              TextFormField(
                controller: confirmPassword,
                obscureText: isHidden,
                validator: (value) {
                  if (value != password.text) {
                    return "Password tidak sama";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Konfirmasi Password",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              // Umur
              TextFormField(
                controller: umur,
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? "Umur wajib diisi" : null,
                decoration: const InputDecoration(
                  labelText: "Umur",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              // Gender
              DropdownButtonFormField<String>(
                initialValue: gender,
                hint: const Text("Pilih Jenis Kelamin"),
                items: ["Laki-laki", "Perempuan"]
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    gender = val;
                  });
                },
                validator: (value) =>
                    value == null ? "Pilih jenis kelamin" : null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              // GULA DARAH (DROPDOWN)
              DropdownButtonFormField<String>(
                initialValue: kategoriGula,
                hint: const Text("Pilih Kondisi Gula Darah"),
                items: ["Rendah", "Normal", "Tinggi"]
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    kategoriGula = val;
                  });
                },
                validator: (value) =>
                    value == null ? "Pilih kondisi gula darah" : null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              // Button daftar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HomePage(
                            nama: name.text,
                            kategori: kategoriGula!,
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text("Daftar"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}