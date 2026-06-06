import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Import Provider & Services
import '/provider/auth_provider.dart';
import '/provider/announcement_provider.dart';
import '/services/notification_service.dart';
import 'firebase_options.dart';

// Import Pages
import 'pages/login.dart';
import 'pages/home_page.dart';
import 'battom/setting.dart';
import 'battom/code.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inisialisasi Notification Service
  final notificationService = NotificationService();
  await notificationService.init();
  await notificationService.requestNotificationPermission();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AnnouncementProvider()),
      ],
      child: const CodeApp(),
    ),
  );
}

class CodeApp extends StatelessWidget {
  const CodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return MaterialApp(
          title: 'Code App',
          debugShowCheckedModeBanner: false,
          themeMode: authProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          theme: _buildThemeData(Brightness.light, Colors.white, Colors.blue),
          darkTheme: _buildThemeData(Brightness.dark, const Color(0xFF121212), Colors.blueAccent),
          initialRoute: '/',
          routes: {
            '/': (context) => const SplashScreen(),
            '/login': (context) => const LoginPage(),
            '/home': (context) => const HomePage(),
            '/setting': (context) => const SettingPage(),
            '/code': (context) => const CodePage(),
          },
        );
      },
    );
  }

  ThemeData _buildThemeData(Brightness brightness, Color bgColor, Color primary) {
    return ThemeData(
      brightness: brightness,
      primaryColor: primary,
      scaffoldBackgroundColor: bgColor,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: primary, brightness: brightness),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => setState(() => _visible = true));
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    await Future.delayed(const Duration(seconds: 2));
    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (!mounted) return;

    Navigator.pushReplacementNamed(context, isLoggedIn ? '/home' : '/login');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AuthProvider>(context).isDarkMode;
    return Scaffold(
      body: AnimatedOpacity(
        opacity: _visible ? 1.0 : 0.0,
        duration: const Duration(seconds: 1),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.code_rounded, size: 80, color: isDark ? Colors.blueAccent : Colors.blue),
              const SizedBox(height: 30),
              CircularProgressIndicator(strokeWidth: 3),
              const SizedBox(height: 20),
              Text("CODE APP", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 2)),
            ],
          ),
        ),
      ),
    );
  }
}