import 'package:flutter/material.dart';

class DetailCode extends StatelessWidget {
  final Map mapData;

  const DetailCode({
    super.key,
    required this.mapData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Kode Error"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Kode Error : ${mapData['kode']}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),

            Text("Nama Error : ${mapData['nama_error']}"),
            const SizedBox(height: 10),

            Text("Deskripsi : ${mapData['deskripsi']}"),
            const SizedBox(height: 10),

            Text("Penyebab : ${mapData['penyebab']}"),
            const SizedBox(height: 10),

            Text("Solusi : ${mapData['solusi']}"),
          ],
        ),
      ),
    );
  }
}