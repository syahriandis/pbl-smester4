import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    nama = TextEditingController(text: widget.nama);
    email = TextEditingController(text: widget.email);
    umur = TextEditingController(text: widget.umur);
    gender = TextEditingController(text: widget.gender);
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
              setState(() {
                isEdit = !isEdit;
              });
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            buildField("Nama", nama),
            buildField("Email", email),
            buildField("Umur", umur),
            buildField("Gender", gender),

            const SizedBox(height: 20),

            buildField("Berat Badan", berat),
            buildField("Tinggi Badan", tinggi),
          ],
        ),
      ),
    );
  }

  Widget buildField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        enabled: isEdit,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}