import 'package:flutter/material.dart';
import 'package:codeapp/models/iklan_model.dart';
import 'package:codeapp/services/iklan_service.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class IklanProvider extends ChangeNotifier {
  final IklanService _service = IklanService();
  List<IklanModel> _iklanList = [];

  List<IklanModel> get iklanList => _iklanList;

  List<IklanModel> getIklanAktif() {
    return _iklanList.where((iklan) => iklan.statusIklan == 'Aktif').toList();
  }

  Future<void> loadIklan() async {
    try {
      _iklanList = await _service.getIklan();
      notifyListeners();
    } catch (e) {
      print('Error loadIklan: $e');
      _iklanList = [];
      notifyListeners();
    }
  }

  Future<bool> uploadIklan({
    required String namaUsaha,
    required String lokasi,
    required String paket,
    required File gambar,
  }) async {
    try {
      bool success = await _service.uploadIklan(
        namaUsaha: namaUsaha,
        lokasi: lokasi,
        paket: paket,
        gambar: gambar,
      );

      if (success) {
        await loadIklan(); // Refresh data setelah upload
      }

      return success;
    } catch (e) {
      print('Error uploadIklan: $e');
      return false;
    }
  }

  // Method untuk menghapus iklan
  Future<bool> deleteIklan(int id) async {
    try {
      final response = await http.post(
        Uri.parse('${IklanService.baseUrl}/delete_iklan.php'),
        body: {'id': id.toString()},
      );
      
      final result = json.decode(response.body);
      if (result['success'] == true) {
        _iklanList.removeWhere((iklan) => iklan.id == id);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Error deleteIklan: $e');
      return false;
    }
  }

  // Method untuk update iklan
  Future<bool> updateIklan({
    required int id,
    required String namaUsaha,
    required String lokasi,
    required String deskripsi,
    required String whatsapp,
    required String paket,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${IklanService.baseUrl}/update_iklan.php'),
        body: {
          'id': id.toString(),
          'nama_usaha': namaUsaha,
          'lokasi': lokasi,
          'deskripsi': deskripsi,
          'whatsapp': whatsapp,
          'paket': paket,
        },
      );
      
      final result = json.decode(response.body);
      if (result['success'] == true) {
        // Update local list
        final index = _iklanList.indexWhere((iklan) => iklan.id == id);
        if (index != -1) {
          _iklanList[index] = IklanModel(
            id: id,
            namaUsaha: namaUsaha,
            lokasi: lokasi,
            deskripsi: deskripsi,
            whatsapp: whatsapp,
            gambar: _iklanList[index].gambar,
            paket: paket,
            statusPembayaran: _iklanList[index].statusPembayaran,
            statusIklan: _iklanList[index].statusIklan,
          );
          notifyListeners();
        }
        return true;
      }
      return false;
    } catch (e) {
      print('Error updateIklan: $e');
      return false;
    }
  }

  // Method untuk testing (data dummy)
  void tambahIklan(IklanModel iklan) {
    _iklanList.add(iklan);
    notifyListeners();
  }
}