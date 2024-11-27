import 'package:flutter/material.dart';
import 'package:kantin_its/core/configs/theme/app_theme.dart';
import 'package:kantin_its/core/configs/theme/app_color.dart';
import 'package:kantin_its/pages/info_kantin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => KantinPage(),
        '/info_kantin': (context) => KantinBiologiScreen(),
      },
    );
  }
}

class KantinPage extends StatelessWidget {
  const KantinPage({super.key});

  // Fungsi untuk mengambil data kantin
  Future<List<String>> fetchKantinData() async {
    await Future.delayed(
        Duration(seconds: 2)); // Simulasi delay seperti API request
    return [
      "Kantin Biologi",
      "Kantin Teknik Informatika",
      "Kantin FST",
    ]; // Data statis yang akan digunakan
  }

  // Fungsi untuk menyegarkan data
  Future<void> _refreshKantinData(BuildContext context) async {
    await Future.delayed(
        Duration(seconds: 2)); // Simulasi pengambilan data ulang
    // Biasanya, kita akan memanggil fetchKantinData() di sini untuk memuat ulang data dari API
    // Mengupdate UI setelah refresh
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.getGradientBackground(),
        child: RefreshIndicator(
          onRefresh: () => _refreshKantinData(context), // Fungsi refresh
          child: ListView(
            children: [
              const Logo(),
              const KantinText(),
              const SearchBar(),
              const SizedBox(height: 20),
              const ScrollableButtonSection(),
              FutureBuilder<List<String>>(
                future: fetchKantinData(), // Memanggil fungsi fetchKantinData
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child:
                            CircularProgressIndicator()); // Tampilkan loading saat menunggu data
                  } else if (snapshot.hasError) {
                    return Text(
                        'Error: ${snapshot.error}'); // Menampilkan error jika ada
                  } else if (!snapshot.hasData) {
                    return const Text('Tidak ada data');
                  } else {
                    // Data sudah tersedia, kita akan menampilkan KantinCard untuk setiap kantin
                    var kantinList = snapshot.data!;
                    return Column(
                      children: kantinList.map((kantinName) {
                        return SizedBox(
                          width: double.infinity,
                          child: KantinCard(
                            title: kantinName,
                            onPressed: () {
                              // Menavigasi ke halaman info_kantin dengan nama kantin
                              Navigator.pushNamed(
                                context,
                                '/info_kantin',
                                arguments:
                                    kantinName, // Mengirimkan nama kantin
                              );
                            },
                          ),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class KantinCard extends StatefulWidget {
  final String title;
  final VoidCallback onPressed;

  const KantinCard({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  _KantinCardState createState() => _KantinCardState();
}

class _KantinCardState extends State<KantinCard> {
  bool _isPressed = false;

  List<String> buttonLabels = [
    "Makanan 1",
    "Makanan 2",
    "Makanan 3",
    "Makanan 4",
    "Makanan 5",
    "Makanan 1",
    "Makanan 2",
    "Makanan 3",
    "Makanan 4",
    "Makanan 5"
  ]; // Gantilah dengan data dari database nanti

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
        widget.onPressed();
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0, // Mengecilkan sedikit saat ditekan
        duration: const Duration(milliseconds: 100),
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textThirdColor,
                  ),
                ),
                const Divider(
                  color: AppColors.textThirdColor,
                  thickness: 3,
                ),
                DynamicButtonList(
                  buttonLabels: buttonLabels, // Data dinamis untuk tombol
                  onButtonPressed: (label) {
                    print("Tombol $label ditekan");
                    // Tindakan lebih lanjut bisa ditambahkan di sini, seperti navigasi atau operasi lainnya
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DynamicButtonList extends StatelessWidget {
  final List<String> buttonLabels; // Daftar label tombol
  final Function(String) onButtonPressed; // Callback saat tombol ditekan

  const DynamicButtonList({
    Key? key,
    required this.buttonLabels, // Data daftar tombol
    required this.onButtonPressed, // Aksi saat tombol ditekan
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap:
          true, // Menggunakan shrinkWrap agar GridView tidak mengganggu ukuran widget lainnya
      physics:
          NeverScrollableScrollPhysics(), // Agar grid tidak bisa digulir secara mandiri
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // Menentukan jumlah kolom
        crossAxisSpacing: 8, // Spasi antar kolom
        mainAxisSpacing: 8, // Spasi antar baris
        childAspectRatio: 2.5, // Rasio antara lebar dan tinggi item
      ),
      itemCount: buttonLabels.length, // Jumlah item tombol yang ditampilkan
      itemBuilder: (context, index) {
        return CustomButton(
          text: buttonLabels[index],
          isActive: false,
          onPressed: () => onButtonPressed(buttonLabels[index]),
        );
      },
    );
  }
}

class ScrollableButtonSection extends StatefulWidget {
  const ScrollableButtonSection({Key? key}) : super(key: key);

  @override
  State<ScrollableButtonSection> createState() =>
      _ScrollableButtonSectionState();
}

class _ScrollableButtonSectionState extends State<ScrollableButtonSection> {
  int _activeIndex = 0;

  void _setActiveButton(int index) {
    setState(() {
      _activeIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            CustomButton(
              text: 'Button 1',
              isActive: _activeIndex == 0,
              onPressed: () => _setActiveButton(0),
            ),
            const SizedBox(width: 10),
            CustomButton(
              text: 'Button 2',
              isActive: _activeIndex == 1,
              onPressed: () => _setActiveButton(1),
            ),
            const SizedBox(width: 10),
            CustomButton(
              text: 'Button 3',
              isActive: _activeIndex == 2,
              onPressed: () => _setActiveButton(2),
            ),
            const SizedBox(width: 10),
            CustomButton(
              text: 'Button 4',
              isActive: _activeIndex == 3,
              onPressed: () => _setActiveButton(3),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final bool isActive;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.text,
    required this.isActive,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: isActive ? Colors.white : AppColors.accentSearchColor,
        backgroundColor: isActive ? AppColors.accentSearchColor : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9),
          side: const BorderSide(color: AppColors.accentSearchColor),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        elevation: isActive ? 5 : 0,
      ),
      child: Text(text),
    );
  }
}

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.png',
      width: 178,
      height: 173,
    );
  }
}

class KantinText extends StatelessWidget {
  const KantinText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Kantin ITS',
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.accentColor,
        ),
      ),
    );
  }
}


class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(9.43)),
            borderSide: BorderSide(color: Colors.white, width: 1.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(9.43)),
            borderSide: BorderSide(color: Colors.white, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(9.43)),
            borderSide: BorderSide(color: Colors.white, width: 1.0),
          ),
          filled: true,
          fillColor: AppColors.accentSearchColor,
          hintText: 'Cari makanan atau minuman',
          hintStyle: TextStyle(color: Colors.white),
        ),
        style: TextStyle(
            color: Colors.white), // Mengubah warna font inputan menjadi putih
      ),
    );
  }
}
