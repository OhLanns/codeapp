import 'package:flutter/material.dart';

class KawasakiPage extends StatelessWidget {
  const KawasakiPage ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kawasaki")),
      body: const Center(
        child: Text("Halaman KAWASAKI"),
      ),
    );
  }
}