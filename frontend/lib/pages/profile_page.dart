import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../widgets/profile_widget.dart';

class ProfilePage extends StatefulWidget {
  final int id; 
  final String nama;
  final String email;
  final String tanggalLahir; 
  final int umur; 
  final String gender;

  const ProfilePage({
    super.key,
    required this.id,
    required this.nama,
    required this.email,
    required this.tanggalLahir,
    required this.umur,
    required this.gender,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController nama, email, tanggalLahir, umur, gender;
  final berat = TextEditingController();
  final tinggi = TextEditingController();
  bool isEdit = false;
  bool isLoading = false;

  final String baseUrl = kIsWeb ? "http://localhost:8000" : "http://10.0.2.2:8000";

  @override
  void initState() {
    super.initState();
    nama = TextEditingController(text: widget.nama);
    email = TextEditingController(text: widget.email);
    tanggalLahir = TextEditingController(text: widget.tanggalLahir);
    umur = TextEditingController(text: widget.umur.toString());
    gender = TextEditingController(text: widget.gender);
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      final res = await http.get(Uri.parse("$baseUrl/api/user/${widget.id}"));
      if (res.body.isEmpty) return;
      final data = jsonDecode(res.body);

      if (data["success"] == true) {
        final user = data["user"];
        setState(() {
          nama.text = user["nama"] ?? widget.nama;
          email.text = user["email"] ?? widget.email;
          tanggalLahir.text = user["tanggal_lahir"] ?? widget.tanggalLahir;
          umur.text = user["umur"]?.toString() ?? widget.umur.toString();
          gender.text = user["gender"] ?? widget.gender;
          berat.text = user["berat_badan"]?.toString() ?? "";
          tinggi.text = user["tinggi_badan"]?.toString() ?? "";

          if (berat.text.trim().isEmpty || tinggi.text.trim().isEmpty) {
            isEdit = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Silakan lengkapi data berat dan tinggi badan Anda."), 
                  backgroundColor: Colors.orange
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

  // Fungsi pilih foto (Placeholder untuk implementasi ImagePicker nanti)
  void _pilihFoto() {
    if (!isEdit) return;
    
    // Tampilkan opsi bottom sheet ganti foto
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pilih dari Galeri'),
              onTap: () {
                Navigator.of(context).pop();
                // TODO: Panggil fungsi ImagePicker dari galeri di sini
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Ambil Foto dari Kamera'),
              onTap: () {
                Navigator.of(context).pop();
                // TODO: Panggil fungsi ImagePicker dari kamera di sini
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveProfile() async {
    if (nama.text.trim().isEmpty || berat.text.trim().isEmpty || tinggi.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama, berat, dan tinggi badan wajib diisi!"), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => isLoading = true);
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/api/profile/update/${widget.id}"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nama": nama.text.trim(), // SEKARANG NAMA IKUT DIKIRIM KE BACKEND
          "berat_badan": berat.text.trim(), 
          "tinggi_badan": tinggi.text.trim()
        }),
      );

      final data = jsonDecode(res.body);
      setState(() => isLoading = false);

      if (data["success"] == true) {
        setState(() {
          isEdit = false;
          if (data["user"] != null) {
            umur.text = data["user"]["umur"]?.toString() ?? umur.text;
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile berhasil diperbarui"), backgroundColor: Colors.green),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data["message"] ?? "Gagal update")));
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error koneksi: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // BAGIAN EDIT FOTO (Menggunakan Stack & GestureDetector)
                  GestureDetector(
                    onTap: _pilihFoto,
                    child: Stack(
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.green,
                          child: Icon(Icons.person, size: 50, color: Colors.white),
                        ),
                        if (isEdit)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.orange.shade700,
                              child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // BAGIAN EDIT NAMA (Menggunakan widget ProfileField kustom)
                  ProfileField(
                    label: "Nama", 
                    controller: nama, 
                    editable: isEdit, 
                    isRowStyle: false
                  ),
                  
                  Text(
                    email.text,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),

                  const SizedBox(height: 25),

                  // Box Detail Profil
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        ProfileField(label: "Tanggal Lahir", controller: tanggalLahir, editable: false),
                        ProfileField(label: "Umur (Otomatis)", controller: umur, editable: false),
                        ProfileField(label: "Jenis Kelamin", controller: gender, editable: false),
                        
                        const Divider(height: 24, thickness: 1, color: Colors.black12),
                        
                        ProfileField(
                          label: "Tinggi Badan (cm)", 
                          controller: tinggi, 
                          editable: isEdit, 
                          keyboardType: TextInputType.number
                        ),
                        ProfileField(
                          label: "Berat Badan (kg)", 
                          controller: berat, 
                          editable: isEdit, 
                          keyboardType: TextInputType.number
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Tombol Aksi
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isEdit ? Colors.orange : Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      if (isEdit) {
                        saveProfile();
                      } else {
                        setState(() => isEdit = true);
                      }
                    },
                    child: Text(
                      isEdit ? "Simpan Perubahan" : "Edit Profil",
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}