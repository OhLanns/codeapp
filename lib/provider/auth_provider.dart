import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // ✅ Pastikan ini ada

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  User? _user;
  User? get user => _user;

  bool _initialized = false;

  // ─── ✅ GETTER INI YANG DICARI OLEH MAIN.DART ───
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode; // ← Pastikan baris ini ada!

  AuthProvider() {
    // ✅ PERBAIKAN UTAMA: Muat tema terlebih dahulu secara aman, baru aktifkan listener Firebase
    _initThemeAndAuth();
  }

  // ✅ FUNGSI BARU: Mengatur urutan inisialisasi data agar tidak saling tabrakan
  Future<void> _initThemeAndAuth() async {
    await _loadThemeFromPrefs(); // Jalankan dan tunggu hingga preferensi tema selesai dimuat
    
    // Setelah tema aman, baru dengarkan perubahan auth Firebase
    _auth.authStateChanges().listen((User? newUser) {
      _user = newUser;
      notifyListeners();
    });

    _initGoogleSignIn();
  }

  // ─── ✅ LOGIKA MANAJEMEN TEMA ───
  Future<void> _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('darkMode') ?? false;
    notifyListeners(); 
  }

  Future<void> toggleTheme(bool value) async {
    _isDarkMode = value;
    notifyListeners(); // Langsung refresh UI secara lokal agar responsif instan
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
  }

  Future<void> _initGoogleSignIn() async {
    if (_initialized) return;

    _initialized = true;

    await _googleSignIn.initialize();

    _googleSignIn.attemptLightweightAuthentication();
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser =
          await _googleSignIn.authenticate();

      final String? idToken =
          googleUser.authentication.idToken;

      if (idToken == null) {
        throw Exception("ID Token tidak ditemukan");
      }

      final AuthCredential credential =
          GoogleAuthProvider.credential(
        idToken: idToken,
      );

      await _auth.signInWithCredential(
        credential,
      );

      // Kirim ke backend PHP (opsional)
      try {
        const String baseUrl = "http://10.230.232.96";

        final response = await http.post(
          Uri.parse(
            "$baseUrl/api_code/login.php",
          ),
          body: {
            "id_token": idToken,
          },
        );

        debugPrint(
          "Status HTTP: ${response.statusCode}",
        );

        debugPrint(
          "Response: ${response.body}",
        );

        jsonDecode(response.body);
      } catch (e) {
        debugPrint(
          "Gagal menghubungi backend PHP: $e",
        );
      }
    } catch (e) {
      debugPrint(
        "Google Sign In Error: $e",
      );
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}