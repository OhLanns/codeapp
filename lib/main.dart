import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/provider/auth_provider.dart';
import 'firebase_options.dart';

import 'pages/login.dart';
import 'pages/home_page.dart';
import 'battom/setting.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return MaterialApp(
          title: 'Code App',
          debugShowCheckedModeBanner: false,
          
          // ✅ Sinkronisasi Tema Global
          themeMode: authProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.blue,
            scaffoldBackgroundColor: Colors.white, 
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF121212), 
            useMaterial3: true,
          ),

          initialRoute: '/',
          routes: {
            '/': (context) => const SplashScreen(),
            '/login': (context) => const LoginPage(),
            '/home': (context) => const HomePage(),
            '/setting': (context) => const SettingPage(),
          },
        );
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  Future<void> checkLogin() async {
    // ✅ PERBAIKAN UTAMA: Beri jeda sedikit lebih lama (1 detik) khusus saat aplikasi dingin (cold start)
    // Ini memberikan waktu yang cukup bagi SharedPreferences di AuthProvider untuk selesai dimuat.
    await Future.delayed(const Duration(seconds: 1));

    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    // Jeda tambahan agar splash screen tidak berkedip terlalu cepat (Total splash 2.5 detik)
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Membaca tema langsung dari AuthProvider agar background SplashScreen ikut gelap sejak awal dibuka
    final authProvider = Provider.of<AuthProvider>(context);
    final isDark = authProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(isDark ? Colors.white : Colors.blue),
            ),
            const SizedBox(height: 20),
            Text(
              "Memuat aplikasi...",
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}