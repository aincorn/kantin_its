import 'package:flutter/material.dart';
import 'database_helper.dart';

class MenuPage extends StatefulWidget {
  final int tenantId; // The ID of the selected tenant
  final String tenantName;

  const MenuPage({Key? key, required this.tenantId, required this.tenantName}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<Map<String, dynamic>> _menuList = [];

  @override
  void initState() {
    super.initState();
    _fetchMenus();
  }

  Future<void> _fetchMenus() async {
    try {
      // Fetch all menus for the given tenant ID
      final menus = await DatabaseHelper.instance.fetchMenusByTenant(widget.tenantId);
      setState(() {
        _menuList = menus;
      });
    } catch (e) {
      print('Error fetching menus: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menus for ${widget.tenantName}'),
      ),
      body: _menuList.isEmpty
          ? const Center(
        child: Text(
          'No menus available for this tenant.',
          style: TextStyle(fontSize: 16),
        ),
      )
          : ListView.builder(
        itemCount: _menuList.length,
        itemBuilder: (context, index) {
          final menu = _menuList[index];
          return ListTile(
            title: Text(menu['menu_name']),
            subtitle: Text('Price: ${menu['menu_price']}'),
          );
        },
      ),
    );
  }

}
