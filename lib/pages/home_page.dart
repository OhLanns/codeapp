import 'package:codeapp/battom/setting.dart';
import 'package:flutter/material.dart';
import 'package:codeapp/battom/code.dart';
import 'package:codeapp/battom/category.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomePage> {
  int _selectedIndex = 0;

  // Daftar halaman yang akan ditampilkan
  final List<Widget> _pages = [
    const HomeContent(),      // Konten Home
    const CodePage(),         // Halaman Code
    const CategoryPage(),     // Halaman Kategori
    const SettingPage(),      // Halaman Setting
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TAMPILKAN KONTEN SESUAI INDEX YANG DIPILIH
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home), 
            label: "Home"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.code), 
            label: "Code"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category), 
            label: "Kategori"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings), 
            label: "Setting"
          ),
        ],
      ),
    );
  }
}

// WIDGET KHUSUS UNTUK KONTEN HOME - YANG DIUPDATE
class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  SharedPreferences? prefs;
  String username = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs?.getString('username') ?? 'Belum login';
      email = prefs?.getString('email') ?? 'user@example.com';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Header
            const Icon(
              Icons.home,
              size: 80,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            const Text(
              "Selamat Datang!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Ini adalah halaman utama aplikasi",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            
            // Card Informasi - Data DINAMIS dari SharedPreferences
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text("Username"),
                      subtitle: Text(username), // ← Data dari SharedPreferences
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.email),
                      title: const Text("Email"),
                      subtitle: Text(email), // ← Data dari SharedPreferences
                    ),
                    const Divider(),
                    const ListTile(
                      leading: Icon(Icons.info),
                      title: Text("Status"),
                      subtitle: Text("Aktif"),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Tombol Navigasi Cepat
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigasi ke halaman Code
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CodePage()),
                    );
                  },
                  icon: const Icon(Icons.code),
                  label: const Text("Lihat Code"),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    // Navigasi ke halaman Setting dan refresh data saat kembali
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SettingPage()),
                    );
                    // Refresh data setelah kembali dari Setting
                    await loadUserData();
                  },
                  icon: const Icon(Icons.settings),
                  label: const Text("Pengaturan"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}