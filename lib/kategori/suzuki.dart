import 'package:flutter/material.dart';

class SuzukiPage extends StatelessWidget {
  const SuzukiPage ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Suzuki")),
      body: const Center(
        child: Text("Halaman SUZUKI"),
      ),
    );
  }
}