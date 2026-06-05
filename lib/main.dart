import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/provider/auth_provider.dart';
import '/provider/announcement_provider.dart'; // ✅ IMPORT BARU: Mengubungkan provider pengumuman
import '/services/notification_service.dart'; // Jaluk service local notification terupdate
import 'firebase_options.dart';

import 'pages/login.dart';
import 'pages/home_page.dart';
import 'battom/setting.dart';
import 'battom/code.dart'; // Menyelaraskan lokasi file target CodePage Anda

Future<void> main() async {
  // Menjamin seluruh engine widget flutter siap sebelum asinkronus berjalan
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Inisialisasi Firebase Core
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ✅ Memperbaiki instansiasi objek agar tidak ganda/double teks
  final notificationService = NotificationService();
  await notificationService.init();
  
  // ✅ Meminta izin runtime lewat objek yang benar
  await notificationService.requestNotificationPermission();

  runApp(
    // ✅ PERBAIKAN UTAMA: Menggunakan MultiProvider agar kedua provider aktif bersamaan
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AnnouncementProvider()), // Menampung data pengumuman & status badge
      ],
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
          
          // ✅ Sinkronisasi Tema Global Terpusat dari AuthProvider
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
            '/code': (context) => const CodePage(), // Terhubung dengan CodePage Anda
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
    // Memberikan jeda 1 detik agar SharedPreferences di AuthProvider tuntas memuat tema
    await Future.delayed(const Duration(seconds: 1));

    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    // Sisa jeda penahanan splash screen (Total durasi 2.5 detik)
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    // Alur penentuan halaman masuk
    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Background langsung mengunci ke data tema asli sejak milidetik pertama dibuka
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