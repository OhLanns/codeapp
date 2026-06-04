import 'dart:convert';
import 'package:codeapp/code_error/detail_kode.dart';
import 'package:codeapp/battom/code.dart';
import 'package:codeapp/code_error/tambah_kode.dart';
import 'package:codeapp/code_error/ubah_kode.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class HalamanCode extends StatefulWidget {
  const HalamanCode({super.key});

  @override
  State<HalamanCode> createState() => _HalamanCodeState();
}

class _HalamanCodeState extends State<HalamanCode> {
  List _listData = [];
  bool _loading = true;
  final logger = Logger();

  final String baseUrl = 'http://10.230.232.96/api_code/';

  Future _getData() async {
    setState(() => _loading = true);

    try {
      final response = await http.get(
        Uri.parse('${baseUrl}read.php'),
      );

   // DEBUG

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          _listData = data ?? [];
          _loading = false;
        });
      }
    } catch (e) {
      logger.e("Error: $e");
      setState(() => _loading = false);
    }
  }

  Future<bool> _hapusData(String id) async {
    try {
      final respon = await http.post(
        Uri.parse('${baseUrl}delete.php'),
        body: {"id_kode": id},
      );

   

      if (respon.statusCode == 200) {
        final data = jsonDecode(respon.body);
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      logger.e("Error: $e");
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _listData.isEmpty
              ? const Center(child: Text("Data kosong"))
              : RefreshIndicator(
                  onRefresh: _getData,
                  child: ListView.builder(
                    itemCount: _listData.length,
                    itemBuilder: (context, index) {
                      var data = _listData[index];

                      return Card(
                        child: InkWell(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailCode(mapData: data),
                              ),
                            );
                            _getData(); // refresh setelah balik
                          },
                          child: ListTile(
                            title:
                                Text("Kode: ${data['kode'] ?? '-'}"),
                            subtitle: Text(
                                data['nama_error'] ?? 'Tidak ada'),
                            leading: CircleAvatar(
                              child: Text(
                                  data['kode']?.toString() ?? '?'),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // EDIT
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            UbahCode(
                                                mapData: data),
                                      ),
                                    );
                                    _getData(); // refresh
                                  },
                                ),

                                // DELETE
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: const Text(
                                              "Yakin ingin menghapus kode ini?"),
                                          actions: [
                                            ElevatedButton(
                                              onPressed: () async {
                                                Navigator.pop(
                                                    context);

                                                final result =
                                                    await _hapusData(
                                                        data[
                                                            'id_kode']);

                                                if (result) {
                                                  messagerKey
                                                      .currentState!
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          "Data berhasil dihapus"),
                                                    ),
                                                  );
                                                  _getData();
                                                } else {
                                                  messagerKey
                                                      .currentState!
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          "Gagal menghapus data"),
                                                    ),
                                                  );
                                                }
                                              },
                                              style:
                                                  ElevatedButton
                                                      .styleFrom(
                                                backgroundColor:
                                                    Colors.red,
                                              ),
                                              child:
                                                  const Text("Hapus"),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(
                                                    context);
                                              },
                                              child:
                                                  const Text("Batal"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

      // tombol tambah
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const TambahCode()),
          );
          _getData(); // refresh setelah tambah
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}