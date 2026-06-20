import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../color.dart';

class FoodPage extends StatefulWidget {
  final List<Map<String, dynamic>> riwayat;
  final Function(Map<String, dynamic>) onTambah;
  final Function(int) onDelete;

  const FoodPage({
    super.key,
    required this.riwayat,
    required this.onTambah,
    required this.onDelete,
  });

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  List<dynamic> drinks = [];
  List<dynamic> snacks = [];
  bool isLoading = true; 
  String pesanError = "";

  final String baseUrl = kIsWeb ? "http://127.0.0.1:8000" : "http://10.0.2.2:8000";

  @override
  void initState() {
    super.initState();
    fetchData(); 
  }

  Future<void> fetchData() async {
    final String url = "$baseUrl/api/food-items"; 

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        setState(() {
          drinks = responseData["data"]["drinks"] ?? [];
          snacks = responseData["data"]["snacks"] ?? [];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          pesanError = "Server Laravel nolak, status code: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        pesanError = "Mampet di Flutter! Detail Error:\n$e";
      });
    }
  }

  double get totalSelectedSugar => widget.riwayat.fold(0.0, (sum, item) => sum + (item["gula"] as num).toDouble());
  double get totalDrinkSugar => totalSelectedSugar;
  double get totalSnackSugar => totalSelectedSugar;

  Widget warningBox(double total) {
    if (total <= 15.0) return const SizedBox();
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.red[100]!),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_rounded, color: Colors.red[700], size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Peringatan: Total konsumsi gula terlalu tinggi gess!",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.red[800]),
            ),
          ),
        ],
      ),
    );
  }

  void tambahMenu(Map<String, dynamic> item) {
    widget.onTambah(item);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${item['nama']} masuk ke riwayat gess!"),
        backgroundColor: AppColor.primary, // Balik ke warna utama gess
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void showDetail(Map item) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(item["nama"], style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow(Icons.scale, Colors.grey, "Takaran Saji: ${item["takaran"]}"),
              const Divider(height: 20),
              _buildDetailRow(Icons.local_fire_department, Colors.orange, "Kalori: ${item["kalori"]} kcal"),
              _buildDetailRow(Icons.fitness_center, Colors.red, "Protein: ${item["protein"]} g"),
              _buildDetailRow(Icons.water_drop, Colors.blue, "Lemak: ${item["lemak"]} g"),
              _buildDetailRow(Icons.grain, Colors.green, "Karbohidrat: ${item["karbo"]} g"),
              _buildDetailRow(Icons.cookie, Colors.amber, "Gula: ${item["gula"]} g", isBold: true),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Tutup", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primary, 
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                tambahMenu(Map<String, dynamic>.from(item)); 
                Navigator.pop(context); 
              },
              child: const Text("Pilih Menu Ini", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, Color color, String text, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(fontSize: 15, fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
          ),
        ],
      ),
    );
  }

  Widget buildCard(Map item, Color indicatorColor) {
    return Container(
      width: 155, 
      margin: const EdgeInsets.only(right: 14, bottom: 6, top: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [BoxShadow(color: Color.fromARGB(10, 0, 0, 0), blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: item["gambar"] != null && item["gambar"] != ""
                ? Image.network(item["gambar"], height: 95, width: double.infinity, fit: BoxFit.cover)
                : Container(
                    height: 95,
                    width: double.infinity,
                    color: Colors.grey[100],
                    child: Icon(Icons.fastfood_rounded, size: 36, color: Colors.grey[400]),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
            child: Text(
              item["nama"], 
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 2),
            child: Text("${item["kalori"]} kcal", style: TextStyle(fontSize: 11, color: Colors.grey[600])),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 2, 12, 6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: indicatorColor.withAlpha(38), 
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "${item["gula"]} g Gula", 
                style: TextStyle(fontSize: 11, color: indicatorColor, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: SizedBox(
              width: double.infinity,
              height: 32,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  side: BorderSide(color: Colors.grey[300]!),
                  padding: EdgeInsets.zero,
                ),
                onPressed: () => showDetail(item),
                child: Text("Detail", style: TextStyle(fontSize: 12, color: Colors.grey[700], fontWeight: FontWeight.w600)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSugarDashboard(double totalAmount) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Color.fromARGB(8, 0, 0, 0), blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Akumulasi Gula",
                style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              Text(
                "${totalAmount.toStringAsFixed(1)} gram",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: totalAmount > 15.0 ? Colors.red[50] : Colors.green[50],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              totalAmount > 15.0 ? "Overlimit" : "Aman",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: totalAmount > 15.0 ? Colors.red[700] : Colors.green[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: Column(
          children: [
            // KONTROL TAB BAR YANG BERDIRI SENDIRI DENGAN JARAK AMAN
            Container(
              margin: const EdgeInsets.fromLTRB(16, 20, 16, 8), 
              decoration: BoxDecoration(
                color: AppColor.primary, // Balik ke warna utama awal gess biar serasi!
                borderRadius: BorderRadius.circular(12),
              ),
              child: const TabBar(
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Color.fromARGB(179, 255, 255, 255),
                indicatorWeight: 3,
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                tabs: [
                  Tab(height: 42, text: "Minuman"), 
                  Tab(height: 42, text: "Snack")
                ],
              ),
            ),
            
            // AREA ISI CONTENT UTAMA
            Expanded(
              child: isLoading 
                ? const Center(child: CircularProgressIndicator()) 
                : pesanError.isNotEmpty
                    ? Center(child: Text(pesanError, style: const TextStyle(color: Colors.red)))
                    : TabBarView(
                        children: [
                          _buildTabContent(totalDrinkSugar, drinks, Colors.blue[700]!),
                          _buildTabContent(totalSnackSugar, snacks, Colors.orange[700]!),
                        ],
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(double totalSugar, List<dynamic> items, Color color) {
    if (items.isEmpty) {
      return const Center(child: Text("Belum ada data dari database gess."));
    }
    
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              warningBox(totalSugar),
              _buildSugarDashboard(totalSugar),
              
              isMobile 
                ? GridView.builder(
                    shrinkWrap: true, 
                    physics: const NeverScrollableScrollPhysics(), 
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, 
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      mainAxisExtent: 250, 
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return buildCard(items[index], color);
                    },
                  )
                : SizedBox(
                    height: 270, 
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return buildCard(items[index], color);
                      },
                    ),
                  ),
            ],
          ),
        );
      },
    );
  }
}