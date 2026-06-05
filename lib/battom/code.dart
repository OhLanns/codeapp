import 'package:flutter/material.dart';
import 'package:codeapp/code_error/halaman_kode.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>(); 

class CodePage extends StatelessWidget {
  const CodePage({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Langsung arahkan ke HalamanCode() tanpa dibungkus MaterialApp lagi.
    // Sekarang halaman ini dijamin akan ikut otomatis menjadi hitam saat mode gelap aktif!
    return const HalamanCode(); 
  }
}