import 'package:flutter/material.dart';
import '../core/configs/theme/app_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: KantinBiologiScreen(),
    );
  }
}

class KantinBiologiScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Mengambil nama kantin dari arguments
    final String kantinName =
        ModalRoute.of(context)?.settings.arguments as String;

    return Scaffold(
        appBar: AppBar(
          title: Text('$kantinName'),
          backgroundColor: Colors.brown, // Set background color for AppBar
          elevation: 4,
        ),
        body: RefreshIndicator(
          child: FutureBuilder(
            // Misalnya kita fetch data terkait kantin berdasarkan nama kantin
            future: fetchDataForKantin(
                kantinName), // Fungsi untuk mengambil data kantin
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return Center(child: Text('Tidak ada data untuk $kantinName'));
              } else {
                var data = snapshot.data;
                return Container(
                  decoration:
                      AppTheme.getGradientBackground(), // Set background
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          '$kantinName',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                        ),
                      ),
                      // Menampilkan daftar makanan yang didapatkan dari data
                      Expanded(
                          child: ListView.builder(
                            itemCount: data?['menu'].length,
                            itemBuilder: (context, index) {
                              return FoodCard(
                                food: data?['menu'][index],
                              );
                            },
                          ),       
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.brown,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () {},
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0),
                                  child: Text(
                                    "Lihat Peta",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
          onRefresh: () => fetchDataForKantin(kantinName),
        ));
  }

  // Fungsi untuk fetch data terkait kantin, bisa diganti dengan panggilan API
  Future<Map<String, dynamic>> fetchDataForKantin(String kantinName) async {
    await Future.delayed(Duration(seconds: 2)); // Simulasi delay
    // Simulasi data API
    return {
      'kantinName': kantinName,
      'menu': [
        {
          'name': 'Sego Njamoer',
          'priceRange': '10k - 20k',
          'image':
              'https://img.freepik.com/premium-vector/nasi-goreng-illustration-indonesian-food-with-cartoon-style_44695-648.jpg', // Ganti dengan URL gambar yang sesuai
          'tags': ['Halal', 'Pedas']
        },
        {
          'name': 'Mie Goreng',
          'priceRange': '15k - 25k',
          'image':
              'https://img.freepik.com/premium-vector/nasi-goreng-illustration-indonesian-food-with-cartoon-style_44695-648.jpg', // Ganti dengan URL gambar yang sesuai
          'tags': ['Halal', 'Sedang']
        },
        {
          'name': 'Ayam Penyet',
          'priceRange': '20k - 30k',
          'image':
              'https://img.freepik.com/premium-vector/nasi-goreng-illustration-indonesian-food-with-cartoon-style_44695-648.jpg', // Ganti dengan URL gambar yang sesuai
          'tags': ['Halal', 'Pedas']
        },
      ]
    };
  }

// Widget untuk menampilkan menu makanan dalam bentuk card
  Widget _buildFoodCard(Map<String, dynamic> food) {
    bool _isPressed = false;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: GestureDetector(
        onTapDown: (_) {
          _isPressed = true;
        },
        onTapUp: (_) {
          _isPressed = false;
          // Simulasikan aksi tap, seperti navigasi ke halaman lain
          print('Navigating to detailed page for ${food['name']}');
        },
        onTapCancel: () {
          _isPressed = false;
        },
        child: AnimatedScale(
          scale: _isPressed ? 0.95 : 1.0, // Pengecilan saat ditekan
          duration: const Duration(milliseconds: 200),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation:
                _isPressed ? 6 : 4, // Menambahkan efek elevasi saat ditekan
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      food['image'], // Gambar makanan
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          food['name'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Kisaran Harga: ${food['priceRange']}',
                          style: TextStyle(color: Colors.brown[300]),
                        ),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: List.generate(food['tags'].length, (index) {
                            return _buildLabel(food['tags'][index]);
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

// Widget untuk label kategori makanan
  Widget _buildLabel(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.brown[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: Colors.brown),
      ),
    );
  }
}

class FoodCard extends StatefulWidget {
  final Map<String, dynamic> food;

  const FoodCard({Key? key, required this.food}) : super(key: key);

  @override
  _FoodCardState createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    // Debugging dengan print data food
    print('Food data received: ${widget.food}');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: GestureDetector(
        onTapDown: (_) {
          setState(() {
            _isPressed = true;
          });
        },
        onTapUp: (_) {
          setState(() {
            _isPressed = false;
          });
          // Navigasi atau aksi lainnya
        },
        onTapCancel: () {
          setState(() {
            _isPressed = false;
          });
        },
        child: AnimatedScale(
          scale: _isPressed ? 0.95 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: _isPressed ? 6 : 4,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.food['image'], // Gambar makanan
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.food['name'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Kisaran Harga: ${widget.food['priceRange']}',
                          style: TextStyle(color: Colors.brown[300]),
                        ),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: List.generate(widget.food['tags'].length,
                              (index) {
                            return _buildLabel(widget.food['tags'][index]);
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.brown[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: Colors.brown),
      ),
    );
  }
}
