import 'package:flutter/material.dart';

class HondaPage extends StatelessWidget {
  const HondaPage ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Honda")),
      body: const Center(
        child: Text("Halaman HONDA"),
      ),
    );
  }
}