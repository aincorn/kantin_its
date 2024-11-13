import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kantin_its/core/configs/theme/app_color.dart';
import 'package:kantin_its/core/configs/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kantin ITS',
      theme: AppTheme.getAppTheme(),
      home: const KantinPage(),
    );
  }
}

class Kantin {
  final String title;
  final String description;

  Kantin({required this.title, required this.description});

  factory Kantin.fromJson(Map<String, dynamic> json) {
    return Kantin(
      title: json['title'],
      description: json['description'],
    );
  }
}

class KantinPage extends StatefulWidget {
  const KantinPage({super.key});

  @override
  State<KantinPage> createState() => _KantinPageState();
}

class _KantinPageState extends State<KantinPage> {
  late Future<List<Kantin>> _kantinData;

  Future<List<Kantin>> fetchKantinData() async {
    final response =
        await http.get(Uri.parse('https://your-api-endpoint.com/kantin'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Kantin.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load kantin data');
    }
  }

  @override
  void initState() {
    super.initState();
    _kantinData = fetchKantinData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.getGradientBackground(),
        child: Column(
          children: [
            const Logo(),
            const KantinText(),
            const SearchBar(),
            const SizedBox(height: 20),
            const ScrollableButtonSection(),
            Expanded(
              child: FutureBuilder<List<Kantin>>(
                future: _kantinData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('No kantin data available'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return KantinCard(
                          title: snapshot.data![index].title,
                          description: snapshot.data![index].description,
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
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
    return const Text(
      'Kantin ITS',
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.accentColor,
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
        ),
      ),
    );
  }
}

class ScrollableButtonSection extends StatefulWidget {
  const ScrollableButtonSection({Key? key}) : super(key: key);

  @override
  State<ScrollableButtonSection> createState() =>
      _ScrollableButtonSectionState();
}

class KantinCard extends StatelessWidget {
  final String title;
  final String description;

  const KantinCard({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 328,
      height: 139,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: AppColors.accentDarkColor,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: 100,
                height: 2,
                color: AppColors.accentDarkColor,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Text(
                  description,
                  style: const TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
