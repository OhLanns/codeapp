import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

typedef AnnouncementHandler = void Function(Map<String, dynamic> data);

class SocketService {
  SocketService._internal();
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;

  io.Socket? _socket;
  String? _serverUrl;
  AnnouncementHandler? _onAnnouncementReceived;
  VoidCallback? _onConnected;
  VoidCallback? _onDisconnected;

  bool get isConnected => _socket?.connected ?? false;

  void connect({
    required String serverUrl,
    required AnnouncementHandler onAnnouncementReceived,
    VoidCallback? onConnected,
    VoidCallback? onDisconnected,
  }) {
    _serverUrl = serverUrl;
    _onAnnouncementReceived = onAnnouncementReceived;
    _onConnected = onConnected;
    _onDisconnected = onDisconnected;

    if (_socket != null && _socket!.connected) {
      _onConnected?.call();
      return;
    }

    _socket = io.io(
      serverUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .enableReconnection()
          .build(),
    );

    _socket!.onConnect((_) {
      log('Socket connected: ${_socket!.id}');
      _onConnected?.call();
    });

    _socket!.onDisconnect((_) {
      log('Socket disconnected');
      _onDisconnected?.call();
    });

    // 🔔 Mendengarkan siaran balik dari server.js untuk memicu notifikasi lokal
    _socket!.on('announcement:received', (data) {
      if (data is Map) {
        _onAnnouncementReceived?.call(Map<String, dynamic>.from(data));
      }
    });

    _socket!.connect();
  }

  // ✅ PERBAIKAN: Menyesuaikan parameter dan nama event emisi agar sinkron dengan server.js dan home_page.dart
  void sendAnnouncement(Map<String, dynamic> data) {
    if (_socket == null || !_socket!.connected) {
      log('Gagal mengirim, socket tidak aktif atau belum terhubung.');
      return;
    }
    
    // Menembak ke event 'sendAnnouncement' sesuai yang didengar io.on di backend
    _socket!.emit('sendAnnouncement', data);
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }
}