import 'package:flutter/material.dart';
import 'database_helper.dart'; // Import your DatabaseHelper class
import 'tester_menuPage.dart';

void main() async {
  // Initialize Flutter bindings and database
  WidgetsFlutterBinding.ensureInitialized();

  // Ensure the database is initialized
  await DatabaseHelper.instance.database;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SearchScreen(),
    );
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];

  // Function to perform the search
  void _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    final results = await DatabaseHelper.instance.search(query);
    setState(() {
      _searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _performSearch,
              decoration: InputDecoration(
                hintText: 'Search by canteen, tenant, or menu name',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final result = _searchResults[index];
                return ListTile(
                  title: Text(result['tenant_name'] ?? 'No Tenant Found'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (result['menu_name'] != null)
                        Text('Menu: ${result['menu_name']}'),
                      if (result['canteen_name'] != null)
                        Text('Canteen: ${result['canteen_name']}'),
                      if (result['tenant_description'] != null &&
                          result['tenant_description']!.toLowerCase().trim() != 'null' &&
                          result['tenant_description']!.trim().isNotEmpty)
                        Text('Description: ${result['tenant_description']}'),
                    ],
                  ),
                  leading: Icon(
                    result['type'] == 'canteen'
                        ? Icons.store
                        : result['type'] == 'tenant'
                        ? Icons.person
                        : Icons.fastfood,
                  ),
                  onTap: () {
                    if (result['type'] == 'tenant') {
                      // Navigate to MenuPage with the tenant ID and name
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MenuPage(
                            tenantId: result['tenant_id'],
                            tenantName: result['tenant_name'],
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
