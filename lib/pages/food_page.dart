import 'package:flutter/material.dart';
import '../color.dart';

class FoodPage extends StatefulWidget {
  const FoodPage({super.key});

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {

  /// DATA
  

  List<Map<String, dynamic>> drinks = [
    {
      "nama": "Air Putih",
      "gambar": "assets/air.jpg",
      "takaran": "250 ml",
      "gula": 0,
    },
    {
      "nama": "Teh Hijau",
      "gambar": "assets/teh.jpg",
      "takaran": "250 ml",
      "gula": 0,
    },
    {
      "nama": "Jus Alpukat",
      "gambar": "assets/alpukat.jpg",
      "takaran": "200 ml",
      "gula": 5,
    },
  ];

  List<Map<String, dynamic>> snacks = [
    {
      "nama": "Almond",
      "gambar": "assets/almond.jpg",
      "takaran": "30 g",
      "gula": 1,
    },
    {
      "nama": "Yogurt",
      "gambar": "assets/yogurt.jpg",
      "takaran": "100 g",
      "gula": 5,
    },
    {
      "nama": "Apel",
      "gambar": "assets/apel.jpg",
      "takaran": "150 g",
      "gula": 10,
    },
  ];

  /// TOTAL GULA
  int get totalDrinkSugar =>
      drinks.fold(0, (sum, item) => sum + (item["gula"] as int));

  int get totalSnackSugar =>
      snacks.fold(0, (sum, item) => sum + (item["gula"] as int));

  
  /// WARNING
  Widget warningBox(int total) {
    if (total <= 15) {
      return const SizedBox();
    }

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: Colors.red.shade100,
        borderRadius: BorderRadius.circular(12),
      ),

      child: Row(
        children: const [
          Icon(
            Icons.warning,
            color: Colors.red,
          ),

          SizedBox(width: 10),

          Expanded(
            child: Text(
              "Total gula terlalu tinggi!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }


  /// TAMBAH MENU
  void tambahMenu(bool isDrink) {
    TextEditingController nama = TextEditingController();
    TextEditingController takaran = TextEditingController();
    TextEditingController gula = TextEditingController();

    showDialog(
      context: context,

      builder: (_) {
        return AlertDialog(
          title: Text(
            isDrink
                ? "Tambah Minuman"
                : "Tambah Snack",
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,

            children: [

              TextField(
                controller: nama,
                decoration: const InputDecoration(
                  labelText: "Nama Menu",
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: takaran,
                decoration: const InputDecoration(
                  labelText: "Takaran",
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: gula,
                keyboardType: TextInputType.number,

                decoration: const InputDecoration(
                  labelText: "Jumlah Gula",
                ),
              ),
            ],
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text("Batal"),
            ),

            ElevatedButton(
              onPressed: () {
                final item = {
                  "nama": nama.text,
                  "gambar": "",
                  "takaran": takaran.text,
                  "gula": int.tryParse(gula.text) ?? 0,
                };

                setState(() {
                  if (isDrink) {
                    drinks.add(item);
                  } else {
                    snacks.add(item);
                  }
                });

                Navigator.pop(context);
              },

              child: const Text("Tambah"),
            ),
          ],
        );
      },
    );
  }

 
  /// DETAIL
  void showDetail(Map item) {
    showDialog(
      context: context,

      builder: (_) {
        return AlertDialog(
          title: Text(item["nama"]),

          content: Column(
            mainAxisSize: MainAxisSize.min,

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Text("Takaran: ${item["takaran"]}"),

              const SizedBox(height: 10),

              Text("Gula: ${item["gula"]} g"),
            ],
          ),

          actions: [

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Tutup"),
            ),
          ],
        );
      },
    );
  }

 
  /// CARD
  Widget buildCard(Map item, Color color) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),

      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,

        children: [

          /// IMAGE
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16),
            ),

            child: item["gambar"] != ""
                ? Image.asset(
                    item["gambar"],
                    height: 90,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 90,
                    width: double.infinity,
                    color: Colors.white30,

                    child: const Icon(
                      Icons.fastfood,
                      size: 40,
                    ),
                  ),
          ),

          const SizedBox(height: 10),

          /// TITLE
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
            ),

            child: Text(
              item["nama"],
              textAlign: TextAlign.center,

              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),

          const SizedBox(height: 5),

          /// GULA
          Text(
            "Gula: ${item["gula"]} g",
            style: const TextStyle(
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 12),

          /// BUTTON
          Padding(
            padding: const EdgeInsets.only(
              bottom: 12,
            ),

            child: OutlinedButton(
              onPressed: () => showDetail(item),
              child: const Text("Detail"),
            ),
          ),
        ],
      ),
    );
  }

  /// UI
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,

      child: Scaffold(
        backgroundColor: Colors.grey[100],

        /// BUTTON TAMBAH
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              backgroundColor: AppColor.primary,

              onPressed: () {
                final tabIndex =
                    DefaultTabController.of(context).index;

                tambahMenu(tabIndex == 0);
              },

              child: const Icon(Icons.add),
            );
          },
        ),

        /// BODY       
        body: Column(
          children: [
            /// TABBAR
            Container(
              color: AppColor.primary,

              child: const TabBar(
                indicatorColor: Colors.white,
                labelColor: Colors.white,

                tabs: [
                  Tab(text: "Minuman"),
                  Tab(text: "Snack"),
                ],
              ),
            ),

            Expanded(
              child: TabBarView(
                children: [
                 
                  /// MINUMAN                 
                  SingleChildScrollView(
                    child: Column(
                      children: [

                        warningBox(totalDrinkSugar),

                        Padding(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 12,
                          ),

                          child: Align(
                            alignment:
                                Alignment.centerLeft,

                            child: Text(
                              "Total Gula: $totalDrinkSugar g",

                              style: const TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        SizedBox(
                          height: 240,

                          child: Padding(
                            padding:
                                const EdgeInsets.all(12),

                            child: ListView(
                              scrollDirection:
                                  Axis.horizontal,

                              children: drinks
                                  .map(
                                    (item) => buildCard(
                                      item,
                                      Colors.blue.shade100,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                 
                  /// SNACK
                  SingleChildScrollView(
                    child: Column(
                      children: [

                        warningBox(totalSnackSugar),

                        Padding(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 12,
                          ),

                          child: Align(
                            alignment:
                                Alignment.centerLeft,

                            child: Text(
                              "Total Gula: $totalSnackSugar g",

                              style: const TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        SizedBox(
                          height: 240,

                          child: Padding(
                            padding:
                                const EdgeInsets.all(12),

                            child: ListView(
                              scrollDirection:
                                  Axis.horizontal,

                              children: snacks
                                  .map(
                                    (item) => buildCard(
                                      item,
                                      Colors.orange.shade100,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}