import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/auth_provider.dart';

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

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Load username yang tersimpan
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

  // Login manual
  Future<void> login() async {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Username dan password tidak boleh kosong"),
        ),
      );
      return;
    }

    if (username == "Aulan" && password == "123") {
      setState(() {
        isLoading = true;
      });

      final prefs = await SharedPreferences.getInstance();

      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('username', username);

      if (rememberMe) {
        await prefs.setString('savedUsername', username);
      } else {
        await prefs.remove('savedUsername');
      }

      await prefs.setString(
        'lastLogin',
        DateTime.now().toString(),
      );

      setState(() {
        isLoading = false;
      });

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Username atau Password salah"),
        ),
      );
    }
  }

  // Login Google Firebase
  Future<void> loginGoogle() async {
    setState(() {
      isLoading = true;
    });

    try {
      await Provider.of<AuthProvider>(
        context,
        listen: false,
      ).signInWithGoogle();

      final user = Provider.of<AuthProvider>(
        context,
        listen: false,
      ).user;

      if (user != null) {
        final prefs = await SharedPreferences.getInstance();

        await prefs.setBool('isLoggedIn', true);
        await prefs.setString(
          'username',
          user.displayName ?? '',
        );
        await prefs.setString(
          'email',
          user.email ?? '',
        );
        await prefs.setString(
          'photoUrl',
          user.photoURL ?? '',
        );

        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Login Google gagal: $e"),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purpleAccent,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.lock,
                    size: 80,
                    color: Colors.deepPurple,
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "LOGIN",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 30),

                  TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Username",
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),

                  const SizedBox(height: 10),

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

                  if (isLoading)
                    const CircularProgressIndicator()
                  else ...[
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: login,
                        child: const Text(
                          "Login Manual",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: loginGoogle,
                        icon: const Icon(Icons.login),
                        label: const Text(
                          "Login dengan Google",
                          style: TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}