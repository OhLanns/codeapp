import 'package:flutter/material.dart';
import 'package:codeapp/kategori/yamaha.dart';
import 'package:codeapp/kategori/honda.dart';
import 'package:codeapp/kategori/suzuki.dart';
import 'package:codeapp/kategori/kawasaki.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage ({super.key});

  @override
  State<CategoryPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<CategoryPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const YamahaPage()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HondaPage()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SuzukiPage()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const KawasakiPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Category")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _menuButton("YAMAHA", Colors.blue, 0),
            const SizedBox(height: 15),
            _menuButton("HONDA", Colors.red, 1),
            const SizedBox(height: 15),
            _menuButton("SUZUKI", Colors.orange, 2),
            const SizedBox(height: 15),
            _menuButton("KAWASAKI", Colors.green, 3),
          ],
        ),
      ),
    );
  }

  Widget _menuButton(String title, Color color, int index) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
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