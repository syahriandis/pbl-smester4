import 'package:aplikasi_diabetes/pages/login_page.dart';
import 'package:flutter/material.dart';
import '../color.dart';

class ChartPage extends StatelessWidget {
  const ChartPage({Key? key}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Grafik Gula Darah"),
        backgroundColor: AppColor.primary,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Center(
        child: Text(
          "Diagram Gula Darah\n(Gunakan fl_chart nanti)",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColor.primary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}