import 'package:flutter/material.dart';
import '../color.dart';

class RecipePage extends StatelessWidget {
  final resep = [
    "Sup sayur sehat",
    "Ayam rebus diet",
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(10),
      children: resep.map((e) {
        return Card(
          color: AppColor.primaryLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.symmetric(vertical: 6),

          child: ListTile(
            title: Text(
              e,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            leading: Icon(
              Icons.menu_book,
              color: AppColor.primary,
            ),
          ),
        );
      }).toList(),
    );
  }
}