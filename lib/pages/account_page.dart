import 'package:flutter/material.dart';
import '../color.dart';

class AccountPage extends StatelessWidget {

  final String nama;
  final String umur;
  final String gender;

  const AccountPage({
    Key? key,
    required this.nama,
    required this.umur,
    required this.gender,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Column(
        children: [

          const SizedBox(height: 20),

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

          Text(
            nama,

            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Container(
            margin:
                const EdgeInsets.symmetric(horizontal: 16),

            padding: const EdgeInsets.all(16),

            decoration: BoxDecoration(
              color:
                  AppColor.primary.withOpacity(0.1),

              borderRadius:
                  BorderRadius.circular(12),
            ),

            child: Column(
              children: [

                buildItem(
                  "Nama",
                  nama,
                ),

                buildItem(
                  "Umur",
                  "$umur tahun",
                ),

                buildItem(
                  "Gender",
                  gender,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItem(
    String title,
    String value,
  ) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 8),

      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

        children: [

          Text(title),

          Flexible(
            child: Text(
              value,

              textAlign: TextAlign.end,

              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}