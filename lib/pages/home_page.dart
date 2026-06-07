import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:codeapp/battom/setting.dart';
import 'package:codeapp/battom/code.dart';
import 'package:codeapp/battom/category.dart';
import 'package:codeapp/pages/tambah_iklan.dart';
import 'package:codeapp/pages/riwayat_saya.dart';
import '/provider/auth_provider.dart';
import 'package:codeapp/provider/iklan_provider.dart';
import 'package:codeapp/models/iklan_model.dart';
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

  final List<Widget> _pages = [
    const HomeContent(),
    const CodePage(),
    const CategoryPage(),
    const SettingPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Provider.of<AnnouncementProvider>(context, listen: false).markAsRead();
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasBadge = Provider.of<AnnouncementProvider>(context).hasNewAnnouncement;

    int safeIndex = _selectedIndex;
    if (safeIndex < 0 || safeIndex >= 4) {
      safeIndex = 0;
    }

    return Scaffold(
      body: IndexedStack(
        index: safeIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: safeIndex,
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

class _HomeContentState extends State<HomeContent> with WidgetsBindingObserver {
  SharedPreferences? prefs;
  String username = '';
  String email = '';
  bool _isConnected = false;
  bool _isLoadingIklan = true;

  final TextEditingController _announcementController = TextEditingController();
  static const String _serverUrl = 'http://10.230.232.96:3000';
  static const String _baseUrl = 'http://10.230.232.96/api_code';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    loadUserData();
    _initRealtimeSocket();
    _loadIklanData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _announcementController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _refreshIklan();
    }
  }

  Future<void> _refreshIklan() async {
    if (mounted) {
      setState(() {
        _isLoadingIklan = true;
      });
      
      try {
        await Provider.of<IklanProvider>(context, listen: false).loadIklan();
        print('Iklan refreshed successfully');
      } catch (e) {
        print('Error refresh iklan: $e');
      } finally {
        if (mounted) {
          setState(() {
            _isLoadingIklan = false;
          });
        }
      }
    }
  }

  Future<void> _loadIklanData() async {
    setState(() {
      _isLoadingIklan = true;
    });
    
    try {
      await Provider.of<IklanProvider>(context, listen: false).loadIklan();
      print('Total iklan: ${Provider.of<IklanProvider>(context, listen: false).iklanList.length}');
    } catch (e) {
      print('Error loading iklan: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingIklan = false;
        });
      }
    }
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
    final iklanProvider = Provider.of<IklanProvider>(context);

    final iklanAktif = iklanProvider.getIklanAktif();
    final isDark = authProvider.isDarkMode;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshIklan,
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),

                // Banner Iklan dengan loading state
                if (_isLoadingIklan)
                  Container(
                    height: 180,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 10),
                          Text('Memuat iklan...'),
                        ],
                      ),
                    ),
                  )
                else if (iklanAktif.isNotEmpty)
                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: iklanAktif.length,
                      itemBuilder: (context, index) {
                        final iklan = iklanAktif[index];
                        final imageUrl = '$_baseUrl/upload/${iklan.gambar}';
                        
                        return Container(
                          width: MediaQuery.of(context).size.width - 32,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (_) => Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.9,
                                    constraints: BoxConstraints(
                                      maxHeight: MediaQuery.of(context).size.height * 0.7,
                                    ),
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                iklan.namaUsaha,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.close),
                                              onPressed: () => Navigator.pop(context),
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        
                                        SizedBox(
                                          height: 200,
                                          width: double.infinity,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: Image.network(
                                              imageUrl,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              loadingBuilder: (context, child, loadingProgress) {
                                                if (loadingProgress == null) return child;
                                                return const Center(
                                                  child: CircularProgressIndicator(),
                                                );
                                              },
                                              errorBuilder: (context, error, stackTrace) {
                                                return Container(
                                                  color: Colors.grey[300],
                                                  child: const Center(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Icon(Icons.error_outline, size: 50),
                                                        SizedBox(height: 8),
                                                        Text('Gambar tidak ditemukan'),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        
                                        const SizedBox(height: 16),
                                        
                                        if (iklan.lokasi.isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 8),
                                            child: Row(
                                              children: [
                                                const Icon(Icons.location_on, size: 18, color: Colors.grey),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    iklan.lokasi,
                                                    style: const TextStyle(fontSize: 14),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        
                                        Text(
                                          iklan.deskripsi.isNotEmpty ? iklan.deskripsi : "Toko terpercaya dengan pelayanan terbaik",
                                          style: const TextStyle(fontSize: 14, height: 1.4),
                                        ),
                                        
                                        const SizedBox(height: 12),
                                        
                                        if (iklan.whatsapp.isNotEmpty)
                                          Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                            decoration: BoxDecoration(
                                              color: Colors.green.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              children: [
                                                const Icon(Icons.message, color: Colors.green, size: 20),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    iklan.whatsapp,
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        
                                        const SizedBox(height: 20),
                                        
                                        SizedBox(
                                          width: double.infinity,
                                          height: 45,
                                          child: ElevatedButton(
                                            onPressed: () => Navigator.pop(context),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.blue,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: const Text("Tutup"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                imageUrl,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    color: Colors.grey[200],
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  print('Error loading image: $error');
                                  return Container(
                                    color: Colors.grey[300],
                                    child: const Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.broken_image, size: 50, color: Colors.grey),
                                          SizedBox(height: 8),
                                          Text('Gambar tidak ditemukan', style: TextStyle(fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                else
                  Container(
                    height: 180,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.campaign, size: 50, color: Colors.grey[400]),
                          const SizedBox(height: 10),
                          Text(
                            "Belum ada iklan",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const TambahIklanPage(),
                                ),
                              );
                              if (result == true) {
                                await _refreshIklan();
                              }
                            },
                            child: const Text("Pasang Iklan Sekarang"),
                          ),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 20),

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

                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Badge(
                          isLabelVisible: announcementProvider.hasNewAnnouncement,
                          backgroundColor: Colors.red,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              final homeState = context.findAncestorStateOfType<_HomePageState>();
                              homeState?._onItemTapped(1);
                            },
                            icon: const Icon(Icons.code),
                            label: const Text("Lihat Code"),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RiwayatSayaPage(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.chat),
                          label: const Text("Chat Saya"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TambahIklanPage(),
                            ),
                          );
                          if (result == true) {
                            await _refreshIklan();
                          }
                        },
                        icon: const Icon(Icons.campaign),
                        label: const Text("Pasang Iklan"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}