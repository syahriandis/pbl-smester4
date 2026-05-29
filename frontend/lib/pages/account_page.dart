import 'package:flutter/material.dart';
import '../color.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool isEditing = false;

  final namaC = TextEditingController(text: "User");
  final umurC = TextEditingController(text: "21");
  final tinggiC = TextEditingController(text: "170");
  final beratC = TextEditingController(text: "65");
  final favoritC =
      TextEditingController(text: "Nasi Goreng, Jus Alpukat");
  final alergiC = TextEditingController(text: "Udang");
  final gulaC = TextEditingController(text: "120g");
  final kelaminC = TextEditingController(text: "Laki-laki");

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),

          CircleAvatar(
            radius: 50,
            backgroundColor: AppColor.primary,
            child: const Icon(Icons.person, size: 50, color: Colors.white),
          ),

          const SizedBox(height: 10),

          // NAMA
          isEditing
              ? buildField(namaC)
              : Text(
                  namaC.text,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),

          const SizedBox(height: 20),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColor.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                buildItem("Umur", umurC),
                buildItem("Tinggi Badan", tinggiC),
                buildItem("Berat Badan", beratC),
                buildItem("Favorit", favoritC),
                buildItem("Alergi", alergiC),
                buildItem("Gula Darah", gulaC),
                buildItem("Jenis Kelamin", kelaminC),
              ],
            ),
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              setState(() {
                isEditing = !isEditing;
              });
            },
            child: Text(isEditing ? "Simpan" : "Edit"),
          ),
        ],
      ),
    );
  }

  Widget buildItem(String title, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          isEditing
              ? SizedBox(
                  width: 150,
                  child: TextField(
                    controller: controller,
                    textAlign: TextAlign.end,
                  ),
                )
              : Flexible(
                  child: Text(
                    controller.text,
                    textAlign: TextAlign.end,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
        ],
      ),
    );
  }

  Widget buildField(TextEditingController controller) {
    return SizedBox(
      width: 200,
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        style:
            const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}