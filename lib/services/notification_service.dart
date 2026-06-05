import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._internal();
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
        
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    // Format ini menggunakan nama parameter 'settings:' dan callback 'onSelectNotification'
    await _notificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint("Notifikasi diklik: ${response.payload}");
      },
    );
    
    _initialized = true;
  }
  
  Future<bool?> requestNotificationPermission() async {
    final android = _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    
    final granted = await android?.requestNotificationsPermission();
    debugPrint('Notification permission granted: $granted');
    return granted;
  }

  Future<void> showNotification({required String title, required String body}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'realtime_announcement_channel',
      'Realtime Announcement',
      channelDescription: 'Channel untuk notifikasi pengumuman realtime',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );
    
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // ✅ FIX TOTAL UNTUK VERSI 21+: Semua parameter wajib menggunakan nama label
    await _notificationsPlugin.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000, 
      title: title, 
      body: body, 
      notificationDetails: platformChannelSpecifics, 
    );
  }
}