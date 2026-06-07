import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:codeapp/models/iklan_model.dart';

class IklanService {
  static const String baseUrl = 'http://10.230.232.96/api_code'; // Ganti dengan URL server Anda

  Future<List<IklanModel>> getIklan() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_iklan.php'),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<IklanModel> iklanList = [];
        
        for (var json in data) {
          iklanList.add(IklanModel.fromJson(json));
        }
        
        return iklanList;
      } else {
        throw Exception('Gagal mengambil data iklan: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getIklan: $e');
      return [];
    }
  }

  Future<bool> uploadIklan({
    required String namaUsaha,
    required String lokasi,
    required String paket,
    required File gambar,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/tambah_iklan.php'),
      );

      request.fields['nama_usaha'] = namaUsaha;
      request.fields['lokasi'] = lokasi;
      request.fields['paket'] = paket;

      request.files.add(
        await http.MultipartFile.fromPath(
          'gambar',
          gambar.path,
        ),
      );

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var result = json.decode(responseBody);

      return result['success'] == true;
    } catch (e) {
      print('Error uploadIklan: $e');
      return false;
    }
  }
}