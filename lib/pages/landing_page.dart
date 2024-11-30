import 'package:flutter/material.dart';
import '../database_helper.dart';
import 'package:kantin_its/core/configs/theme/app_theme.dart';
import 'package:kantin_its/core/configs/theme/app_color.dart';
import 'package:kantin_its/pages/menuList_page.dart';

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
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => TenantDetail(
              tenantId: args['tenantId'], // Extract tenantId
              tenantName: args['tenantName'], // Extract tenantName
            ),
          );
        }
        return MaterialPageRoute(builder: (context) => const LandingPage());
      },
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  Future<List<Map<String, dynamic>>> fetchCanteenData() async {
    final canteensWithTenants =
        await DatabaseHelper.instance.fetchCanteensWithTenants();

    final Map<String, List<Map<String, dynamic>>> canteensMap = {};
    for (var row in canteensWithTenants) {
      final canteenName = row['canteen_name'];
      final tenantId = row['tenant_id'];
      final tenantName = row['tenant_name'];

      if (!canteensMap.containsKey(canteenName)) {
        canteensMap[canteenName] = [];
      }

      canteensMap[canteenName]!.add({'tenantId': tenantId, 'tenantName': tenantName});
    }

    return canteensMap.entries
        .map((entry) => {
              'canteen_name': entry.key,
              'tenants': entry.value,
            })
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.getGradientBackground(),
        child: ListView(
          children: [
            const Logo(),
            const KantinText(),
            const SearchBar(),
            // const SizedBox(height: 20),
            const ScrollableButtonSection(),
            const SizedBox(height: 10),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchCanteenData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Tidak ada data'));
                } else {
                  var canteenList = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: canteenList.length,
                    itemBuilder: (context, index) {
                      var canteen = canteenList[index];
                      return CanteenCard(
                        title: canteen['canteen_name'],
                        tenants: canteen['tenants'],
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      
      ),
    );
  }
}

class CanteenCard extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> tenants;

  const CanteenCard({
    Key? key,
    required this.title,
    required this.tenants,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
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
              title,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textThirdColor,
              ),
            ),
            const Divider(
              color: AppColors.textThirdColor,
              thickness: 3,
            ),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: tenants.map((tenant) {
                return ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/tenant_detail',
                      arguments: {
                        'tenantId': tenant['tenantId'], // Correct tenantId
                        'tenantName': tenant['tenantName'], // Correct tenantName
                      },
                    );
                  },
              style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    backgroundColor: AppColors.buttonLabelBackgroundColorCreme
                        .withOpacity(1.0), // Terapkan transparansi 39%
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: AppColors.accentSearchColor),
                    ),
                  ),
                  child: Text(
                    tenant['tenantName'] ?? 'Unknown Tenant',
                    style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.buttonLabelColorText                      
                      ),
                  ),
                );
              }).toList(),
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
    return Center(
      child: Image.asset(
        'assets/images/logo.png',
        width: 178,
        height: 173,
      ),
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
    return GestureDetector(
      onTap: () {
        // Navigate to the SearchPage when the search bar is tapped
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SearchPage()),
        );
      },
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: TextField(
          enabled: false, // Disable input here since it's just a navigation trigger
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
            color: Colors.white, // Change input text color to white
          ),
        ),
      ),
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final results = await DatabaseHelper.instance.search(query);

    setState(() {
      _searchResults = results;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F4E9), // Set the background color to match the desired look
        elevation: 0, // Remove shadow for a flat look
        centerTitle: true,
        title: const Text(
          'Pencarian',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.brown, // Match the text color in the provided image
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.brown),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: AppTheme.getGradientBackground(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                onChanged: _performSearch,
                decoration: InputDecoration(
                  hintText: 'Search by name, canteen, or menu',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9.43),
                    borderSide: const BorderSide(color: Colors.white, width: 1.0),
                  ),
                  filled: true,
                  fillColor: AppColors.accentSearchColor,
                  hintStyle: const TextStyle(color: Colors.white),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_searchResults.isEmpty && _searchController.text.isNotEmpty)
              const Center(child: Text('No results found'))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final result = _searchResults[index];
                    return FoodCard(data: result); // Ensure parameter matches FoodCard
                  },
                ),
              ),
          ],
        ),
      
      ),
    );
  }
}

class FoodCard extends StatelessWidget {
  final Map<String, dynamic> data; // Ensure the parameter is named "data"

  const FoodCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: GestureDetector(
        onTap: () {
          // Check if the type is 'tenant' or 'menu' before navigation
          if (data['type'] == 'tenant' || data['type'] == 'menu') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TenantDetail(
                  tenantId: data['tenant_id'], // Pass tenantId
                  tenantName: data['tenant_name'], // Pass tenantName
                ),
              ),
            );
          }
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
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
                      return const Icon(Icons.broken_image, size: 80, color: Colors.grey);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['menu_name'] ?? data['tenant_name'] ?? 'No Name',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (data['canteen_name'] != null)
                        Text('Canteen: ${data['canteen_name']}'),
                      if (data['menu_price'] != null)
                        Text('Price: Rp${data['menu_price']}'),
                      if (data['tenant_description'] != null &&
                          data['tenant_description']!.toLowerCase().trim() != 'null' &&
                          data['tenant_description']!.trim().isNotEmpty)
                        Text('Description: ${data['tenant_description']}'),
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
            Container(
              margin:
                  const EdgeInsets.only(left: 10.0), // Menambahkan margin kiri
              child: CustomButton(
                text: 'Terdekat',
                isActive: _activeIndex == 0,
                onPressed: () => _setActiveButton(0),
              ),
            ),
            const SizedBox(width: 10),
            CustomButton(
              text: 'Termurah',
              isActive: _activeIndex == 1,
              onPressed: () => _setActiveButton(1),
            ),
            const SizedBox(width: 10),
            CustomButton(
              text: 'Terpopuler',
              isActive: _activeIndex == 2,
              onPressed: () => _setActiveButton(2),
            ),
            const SizedBox(width: 10),
            CustomButton(
              text: 'Disukai',
              isActive: _activeIndex == 3,
              onPressed: () => _setActiveButton(3),
            ),
            const SizedBox(width: 10),
            CustomButton(
              text: 'Paling Banyak Dibeli',
              isActive: _activeIndex == 4,
              onPressed: () => _setActiveButton(4),
            ),
            const SizedBox(width: 10),
            CustomButton(
              text: 'Diskon Terbaik',
              isActive: _activeIndex == 5,
              onPressed: () => _setActiveButton(5),
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
          side: const BorderSide(color: AppColors.buttonColor),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        elevation: isActive ? 5 : 0,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 16, // Mengatur ukuran font
          fontWeight: FontWeight.bold, // Mengatur ketebalan font
          color: isActive
              ? Colors.white
              : AppColors
                  .accentSearchColor, // Mengatur warna font sesuai dengan status aktif
        ),
        ),

    );
  }
}
