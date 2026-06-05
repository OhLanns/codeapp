import 'dart:convert'; // ✅ Dibutuhkan untuk decode/encode JSON SharedPreferences
import 'package:codeapp/pages/riwayat_saya.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:codeapp/battom/setting.dart';
import 'package:codeapp/battom/code.dart';
import 'package:codeapp/battom/category.dart';
import '/provider/auth_provider.dart';
import '/provider/announcement_provider.dart';
import '/services/notification_service.dart';
import '/services/socket_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // 🔒 KUNCI UTUH: Susunan halaman murni 4 item (indeks 0 - 3)
  final List<Widget> _pages = [
    const HomeContent(),      // Indeks 0
    const CodePage(),         // Indeks 1
    const CategoryPage(),     // Indeks 2
    const SettingPage(),      // Indeks 3
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Jika membuka halaman Code (Index 1), hilangkan notifikasi titik merah
    if (index == 1) {
      Provider.of<AnnouncementProvider>(context, listen: false).markAsRead();
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasBadge = Provider.of<AnnouncementProvider>(context).hasNewAnnouncement;

    // ✅ PROTEKSI ANTI CRASH: Validasi nilai agar currentIndex selalu berada dalam jangkauan yang sah (0-3)
    int safeIndex = _selectedIndex;
    if (safeIndex < 0 || safeIndex >= 4) {
      safeIndex = 0; 
    }

    return Scaffold(
      body: IndexedStack(
        index: safeIndex, // Menggunakan indeks yang sudah divalidasi aman
        children: _pages,
      ),
      // 🔒 KUNCI UTUH: Komponen navigasi bawah 100% menggunakan formasi orisinal Anda
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: safeIndex, // Menggunakan indeks yang sudah divalidasi aman
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Badge(
              isLabelVisible: hasBadge,
              backgroundColor: Colors.red,
              child: const Icon(Icons.code),
            ),
            label: "Code",
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.category), label: "Kategori"),
          const BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Setting"),
        ],
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  SharedPreferences? prefs;
  String username = '';
  String email = '';
  bool _isConnected = false;

  final TextEditingController _announcementController = TextEditingController();
  static const String _serverUrl = 'http://10.230.232.96:3000'; 

  @override
  void initState() {
    super.initState();
    loadUserData();
    _initRealtimeSocket(); 
  }

  @override
  void dispose() {
    _announcementController.dispose(); 
    super.dispose();
  }

  Future<void> loadUserData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs?.getString('username') ?? 'User';
      email = prefs?.getString('email') ?? 'user@example.com';
    });
  }

  void _initRealtimeSocket() {
    setState(() => _isConnected = SocketService().isConnected);

    SocketService().connect(
      serverUrl: _serverUrl,
      onAnnouncementReceived: (data) async {
        final sender = data['senderName'] ?? 'Sistem';
        final msg = data['message'] ?? '';
        
        if (mounted) {
          Provider.of<AnnouncementProvider>(context, listen: false).addAnnouncement(data);
        }

        await NotificationService().showNotification(
          title: 'Notifikasi Baru dari $sender',
          body: msg,
        );
      },
      onConnected: () {
        if (mounted) setState(() => _isConnected = true);
      },
      onDisconnected: () {
        if (mounted) setState(() => _isConnected = false);
      },
    );
  }

  Future<void> _saveMessageToLocal(String text, String timestamp) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> currentHistory = prefs.getStringList('my_local_announcements') ?? [];
    
    String newEntry = jsonEncode({
      'message': text,
      'timestamp': timestamp,
    });
    
    currentHistory.insert(0, newEntry);
    await prefs.setStringList('my_local_announcements', currentHistory);
  }

  void _sendAnnouncement() async {
    final text = _announcementController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ketik pesan pengumuman terlebih dahulu!')),
      );
      return;
    }

    if (!_isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengirim, server sedang terputus!')),
      );
      return;
    }

    final currentTimestamp = DateTime.now().toIso8601String();

    SocketService().sendAnnouncement({
      'senderName': username,
      'message': text,
      'timestamp': currentTimestamp,
    });

    await _saveMessageToLocal(text, currentTimestamp);

    _announcementController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pengumuman disiarkan & disimpan ke riwayat Anda!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final announcementProvider = Provider.of<AnnouncementProvider>(context);
    final isDark = authProvider.isDarkMode;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _isConnected ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isConnected ? Icons.cloud_done : Icons.cloud_off,
                      color: _isConnected ? Colors.green : Colors.red,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _isConnected ? "Server Terhubung" : "Server Terputus",
                      style: TextStyle(
                        color: _isConnected ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.campaign, color: isDark ? Colors.blue[300] : Colors.blue, size: 28),
                              const SizedBox(width: 8),
                              const Text(
                                "Tanya Code / Pengumuman",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.history, color: Colors.blue),
                            onPressed: () {
                              // ✅ MENGGUNAKAN PUSH NAVIGATION: Agar terpisah penuh dari sistem indeks tab bar bawah
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const RiwayatSayaPage()),
                              );
                            },
                            tooltip: "Lihat Riwayat Saya",
                          )
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _announcementController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: "Tanyakan sesuatu ke pengguna lain",
                          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.blue, width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton.icon(
                          onPressed: _sendAnnouncement,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(Icons.send),
                          label: const Text("Siarkan ke Semua Pengguna", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
              
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: const Text("Username"),
                        subtitle: Text(username), 
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.email),
                        title: const Text("Email"),
                        subtitle: Text(email), 
                      ),
                      const Divider(),
                      ListTile(
                        leading: Icon(Icons.info, color: _isConnected ? Colors.green : Colors.grey),
                        title: const Text("Status Koneksi App"),
                        subtitle: Text(_isConnected ? "Online (Realtime Active)" : "Offline"),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Badge(
                    isLabelVisible: announcementProvider.hasNewAnnouncement,
                    backgroundColor: Colors.red,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final homeState = context.findAncestorStateOfType<_HomePageState>();
                        homeState?._onItemTapped(1); // Pindah ke tab Code (Index 1)
                      },
                      icon: const Icon(Icons.code),
                      label: const Text("Lihat Code"),
                    ),
                  ),
                  // ✅ MENGGUNAKAN PUSH NAVIGATION: Membuka riwayat sebagai layer di atas layar utama
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RiwayatSayaPage()),
                      );
                    },
                    icon: const Icon(Icons.chat),
                    label: const Text("Chat Saya"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}