import 'package:flutter/material.dart';


class RiwayatPage extends StatelessWidget {
  final List<String> riwayat;
  final Function(int) onDelete;

  const RiwayatPage({
    super.key,
    required this.riwayat,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Padding(
          padding: EdgeInsets.all(12),
          child: Text(
            "Riwayat",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),

        if (riwayat.isEmpty)
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text("Belum ada riwayat"),
          ),

        ...riwayat.asMap().entries.map((entry) {
          int index = entry.key;
          String item = entry.value;

          return Card(
            child: ListTile(
              leading: const Icon(Icons.history),
              title: Text(item),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => onDelete(index),
              ),
            ),
          );
        }),
      ],
    );
  }
}