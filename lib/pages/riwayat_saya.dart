import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RiwayatSayaPage extends StatefulWidget {
  const RiwayatSayaPage({super.key});

  @override
  State<RiwayatSayaPage> createState() => _RiwayatSayaPageState();
}

class _RiwayatSayaPageState extends State<RiwayatSayaPage> {
  List<String> _myMessages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMyMessages();
  }

  // 📁 Mengambil data pesan dari memori internal HP
  Future<void> _loadMyMessages() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _myMessages = prefs.getStringList('my_local_announcements') ?? [];
      _isLoading = false;
    });
  }

  // 🗑️ Fungsi jika Anda ingin menghapus semua riwayat kiriman Anda
  Future<void> _clearRiwayat() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('my_local_announcements');
    setState(() {
      _myMessages.clear();
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Riwayat kiriman Anda berhasil dihapus!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Kiriman Saya"),
        centerTitle: true,
        actions: [
          if (_myMessages.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_forever, color: Colors.red),
              onPressed: _clearRiwayat,
              tooltip: "Kosongkan Riwayat",
            )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _myMessages.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history_toggle_off, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 12),
                      Text(
                        'Anda belum pernah menyiarkan pesan apa pun.',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _myMessages.length,
                  itemBuilder: (context, index) {
                    // Mendecode data JSON string kembali menjadi Map
                    final data = jsonDecode(_myMessages[index]);
                    final pesan = data['message'] ?? '';
                    final waktu = data['timestamp'] != null
                        ? DateTime.parse(data['timestamp']).toLocal().toString().substring(11, 16)
                        : '--:--';

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Icon(Icons.outbound, color: Colors.white),
                        ),
                        title: Text(
                          pesan,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Text(
                            "Dikirim pada pukul $waktu WIB",
                            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}