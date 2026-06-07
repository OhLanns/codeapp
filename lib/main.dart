import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provider
import '/provider/auth_provider.dart';
import '/provider/announcement_provider.dart';
import '/provider/iklan_provider.dart';

// Services
import '/services/notification_service.dart';
import 'firebase_options.dart';

// Pages
import 'pages/login.dart';
import 'pages/home_page.dart';
import 'battom/setting.dart';
import 'battom/code.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Notification
  final notificationService = NotificationService();
  await notificationService.init();
  await notificationService.requestNotificationPermission();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => AnnouncementProvider(),
        ),

        // IklanProvider dengan auto load data
        ChangeNotifierProvider(
          create: (_) => IklanProvider()..loadIklan(),
        ),
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
          debugShowCheckedModeBanner: false,
          title: 'Code App',

          themeMode:
              authProvider.isDarkMode
                  ? ThemeMode.dark
                  : ThemeMode.light,

          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.blue,
            useMaterial3: true,
          ),

          darkTheme: ThemeData(
            brightness: Brightness.dark,
            useMaterial3: true,
          ),

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

    // Animasi fade in
    Future.microtask(() {
      if (mounted) {
        setState(() {
          _visible = true;
        });
      }
    });

    _checkLogin();
  }

  Future<void> _checkLogin() async {
    // Tunggu 2 detik untuk animasi splash screen
    await Future.delayed(const Duration(seconds: 2));

    final prefs = await SharedPreferences.getInstance();

    bool isLoggedIn =
        prefs.getBool('isLoggedIn') ?? false;

    if (!mounted) return;

    Navigator.pushReplacementNamed(
      context,
      isLoggedIn ? '/home' : '/login',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Provider.of<AuthProvider>(context).isDarkMode;

    return Scaffold(
      body: AnimatedOpacity(
        opacity: _visible ? 1 : 0,
        duration: const Duration(seconds: 1),
        child: Center(
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              // Icon dengan efek gradient (opsional)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      isDark ? Colors.blueAccent : Colors.blue,
                      isDark ? Colors.blue[700]! : Colors.lightBlue,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.code_rounded,
                  size: 80,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 30),

              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),

              const SizedBox(height: 20),

              const Text(
                "CODE APP",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Version 1.0.0",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}