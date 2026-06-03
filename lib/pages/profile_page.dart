import 'dart:convert';
import 'package:flutter/foundation.dart'; // Dibutuhkan untuk mendeteksi kIsWeb
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Memanggil widget yang sudah dipisah tadi
import '../widgets/profile_widget.dart';

class ProfilePage extends StatefulWidget {
  final String nama;
  final String email;
  final String umur;
  final String gender;

  const ProfilePage({
    super.key,
    required this.nama,
    required this.email,
    required this.umur,
    required this.gender,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController nama;
  late TextEditingController email;
  late TextEditingController umur;
  late TextEditingController gender;

  final berat = TextEditingController();
  final tinggi = TextEditingController();

  bool isEdit = false;
  bool isLoading = false;

  // Otomatis ganti ke localhost jika running di Chrome (Web)
  final String baseUrl = kIsWeb ? "http://localhost:8000" : "http://10.0.2.2:8000";

  @override
  void initState() {
    super.initState();

    nama = TextEditingController(text: widget.nama);
    email = TextEditingController(text: widget.email);
    umur = TextEditingController(text: widget.umur);
    gender = TextEditingController(text: widget.gender);

    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      final res = await http.get(
        Uri.parse("$baseUrl/api/user/${widget.email}"),
      );

      final data = jsonDecode(res.body);

      if (data["success"] == true) {
        final user = data["user"];

        setState(() {
          nama.text = user["nama"] ?? widget.nama;
          email.text = user["email"] ?? widget.email;
          umur.text = user["umur"]?.toString() ?? widget.umur;
          gender.text = user["gender"] ?? widget.gender;

          berat.text = user["berat_badan"]?.toString() ?? "";
          tinggi.text = user["tinggi_badan"]?.toString() ?? "";

          // LOGIKA UTAMA: Jika berat/tinggi kosong di DB, otomatis langsung buka mode edit
          if (berat.text.trim().isEmpty || tinggi.text.trim().isEmpty) {
            isEdit = true;

            // Memunculkan snackbar pengingat setelah halaman selesai render
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Silakan lengkapi data berat dan tinggi badan Anda."),
                  backgroundColor: Colors.orange,
                ),
              );
            });
          }
        });
      }
    } catch (e) {
      debugPrint("Error load profile: $e");
    }
  }

  Future<void> saveProfile() async {
    // Validasi agar user tidak mengosongkan data penting ini
    if (berat.text.trim().isEmpty || tinggi.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Berat dan tinggi badan wajib diisi!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final res = await http.post(
        Uri.parse("$baseUrl/api/update-profile"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nama": nama.text.trim(),
          "email": email.text.trim(),
          "umur": umur.text.trim(),
          "gender": gender.text.trim(),
          "berat_badan": berat.text.trim(),
          "tinggi_badan": tinggi.text.trim(),
        }),
      );

      final data = jsonDecode(res.body);

      setState(() => isLoading = false);

      if (data["success"] == true) {
        setState(() => isEdit = false);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profile berhasil diupdate"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Gagal update")),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error koneksi: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
            icon: Icon(isEdit ? Icons.save : Icons.edit),
            onPressed: () {
              if (isEdit) {
                saveProfile();
              } else {
                setState(() => isEdit = true);
              }
            },
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  ProfileField(label: "Nama", controller: nama, editable: isEdit),
                  ProfileField(label: "Email", controller: email, editable: false), // Dikunci karena email biasanya primary key / unik
                  ProfileField(label: "Umur", controller: umur, editable: isEdit, keyboardType: TextInputType.number),
                  ProfileField(label: "Gender", controller: gender, editable: isEdit),

                  const SizedBox(height: 20),
                  const Divider(thickness: 1),
                  const SizedBox(height: 10),

                  ProfileField(
                    label: "Berat Badan (kg)", 
                    controller: berat, 
                    editable: isEdit,
                    keyboardType: TextInputType.number,
                  ),
                  ProfileField(
                    label: "Tinggi Badan (cm)", 
                    controller: tinggi, 
                    editable: isEdit,
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
    );
  }
}