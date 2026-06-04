import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {  
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  // Shared Preferences variable
  SharedPreferences? prefs;
  
  // Data user
  String username = '';
  String email = '';
  
  // Pengaturan
  bool isDarkMode = false;
  bool isNotificationEnabled = true;
  double fontSize = 16.0;

  @override
  void initState() {
    super.initState();
    loadUserData();      // Load data user
       // Load pengaturan
  }

  // ✅ FUNGSI MEMUAT DATA USER DARI SHARED PREFERENCES
  Future<void> loadUserData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs?.getString('username') ?? 'Belum login';
      email = prefs?.getString('email') ?? 'user@example.com';
    });
  }

  // ✅ FUNGSI MEMUAT PENGATURAN DARI SHARED PREFERENCES
  

  // ✅ FUNGSI LOGOUT (MENGHAPUS DATA LOGIN)
  Future<void> logout() async {
    prefs = await SharedPreferences.getInstance();
    
    // Hapus data login/session
    await prefs?.setBool('isLoggedIn', false);  // Set status login jadi false
    await prefs?.remove('username');             // Hapus username (opsional)
    // await prefs?.clear();  // Hapus semua data (jika ingin reset total)
    
    // Tampilkan pesan
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Berhasil logout!")),
      );
      
      // Kembali ke halaman Login
      Navigator.pushReplacementNamed(context, '/login');
      // Atau jika tidak pakai named route:
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => const LoginPage()),
      // );
    }
  }

  // ✅ FUNGSI KONFIRMASI LOGOUT (DENGAN DIALOG)
  void showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konfirmasi Logout"),
          content: const Text("Apakah Anda yakin ingin logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);  // Tutup dialog
                logout();                // Jalankan logout
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }

  // ✅ FUNGSI MENYIMPAN DARK MODE
  Future<void> saveDarkMode(bool value) async {
    prefs = await SharedPreferences.getInstance();
    await prefs?.setBool('darkMode', value);
    setState(() {
      isDarkMode = value;
    });
  }

  // ✅ FUNGSI MENYIMPAN NOTIFIKASI
  

  // ✅ FUNGSI EDIT PROFIL
  void editProfile() {
    TextEditingController usernameController = TextEditingController(text: username);
    TextEditingController emailController = TextEditingController(text: email);
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Profil"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () async {
                // Simpan perubahan ke Shared Preferences
                prefs = await SharedPreferences.getInstance();
                await prefs?.setString('username', usernameController.text);
                await prefs?.setString('email', emailController.text);
                
                setState(() {
                  username = usernameController.text;
                  email = emailController.text;
                });
                
                Navigator.pop(context);
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Profil berhasil diupdate")),
                );
              },
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengaturan"),
        backgroundColor: Colors.blue,
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
                  child: Text(
                    "PROFIL PENGGUNA",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text("Username"),
                  subtitle: Text(username),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: editProfile,
                ),
                ListTile(
                  leading: const Icon(Icons.email),
                  title: const Text("Email"),
                  subtitle: Text(email),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: editProfile,
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text("Edit Profil"),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: editProfile,
                ),
              ],
            ),
          ),

          // ========== Logout ==========
                   Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: showLogoutConfirmation,  // ← PAKAI KONFIRMASI DULU
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "LOGOUT",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}