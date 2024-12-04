import 'package:flutter/material.dart';
import 'package:kantin_its/core/configs/theme/app_color.dart';
import 'package:kantin_its/pages/landing_page.dart';
import 'package:kantin_its/core/configs/theme/app_theme.dart';
import 'package:kantin_its/pages/map_page.dart';
import '../database_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      onGenerateRoute: (settings) {
        if (settings.name == '/tenant_detail') {
          // Receive arguments as a Map
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => TenantDetail(
              tenantId: args['tenantId'], // Pass tenantId
              tenantName: args['tenantName'], // Pass tenantName
            ),
          );
        }
        if (settings.name == '/map_page') {
          return MaterialPageRoute(builder: (context) => const MapPages());
        }
        //return MaterialPageRoute(builder: (context) => const LandingPage());
      },
    );
  }
}

class TenantDetail extends StatelessWidget {
  final int tenantId; // Tenant ID passed as an argument
  final String tenantName; // Tenant Name passed as an argument

  const TenantDetail({Key? key, required this.tenantId, required this.tenantName}) : super(key: key);

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Tenant $tenantName', // Adjust dynamically if needed
          style: const TextStyle(
            color: Colors.brown, // Match the body text color
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        // Using Stack to overlay widgets
        children: [
          // Body content
          Container(
            decoration:
                AppTheme.getGradientBackground(), // Apply gradient background
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchMenusByTenant(tenantId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('Tidak ada menu untuk tenant ini.'));
                } else {
                  var menuList = snapshot.data!;
                  return ListView.builder(
                    itemCount: menuList.length,
                    itemBuilder: (context, index) {
                      return FoodCard(menu: menuList[index]);
                    },
                  );
                }
              },
            ),
          ),

          // Positioned container for the button
          Positioned(
            bottom: 0, // Position at the bottom
            left: 0, // Align to the left
            right: 0, // Align to the right
            child: Container(
              padding: EdgeInsets.all(16), // Add padding around the button
              decoration: BoxDecoration(
                color: Colors.white, // Background color of the container
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, -4), // Shadow on top of the container
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  // Action when the button is pressed
                  // print("Tampilkan peta button pressed");
                  // Add the code to navigate to map or perform any other action

                  print('Navigasi ke halaman MapPage dipanggil');
                  Navigator.pushNamed(context, '/map_page');
                },
                child: const Text(
                  'Tampilkan Peta',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: AppColors.buttonColor, // Button color
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Future<List<Map<String, dynamic>>> fetchMenusByTenant(int tenantId) async {
    return await DatabaseHelper.instance.fetchMenusByTenant(tenantId);
  }
}

class FoodCard extends StatelessWidget {
  final Map<String, dynamic> menu;

  const FoodCard({Key? key, required this.menu}) : super(key: key);

@override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
       child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          elevation: 4,
          // color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0), // Pastikan Card transparan agar gradient terlihat
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    'https://img.freepik.com/premium-vector/nasi-goreng-illustration-indonesian-food-with-cartoon-style_44695-648.jpg',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.broken_image,
                          size: 80, color: Colors.grey);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        menu['menu_name'] ?? 'No Name',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Price: Rp${menu['menu_price'] ?? 'Unknown'}',
                        style: TextStyle(color: Colors.brown[300]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}
