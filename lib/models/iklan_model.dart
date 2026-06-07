class IklanModel {
  final int? id;
  final String namaUsaha;
  final String lokasi;
  final String deskripsi;
  final String whatsapp;
  final String gambar;
  final String paket;
  final String statusPembayaran;
  final String statusIklan;

  IklanModel({
    this.id,
    required this.namaUsaha,
    required this.lokasi,
    this.deskripsi = '',
    this.whatsapp = '',
    required this.gambar,
    required this.paket,
    this.statusPembayaran = 'Lunas',
    this.statusIklan = 'Aktif',
  });

  factory IklanModel.fromJson(Map<String, dynamic> json) {
    return IklanModel(
      id: json['id'] is int 
          ? json['id'] 
          : (json['id'] is String ? int.tryParse(json['id']) : null),
      namaUsaha: json['nama_usaha']?.toString() ?? '',
      lokasi: json['lokasi']?.toString() ?? '',
      deskripsi: json['deskripsi']?.toString() ?? '',
      whatsapp: json['whatsapp']?.toString() ?? '',
      gambar: json['gambar']?.toString() ?? '',
      paket: json['paket']?.toString() ?? '',
      statusPembayaran: json['status_pembayaran']?.toString() ?? 'Lunas',
      statusIklan: json['status_iklan']?.toString() ?? 'Aktif',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_usaha': namaUsaha,
      'lokasi': lokasi,
      'deskripsi': deskripsi,
      'whatsapp': whatsapp,
      'gambar': gambar,
      'paket': paket,
      'status_pembayaran': statusPembayaran,
      'status_iklan': statusIklan,
    };
  }
}