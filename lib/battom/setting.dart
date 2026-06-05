import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'package:shared_preferences/shared_preferences.dart';
import '/provider/auth_provider.dart'; // ✅ Ganti import ke AuthProvider

class SettingPage extends StatefulWidget {  
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  SharedPreferences? prefs;
  String username = '';
  String email = '';
  bool isNotificationEnabled = true;

  @override
  void initState() {
    super.initState();
    loadUserData();      
    loadNotificationSettings(); 
  }

  Future<void> loadUserData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs?.getString('username') ?? 'Belum login';
      email = prefs?.getString('email') ?? 'user@example.com';
    });
  }

  Future<void> loadNotificationSettings() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      isNotificationEnabled = prefs?.getBool('notificationEnabled') ?? true;
    });
  }

  Future<void> saveNotification(bool value) async {
    prefs = await SharedPreferences.getInstance();
    await prefs?.setBool('notificationEnabled', value);
    setState(() {
      isNotificationEnabled = value;
    });
  }

  Future<void> logout() async {
    prefs = await SharedPreferences.getInstance();
    await prefs?.setBool('isLoggedIn', false);
    
    // Panggil fungsi signOut global dari AuthProvider jika diperlukan
    if (mounted) {
      Provider.of<AuthProvider>(context, listen: false).signOut();
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi Logout"),
        content: const Text("Apakah Anda yakin ingin logout?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          TextButton(
            onPressed: () { 
              Navigator.pop(context); 
              logout(); 
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Ambil instansiasi AuthProvider global di sini (bukan ThemeNotifier lagi)
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengaturan"),
        // Warna AppBar dinamis mengikuti properti isDarkMode dari AuthProvider
        backgroundColor: authProvider.isDarkMode ? Colors.grey[900] : Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          // ========== SECTION: PROFIL PENGGUNA ==========
          Card(
            margin: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text("PROFIL PENGGUNA", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text("Username"),
                  subtitle: Text(username),
                ),
                ListTile(
                  leading: const Icon(Icons.email),
                  title: const Text("Email"),
                  subtitle: Text(email),
                ),
              ],
            ),
          ),
  
          // ========== SECTION: PENGATURAN APLIKASI ==========
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text("PENGATURAN APLIKASI", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                const Divider(),
                // Switch untuk Mode Gelap global
                SwitchListTile(
                  title: const Text("Mode Gelap"),
                  subtitle: const Text("Ubah tampilan aplikasi menjadi gelap"),
                  secondary: const Icon(Icons.dark_mode),
                  value: authProvider.isDarkMode, // ✅ Membaca dari AuthProvider
                  onChanged: (bool value) {
                    authProvider.toggleTheme(value); // ✅ Memperbarui via AuthProvider
                  },
                ),
                SwitchListTile(
                  title: const Text("Notifikasi"),
                  subtitle: const Text("Aktifkan atau matikan notifikasi"),
                  secondary: const Icon(Icons.notifications),
                  value: isNotificationEnabled,
                  onChanged: saveNotification,
                ),
              ],
            ),
          ),
  
          // ========== Logout ==========
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: showLogoutConfirmation,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("LOGOUT", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}