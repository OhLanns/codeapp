import 'package:flutter/material.dart';

class DetailCode extends StatelessWidget {
  final Map mapData;

  const DetailCode({super.key, required this.mapData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Kode Error'),
        backgroundColor: Color.fromARGB(255, 250, 237, 202),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Card(
          elevation: 10,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: ListView(
              children: [
                ListTile(
                  title: Text('ID Kode'),
                  subtitle: Text(mapData['id_kode'].toString()),
                ),
                ListTile(
                  title: Text('Kode Error'),
                  subtitle: Text(mapData['kode']),
                ),
                ListTile(
                  title: Text('Nama Error'),
                  subtitle: Text(mapData['nama_error']),
                ),
                ListTile(
                  title: Text('Deskripsi'),
                  subtitle: Text(mapData['deskripsi']),
                ),
                ListTile(
                  title: Text('Penyebab'),
                  subtitle: Text(mapData['penyebab']),
                ),
                ListTile(
                  title: Text('Solusi'),
                  subtitle: Text(mapData['solusi']),
                ),
                ListTile(
                  title: Text('Populer'),
                  subtitle: Text(
                    mapData['populer'] == "1"
                        ? "Sering Terjadi"
                        : "Tidak Umum",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}