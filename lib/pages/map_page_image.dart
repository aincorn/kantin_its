import 'package:flutter/material.dart';

class MapPage extends StatelessWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.grey[200], // Warna background halaman
      body: Column(
        children: [
          // Header
          Container(
            height: 119, // Tinggi header
            width: double.infinity, // Lebar penuh
            color: Colors.brown[100], // Warna background header
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Tombol Back
                IconButton(
                  onPressed: () {
                    Navigator.pop(context); // Kembali ke halaman sebelumnya
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.brown,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 10),
                // Judul Header
                const Text(
                  'Map Kantin ITS',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
              ],
            ),
          ),

          // Scrollable Frame
          Expanded(
            child: Center(
              child: Container(
                width: 360, // Lebar frame
                height: 681, // Tinggi frame
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12), // Radius sudut frame
                  color: Colors.white, // Background frame
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1), // Bayangan
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                clipBehavior: Clip.hardEdge, // Clip untuk masking gambar
                child: InteractiveViewer(
                  // Widget scrollable dengan zoom
                  panEnabled: true, // Izinkan scroll vertikal dan horizontal
                  boundaryMargin: const EdgeInsets.all(0),
                  minScale: 1, // Skala minimum
                  maxScale: 4, // Skala maksimum
                  child: Image.asset(
                    'assets/images/map.png', // Path gambar
                    fit: BoxFit.cover, // Menyesuaikan gambar di frame
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
