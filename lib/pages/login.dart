import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool rememberMe = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadSavedUsername();
  }

  // Load username yang tersimpan (jika remember me aktif)
  Future<void> loadSavedUsername() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedUsername = prefs.getString('savedUsername');
    if (savedUsername != null) {
      setState(() {
        usernameController.text = savedUsername;
        rememberMe = true;
      });
    }
  }

  // Fungsi LOGIN
  Future<void> login() async {
    String username = usernameController.text;
    String password = passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username dan password tidak boleh kosong")),
      );
      return;
    }

    // Contoh validasi sederhana
    if (username == "Aulan" && password == "123") {
      setState(() => isLoading = true);
      
      // Simpan ke Shared Preferences
      final prefs = await SharedPreferences.getInstance();
      
      // ✅ SIMPAN STATUS LOGIN
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('username', username);
      
      // Simpan jika remember me dicentang
      if (rememberMe) {
        await prefs.setString('savedUsername', username);
      } else {
        await prefs.remove('savedUsername');
      }
      
      // Simpan waktu login
      await prefs.setString('lastLogin', DateTime.now().toString());
      
      setState(() => isLoading = false);
      
      // ✅ LANGSUNG KE HOME DAN HAPUS HISTORY
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username atau Password salah")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purpleAccent,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "LOGIN",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Checkbox(
                  value: rememberMe,
                  onChanged: (value) {
                    setState(() {
                      rememberMe = value ?? false;
                    });
                  },
                ),
                const Text("Remember Me"),
              ],
            ),
            const SizedBox(height: 20),

            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: login,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 45),
                    ),
                    child: const Text("Login"),
                  ),
          ],
        ),
      ),
    );
  }
}