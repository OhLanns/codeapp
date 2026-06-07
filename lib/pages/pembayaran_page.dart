import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:codeapp/provider/iklan_provider.dart';
import 'dart:io';

class PembayaranPage extends StatefulWidget {
  final String paket;
  final String namaUsaha;
  final String lokasi;
  final File gambar; // Ubah dynamic menjadi File

  const PembayaranPage({
    super.key,
    required this.paket,
    required this.namaUsaha,
    required this.lokasi,
    required this.gambar,
  });

  @override
  State<PembayaranPage> createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pembayaran"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.payment,
                size: 80,
                color: Colors.blue,
              ),
              const SizedBox(height: 20),
              
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text(
                        "Detail Pembayaran",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(),
                      const SizedBox(height: 10),
                      _buildInfoRow("Nama Toko", widget.namaUsaha),
                      const SizedBox(height: 8),
                      _buildInfoRow("Lokasi", widget.lokasi),
                      const SizedBox(height: 8),
                      _buildInfoRow("Paket Iklan", widget.paket),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        "Total Bayar",
                        widget.paket == "7 Hari" ? "Rp 50.000" : 
                        (widget.paket == "30 Hari" ? "Rp 150.000" : "Rp 400.000"),
                        isTotal: true,
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Error message
              if (_errorMessage.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.red, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _prosesPembayaran,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          "Bayar Sukses",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.green : null,
          ),
        ),
      ],
    );
  }

  Future<void> _prosesPembayaran() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Panggil fungsi uploadIklan dari provider
      final iklanProvider = Provider.of<IklanProvider>(context, listen: false);
      
      bool berhasil = await iklanProvider.uploadIklan(
        namaUsaha: widget.namaUsaha,
        lokasi: widget.lokasi,
        paket: widget.paket,
        gambar: widget.gambar,
      );

      if (!mounted) return;

      if (berhasil) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Iklan berhasil dipasang!"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        
        // Kembali ke halaman sebelumnya dengan nilai true
        Navigator.pop(context, true);
      } else {
        setState(() {
          _errorMessage = 'Gagal memasang iklan. Silakan coba lagi.';
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _errorMessage = 'Terjadi kesalahan: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}