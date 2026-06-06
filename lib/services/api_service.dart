import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // 🚀 ATUR IP ADDRESS LAPTOP ANDA:
  // Gunakan 'http://10.0.2.2/notifikasi-server' jika menggunakan EMULATOR Android Studio.
  // Gunakan IP lokal Wi-Fi (misal 'http://192.168.1.5/notifikasi-server') jika mengetes lewat HP asli.
  static const String _baseUrl = 'http://10.230.232.96/notifikasi-server';

  // ✅ Perbaiki: Menyimpan Token FCM Perangkat ke DB MySQL
  static Future<bool> registerToken({
    required String userId,
    required String fcmToken,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/register_token.php'), // 🔥 Perbaiki endpoint
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'fcm_token': fcmToken,
        }),
      );
      final data = jsonDecode(response.body);
      return data['success'] == true;
    } catch (e) {
      debugPrint('Error registerToken: $e');
      return false;
    }
  }

  // ✅ Perbaiki: Menyiarkan pesan via PHP Endpoint ke Firebase
  static Future<bool> siarkanPesan({
    required String senderName,
    required String message,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/siarkan_bantuan.php'), // 🔥 Endpoint yang benar
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'senderName': senderName,
          'message': message,
        }),
      );
      final data = jsonDecode(response.body);
      return data['success'] == true;
    } catch (e) {
      debugPrint('Error siarkanPesan: $e');
      return false;
    }
  }
}