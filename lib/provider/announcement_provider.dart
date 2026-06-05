import 'package:flutter/material.dart';

class AnnouncementProvider with ChangeNotifier {
  // Menyimpan daftar pesan pengumuman/code yang masuk
  final List<Map<String, dynamic>> _announcements = [];
  
  // Menandai apakah ada pesan baru yang belum dilihat di halaman Code
  bool _hasNewAnnouncement = false;

  List<Map<String, dynamic>> get announcements => _announcements;
  bool get hasNewAnnouncement => _hasNewAnnouncement;

  // Fungsi untuk menambah pesan baru saat diterima dari socket
  void addAnnouncement(Map<String, dynamic> data) {
    _announcements.insert(0, data); // Memasukkan pesan baru di posisi paling atas (paling baru)
    _hasNewAnnouncement = true;     // Aktifkan indikator titik merah

    // ✅ FITUR BARU: Batasi maksimal hanya 5 pesan. 
    // Jika pesan ke-6 masuk, pesan yang paling lama (paling bawah) otomatis dihapus.
    if (_announcements.length > 5) {
      _announcements.removeLast(); 
    }

    notifyListeners();              // Beritahu semua UI (Home & Code Page) untuk memperbarui tampilan
  }

  // Fungsi untuk menghapus tanda titik merah saat pengguna membuka halaman Code
  void markAsRead() {
    _hasNewAnnouncement = false;
    notifyListeners();
  }

  // Fungsi jika ingin menghapus semua riwayat pesan secara manual
  void clearAnnouncements() {
    _announcements.clear();
    _hasNewAnnouncement = false;
    notifyListeners();
  }
}