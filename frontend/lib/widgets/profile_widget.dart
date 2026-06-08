import 'package:flutter/material.dart';

class ProfileField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool editable;
  final TextInputType keyboardType;
  final bool isRowStyle; // True untuk gaya baris (di dalam box), False untuk gaya blok (seperti nama)

  const ProfileField({
    super.key,
    required this.label,
    required this.controller,
    this.editable = true,
    this.keyboardType = TextInputType.text,
    this.isRowStyle = true,
  });

  @override
  Widget build(BuildContext context) {
    // JIKA GAYA BLOK (Untuk Input Nama di bawah Avatar)
    if (!isRowStyle) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
        child: editable
            ? TextField(
                controller: controller,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  hintText: label,
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 2),
                  ),
                ),
              )
            : Text(
                controller.text,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
      );
    }

    // JIKA GAYA BARIS (Untuk Detail Profil di dalam Box)
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.w500, fontSize: 15),
            ),
          ),
          Expanded(
            flex: 3,
            child: editable
                ? SizedBox(
                    height: 40,
                    child: TextField(
                      controller: controller,
                      keyboardType: keyboardType,
                      textAlign: TextAlign.end,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green, width: 2),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  )
                : Text(
                    controller.text.isEmpty ? "-" : controller.text,
                    textAlign: TextAlign.end,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54, fontSize: 15),
                  ),
          ),
        ],
      ),
    );
  }
}