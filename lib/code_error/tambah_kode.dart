import 'dart:convert';

import 'package:codeapp/code_error/halaman_kode.dart';
import 'package:codeapp/battom/code.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class TambahCode extends StatefulWidget {
  const TambahCode({super.key});

  @override
  State<TambahCode> createState() => _TambahCodeState();
}

class _TambahCodeState extends State<TambahCode> {
  final formKey = GlobalKey<FormState>();

  TextEditingController kode = TextEditingController();
  TextEditingController namaError = TextEditingController();
  TextEditingController deskripsi = TextEditingController();
  TextEditingController idMotor = TextEditingController();
  TextEditingController penyebab = TextEditingController();
  TextEditingController solusi = TextEditingController();
  TextEditingController populer = TextEditingController();

  final logger = Logger();

  @override
  void dispose() {
    kode.dispose();
    namaError.dispose();
    deskripsi.dispose();
    idMotor.dispose();
    penyebab.dispose();
    solusi.dispose();
    populer.dispose();
    super.dispose();
  }

  Future<bool> tambah() async {
    try {
      final respon = await http.post(
        Uri.parse('http://10.230.232.96/api_code/create.php'),
        body: {
          'id_motor': idMotor.text,
          'kode': kode.text,
          'nama_error': namaError.text,
          'deskripsi': deskripsi.text,
          'penyebab': penyebab.text,
          'solusi': solusi.text,
          'populer': populer.text,
        },
      );

      print(respon.body); // DEBUG

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
        title: const Text('Tambah Kode Error'),
        backgroundColor: Colors.orange,
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // ID MOTOR
                TextFormField(
                  controller: idMotor,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'ID Motor',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'ID Motor wajib diisi!' : null,
                ),

                const SizedBox(height: 10),

                // KODE
                TextFormField(
                  controller: kode,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Kode (contoh: 12)',
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

                const SizedBox(height: 10),

                // POPULER
                TextFormField(
                  controller: populer,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Populer (0 / 1)',
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
                      final result = await tambah();

                      if (result) {
                        messagerKey.currentState!.showSnackBar(
                          const SnackBar(
                            content: Text('Kode berhasil ditambah!'),
                          ),
                        );
                      } else {
                        messagerKey.currentState!.showSnackBar(
                          const SnackBar(
                            content: Text('Gagal menambah data!'),
                          ),
                        );
                      }

                      navigatorKey.currentState!.pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) =>
                                const HalamanCode()),
                        (route) => false,
                      );
                    }
                  },
                  child: const Text('Simpan'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}