import 'package:flutter/material.dart';
// ✅ IMPORT KORREK: Mengarah ke file konten halaman yang berada di folder code_error
import 'package:codeapp/code_error/halaman_kode.dart'; 

class CodePage extends StatelessWidget {
  const CodePage({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Langsung mengembalikan HalamanPage tanpa pembungkus MaterialApp tambahan
    // agar sinkronisasi Dark Mode dari AuthProvider tetap mengalir dengan lancar.
    return const HalamanPage(); 
  }
}