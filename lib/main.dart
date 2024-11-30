import 'package:flutter/material.dart';
import 'package:kantin_its/pages/menuList_page.dart';
import 'pages/landing_page.dart';


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
          final args = settings.arguments as Map<String, dynamic>?;
          if (args == null || args['tenantId'] == null || args['tenantName'] == null) {
            return MaterialPageRoute(
              builder: (context) => const ErrorScreen(message: 'Invalid or missing tenant ID or name.'),
            );
          }
          return MaterialPageRoute(
            builder: (context) => TenantDetail(
              tenantId: args['tenantId'],
              tenantName: args['tenantName'],
            ),
          );
        }
        return MaterialPageRoute(builder: (context) => const LandingPage());
      },
    );
  }
}

class ErrorScreen extends StatelessWidget {
  final String message;

  const ErrorScreen({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(child: Text(message)),
    );
  }
}
