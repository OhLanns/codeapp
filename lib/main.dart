import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/login.dart';  // Import halaman login
import 'pages/home_page.dart';   // Import halaman home
import 'battom/setting.dart';   // Import halaman setting
// ✅ Main function untuk menjalankan aplikasi
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Saya',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',  // Route awal akan cek status login
      routes: {
        '/setting': (context) => const SettingPage(),
        '/': (context) => const SplashScreen(),  // Halaman pengecekan
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),

      },
    );
  }
}

// ✅ SPLASH SCREEN untuk cek status login
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // Fungsi cek status login dari Shared Preferences
  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    
    // Tunggu 2 detik (opsional)
    await Future.delayed(const Duration(seconds: 2));
    
    if (isLoggedIn) {
      // Jika sudah login, langsung ke HomePage
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Jika belum login, ke LoginPage
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text("Memuat aplikasi..."),
          ],
        ),
      ),
    );
  }
}