import 'package:flutter/material.dart';
import 'package:codeapp/code_error/halaman_kode.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>(); 
final GlobalKey<ScaffoldMessengerState> messagerKey = GlobalKey<ScaffoldMessengerState>();


class CodePage extends StatelessWidget {
  const CodePage ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Kode Error Motor',
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: messagerKey,
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),

      home: const HalamanCode(), // ini nanti bisa diganti ke halaman motor kalau mau upgrade
    );
  }
}