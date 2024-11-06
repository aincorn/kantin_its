import 'package:flutter/material.dart';
import 'core/configs/theme/app_theme.dart';
import 'presentations/splash/pages/splash.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Kantin ITS',
      debugShowCheckedModeBanner: false,
      home:  KantinPage(),
    );
  }
}