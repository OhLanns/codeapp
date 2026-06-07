import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:codeapp/provider/iklan_provider.dart';
import 'package:http/http.dart' as http; // Tambahkan ini untuk test koneksi

class TambahIklanPage extends StatefulWidget {
  const TambahIklanPage({super.key});

  @override
  State<TambahIklanPage> createState() => _TambahIklanPageState();
}

class _TambahIklanPageState extends State<TambahIklanPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _lokasiController = TextEditingController();

  File? _selectedImage;
  String _paket = '7 Hari';
  bool _isLoading = false;
  String _errorMessage = '';

  final List<String> _paketOptions = ['7 Hari', '30 Hari', '90 Hari'];

  Future<void> _pilihGambar() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
        _errorMessage = '';
      });
      
      final sizeInBytes = await _selectedImage!.length();
      final sizeInKB = sizeInBytes / 1024;
      final sizeInMB = sizeInKB / 1024;
      
      print('Ukuran gambar: ${sizeInKB.toStringAsFixed(2)} KB (${sizeInMB.toStringAsFixed(2)} MB)');
      
      if (sizeInMB > 2) {
        setState(() {
          _errorMessage = 'Ukuran gambar terlalu besar (max 2MB)';
        });
      }
    }
  }

  Future<void> _lanjutPembayaran() async {
    if (_formKey.currentState!.validate() && _selectedImage != null) {
      final sizeInBytes = await _selectedImage!.length();
      final sizeInMB = (sizeInBytes / 1024 / 1024);
      
      if (sizeInMB > 2) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ukuran gambar terlalu besar! Maksimal 2MB')),
        );
        return;
      }
      
      // Set loading state
      setState(() {
        _isLoading = true;
      });
      
      try {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PembayaranPage(
              namaUsaha: _namaController.text,
              lokasi: _lokasiController.text,
              paket: _paket,
              gambar: _selectedImage!,
            ),
          ),
        );
        
        setState(() {
          _isLoading = false;
        });
        
        if (result == true && mounted) {
          Navigator.pop(context, true);
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan upload gambar terlebih dahulu')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pasang Iklan'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Toko',
                  prefixIcon: Icon(Icons.store),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama toko harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _lokasiController,
                decoration: const InputDecoration(
                  labelText: 'Lokasi',
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lokasi harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              const Text(
                'Pilih Durasi Iklan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _paket,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                items: _paketOptions.map((String paket) {
                  return DropdownMenuItem<String>(
                    value: paket,
                    child: Text(paket),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _paket = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),

              const Text(
                'Upload Gambar',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _pilihGambar,
                icon: const Icon(Icons.image),
                label: const Text('Pilih Gambar (Max 2MB)'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 45),
                ),
              ),
              const SizedBox(height: 8),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              if (_selectedImage != null)
                Column(
                  children: [
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        _selectedImage!,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text(
                      'Ukuran: ${(_selectedImage!.lengthSync() / 1024).toStringAsFixed(2)} KB',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _lanjutPembayaran,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Lanjut Pembayaran',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Halaman Pembayaran
class PembayaranPage extends StatefulWidget {
  final String namaUsaha;
  final String lokasi;
  final String paket;
  final File gambar;

  const PembayaranPage({
    super.key,
    required this.namaUsaha,
    required this.lokasi,
    required this.paket,
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
        title: const Text('Pembayaran'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Detail Iklan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    _buildDetailRow('Nama Toko', widget.namaUsaha),
                    const SizedBox(height: 8),
                    _buildDetailRow('Lokasi', widget.lokasi),
                    const SizedBox(height: 8),
                    _buildDetailRow('Durasi', widget.paket),
                    const SizedBox(height: 8),
                    _buildDetailRow(
                      'Biaya',
                      widget.paket == '7 Hari' ? 'Rp 50.000' : (widget.paket == '30 Hari' ? 'Rp 150.000' : 'Rp 400.000'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Preview Gambar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        widget.gambar,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _prosesPembayaran,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
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
                        'Bayar Sukses',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
          ),
        ),
        Expanded(
          child: Text(value),
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
      print('=== MEMULAI PROSES UPLOAD ===');
      print('Nama Usaha: ${widget.namaUsaha}');
      print('Lokasi: ${widget.lokasi}');
      print('Paket: ${widget.paket}');
      print('Path Gambar: ${widget.gambar.path}');
      
      // Upload iklan ke server
      final iklanProvider = Provider.of<IklanProvider>(context, listen: false);
      
      bool berhasil = await iklanProvider.uploadIklan(
        namaUsaha: widget.namaUsaha,
        lokasi: widget.lokasi,
        paket: widget.paket,
        gambar: widget.gambar,
      );

      print('Hasil upload: $berhasil');

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      if (berhasil) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Iklan berhasil dipasang!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        
        // Kembali ke halaman tambah iklan dengan nilai true
        Navigator.pop(context, true);
      } else {
        setState(() {
          _errorMessage = 'Gagal memasang iklan. Silakan cek koneksi internet dan coba lagi.';
        });
      }
    } catch (e) {
      print('Error di _prosesPembayaran: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Terjadi kesalahan: $e';
      });
    }
  }
}