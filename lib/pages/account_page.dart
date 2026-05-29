import 'package:flutter/material.dart';
import '../color.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String nama = "User";
    int umur = 21;
    double tinggi = 170;
    double berat = 65;
    String favorit = "Nasi Goreng, Jus Alpukat";

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),

          // FOTO / ICON PROFIL
          CircleAvatar(
            radius: 50,
            backgroundColor: AppColor.primary,
            child: const Icon(
              Icons.person,
              size: 50,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 10),

          // NAMA
          Text(
            nama,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          // CARD DATA USER
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColor.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                buildItem("Umur", "$umur tahun"),
                buildItem("Tinggi Badan", "$tinggi cm"),
                buildItem("Berat Badan", "$berat kg"),
                buildItem("Makanan/Minuman Favorit", favorit),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}