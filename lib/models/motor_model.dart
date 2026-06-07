class MotorModel {
  final String nama;
  final String merek;
  final String model;
  final String tahun;
  final String gambarAsset; // Ganti dari 'gambar' menjadi 'gambarAsset' untuk asset lokal
  final String kodeMotor;
  final List<String> masalahUmum;
  final List<String> solusi;

  MotorModel({
    required this.nama,
    required this.merek,
    required this.model,
    required this.tahun,
    required this.gambarAsset,
    required this.kodeMotor,
    required this.masalahUmum,
    required this.solusi,
  });

  // Factory method untuk membuat MotorModel dari JSON (jika diperlukan untuk API)
  factory MotorModel.fromJson(Map<String, dynamic> json) {
    return MotorModel(
      nama: json['nama'] ?? '',
      merek: json['merek'] ?? '',
      model: json['model'] ?? '',
      tahun: json['tahun'] ?? '',
      gambarAsset: json['gambarAsset'] ?? '',
      kodeMotor: json['kodeMotor'] ?? '',
      masalahUmum: List<String>.from(json['masalahUmum'] ?? []),
      solusi: List<String>.from(json['solusi'] ?? []),
    );
  }

  // Method untuk mengkonversi ke JSON
  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'merek': merek,
      'model': model,
      'tahun': tahun,
      'gambarAsset': gambarAsset,
      'kodeMotor': kodeMotor,
      'masalahUmum': masalahUmum,
      'solusi': solusi,
    };
  }
}