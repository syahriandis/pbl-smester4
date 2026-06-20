import 'package:flutter/material.dart';

class RiwayatPage extends StatelessWidget {
  // Menggunakan List Map gess, biar datanya lengkap bawa muatan gula & kalori dari DB
  final List<Map<String, dynamic>> riwayat;
  final Function(int) onDelete;

  const RiwayatPage({
    super.key,
    required this.riwayat,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Text(
              "Riwayat Konsumsi Hari Ini",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),

          if (riwayat.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history_toggle_off_rounded, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      "Belum ada riwayat gess.\nSilakan pilih menu sehatmu dulu!",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),

          ...riwayat.asMap().entries.map((entry) {
            int index = entry.key;
            var item = entry.value;

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                leading: const CircleAvatar(
                  backgroundColor: Colors.amber,
                  child: Icon(Icons.restaurant_rounded, color: Colors.white, size: 20),
                ),
                title: Text(
                  item["nama"] ?? "-", 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    "${item["takaran"] ?? "-"}  •  ${item["gula"] ?? 0} g Gula  •  ${item["kalori"] ?? 0} kcal",
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, color: Colors.red, size: 24),
                  onPressed: () => onDelete(index), // Eksekusi hapus baris gess
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}