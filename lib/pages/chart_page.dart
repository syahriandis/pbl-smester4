import 'package:flutter/material.dart';
import '../color.dart';

class ChartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Diagram Gula Darah\n(Gunakan fl_chart nanti)",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColor.primary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}