import 'package:flutter/material.dart';
import 'package:codeapp/kategori/yamaha.dart';
import 'package:codeapp/kategori/honda.dart';
import 'package:codeapp/kategori/suzuki.dart';
import 'package:codeapp/kategori/kawasaki.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  void _onItemTapped(String merek) {
    if (merek == "YAMAHA") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const YamahaPage()),
      );
    } else if (merek == "HONDA") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HondaPage()),
      );
    } else if (merek == "SUZUKI") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SuzukiPage()),
      );
    } else if (merek == "KAWASAKI") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const KawasakiPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Category"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _menuButton("YAMAHA", Colors.blue, () => _onItemTapped("YAMAHA")),
            const SizedBox(height: 15),
            _menuButton("HONDA", Colors.red, () => _onItemTapped("HONDA")),
            const SizedBox(height: 15),
            _menuButton("SUZUKI", Colors.orange, () => _onItemTapped("SUZUKI")),
            const SizedBox(height: 15),
            _menuButton("KAWASAKI", Colors.green, () => _onItemTapped("KAWASAKI")),
          ],
        ),
      ),
    );
  }

  Widget _menuButton(String title, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220,
        height: 60,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}