import 'package:flutter/material.dart';
import '../hive_service/hive_service.dart';
import '../pages/home_page.dart';
import '../login_pages/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    // Wait for session to refresh properly
    await HiveService.refreshSession();
    await Future.delayed(const Duration(milliseconds: 800)); // smooth UX

    final bool loggedIn = HiveService.currentUsername != null;

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => loggedIn ? const HomePage() : const LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: CircularProgressIndicator(color: Colors.purpleAccent),
      ),
    );
  }
}
