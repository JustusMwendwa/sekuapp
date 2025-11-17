import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/login_page.dart';
import 'screens/dashboard_page.dart';
import 'screens/send_money_page.dart';
import 'services/auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  PageRoute _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(begin: 0.0, end: 1.0);
        return FadeTransition(
          opacity: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthService>(
      create: (_) => AuthService(),
      child: MaterialApp(
        title: 'SEKU Send Money',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return _createRoute(const LoginPage());
            case '/dashboard':
              return _createRoute(const DashboardPage());
            case '/send':
              return _createRoute(const SendMoneyPage());
            default:
              return _createRoute(const LoginPage());
          }
        },
      ),
    );
  }
}
