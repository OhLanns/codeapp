import 'dart:convert';

import 'package:codeapp/code_error/halaman_kode.dart';
import 'package:codeapp/battom/code.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class UbahCode extends StatefulWidget {
  final Map mapData;

  const UbahCode({super.key, required this.mapData});

  @override
  State<UbahCode> createState() => _UbahCodeState();
}

class _UbahCodeState extends State<UbahCode> {
  final formKey = GlobalKey<FormState>();

  TextEditingController idKode = TextEditingController();
  TextEditingController idMotor = TextEditingController();
  TextEditingController kode = TextEditingController();
  TextEditingController namaError = TextEditingController();
  TextEditingController deskripsi = TextEditingController();
  TextEditingController penyebab = TextEditingController();
  TextEditingController solusi = TextEditingController();

  final logger = Logger();

  @override
void initState() {
  super.initState();

  idKode.text = widget.mapData['id_kode'].toString(); 
  idMotor.text = widget.mapData['id_motor'].toString();
  kode.text = widget.mapData['kode'] ?? '';
  namaError.text = widget.mapData['nama_error'] ?? '';
  deskripsi.text = widget.mapData['deskripsi'] ?? '';
  penyebab.text = widget.mapData['penyebab'] ?? '';
  solusi.text = widget.mapData['solusi'] ?? '';
}
  Future<bool> ubah() async {
    try {
      final respon = await http.post(
        Uri.parse('http://10.230.232.96/api_code/edit.php'),
        body: {
          'id_kode': idKode.text,
          'id_motor': idMotor.text,
          'kode': kode.text,
          'nama_error': namaError.text,
          'deskripsi': deskripsi.text,
          'penyebab': penyebab.text,
          'solusi': solusi.text,
        },
      );

  // DEBUG

      if (respon.statusCode == 200) {
        final data = jsonDecode(respon.body);
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      logger.e('Error: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubah Kode Error'),
        backgroundColor: Colors.orange,
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // KODE
                TextFormField(
                  controller: kode,
                  decoration: InputDecoration(
                    hintText: 'Kode',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Kode tidak boleh kosong!' : null,
                ),

                const SizedBox(height: 10),

                // NAMA ERROR
                TextFormField(
                  controller: namaError,
                  decoration: InputDecoration(
                    hintText: 'Nama Error',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Nama error tidak boleh kosong!' : null,
                ),

                const SizedBox(height: 10),

                // DESKRIPSI
                TextFormField(
                  controller: deskripsi,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Deskripsi',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // PENYEBAB
                TextFormField(
                  controller: penyebab,
                  decoration: InputDecoration(
                    hintText: 'Penyebab',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // SOLUSI
                TextFormField(
                  controller: solusi,
                  decoration: InputDecoration(
                    hintText: 'Solusi',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // BUTTON
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final result = await ubah();

                      if (result) {
                        messagerKey.currentState!.showSnackBar(
                          const SnackBar(
                            content: Text('Data berhasil diubah!'),
                          ),
                        );
                      } else {
                        messagerKey.currentState!.showSnackBar(
                          const SnackBar(
                            content: Text('Gagal mengubah data!'),
                          ),
                        );
                      }

                      navigatorKey.currentState!.pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const HalamanCode()),
                        (route) => false,
                      );
                    }
                  },
                  child: const Text('Simpan Perubahan'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}