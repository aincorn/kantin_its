import 'package:flutter/material.dart';
import 'pages/kantin.dart';
import 'pages/info_kantin.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => KantinPage(), // Halaman utama
        '/info_kantin': (context) =>
            KantinBiologiScreen(), // Pastikan halaman KantinPage digunakan di sini
      },
    );
  }
}
