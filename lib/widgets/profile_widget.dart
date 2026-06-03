import 'package:flutter/material.dart';

class ProfileField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool editable;
  final TextInputType keyboardType; // Menambahkan tipe input (misal: angka untuk berat/tinggi)

  const ProfileField({
    super.key,
    required this.label,
    required this.controller,
    required this.editable,
    this.keyboardType = TextInputType.text, // Default berupa teks biasa
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        enabled: editable,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          // Memberikan warna abu-abu tipis saat field dikunci/tidak bisa diedit
          filled: !editable,
          fillColor: editable ? Colors.transparent : Colors.grey[200],
        ),
      ),
    );
  }
}