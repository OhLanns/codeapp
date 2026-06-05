import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:codeapp/code_error/detail_kode.dart';
import 'package:codeapp/provider/announcement_provider.dart'; // ✅ Pastikan path package-nya absolut & benar

class HalamanPage extends StatefulWidget {
  const HalamanPage({super.key});

  @override
  State<HalamanPage> createState() => _HalamanPageState();
}

class _HalamanPageState extends State<HalamanPage> {
  // Data statis 20 kode error milik Anda
  final List<Map<String, dynamic>> _listData = [
    {
      "id_kode": "1",
      "kode": "12",
      "nama_error": "CKP Sensor",
      "deskripsi": "Sensor posisi crankshaft bermasalah",
      "penyebab": "Sensor rusak atau kabel putus",
      "solusi": "Periksa kabel dan ganti sensor"
    },
    {
      "id_kode": "2",
      "kode": "13",
      "nama_error": "Intake Air Pressure Sensor",
      "deskripsi": "Sensor tekanan udara masuk bermasalah",
      "penyebab": "Sensor rusak",
      "solusi": "Ganti sensor"
    },
    {
      "id_kode": "3",
      "kode": "21",
      "nama_error": "ECT Sensor",
      "deskripsi": "Sensor suhu mesin bermasalah",
      "penyebab": "Sensor kotor",
      "solusi": "Bersihkan atau ganti sensor"
    },
    {
      "id_kode": "4",
      "kode": "22",
      "nama_error": "Intake Air Temperature Sensor",
      "deskripsi": "Sensor suhu udara masuk bermasalah",
      "penyebab": "Kabel putus",
      "solusi": "Periksa kabel sensor"
    },
    {
      "id_kode": "5",
      "kode": "23",
      "nama_error": "Lean Angle Sensor",
      "deskripsi": "Sensor kemiringan aktif",
      "penyebab": "Motor jatuh",
      "solusi": "Reset sensor"
    },
    {
      "id_kode": "6",
      "kode": "29",
      "nama_error": "ISCV",
      "deskripsi": "Idle Speed Control Valve bermasalah",
      "penyebab": "Katup macet",
      "solusi": "Bersihkan ISCV"
    },
    {
      "id_kode": "7",
      "kode": "33",
      "nama_error": "O2 Sensor",
      "deskripsi": "Sensor oksigen tidak normal",
      "penyebab": "Sensor rusak",
      "solusi": "Ganti sensor"
    },
    {
      "id_kode": "8",
      "kode": "39",
      "nama_error": "Injector",
      "deskripsi": "Injector tidak bekerja",
      "penyebab": "Injector tersumbat",
      "solusi": "Bersihkan injector"
    },
    {
      "id_kode": "9",
      "kode": "41",
      "nama_error": "Lean Angle Sensor",
      "deskripsi": "Sensor kemiringan motor error",
      "penyebab": "Sensor rusak",
      "solusi": "Ganti sensor"
    },
    {
      "id_kode": "10",
      "kode": "42",
      "nama_error": "Vehicle Speed Sensor",
      "deskripsi": "Sensor kecepatan tidak terdeteksi",
      "penyebab": "Sensor kotor",
      "solusi": "Bersihkan sensor"
    },
    {
      "id_kode": "11",
      "kode": "46",
      "nama_error": "Charging System",
      "deskripsi": "Sistem pengisian bermasalah",
      "penyebab": "Spul atau kiprok rusak",
      "solusi": "Periksa sistem pengisian"
    },
    {
      "id_kode": "12",
      "kode": "52",
      "nama_error": "Injector",
      "deskripsi": "Injector tidak bekerja normal",
      "penyebab": "Injector mampet",
      "solusi": "Bersihkan injector"
    },
    {
      "id_kode": "13",
      "kode": "54",
      "nama_error": "Bank Angle Sensor",
      "deskripsi": "Sensor kemiringan aktif",
      "penyebab": "Motor terjatuh",
      "solusi": "Reset sensor"
    },
    {
      "id_kode": "14",
      "kode": "C14",
      "nama_error": "Throttle Position Sensor",
      "deskripsi": "TPS tidak akurat",
      "penyebab": "Sensor aus",
      "solusi": "Kalibrasi atau ganti TPS"
    },
    {
      "id_kode": "15",
      "kode": "C21",
      "nama_error": "Intake Air Temperature",
      "deskripsi": "Sensor suhu udara bermasalah",
      "penyebab": "Sensor rusak",
      "solusi": "Ganti sensor"
    },
    {
      "id_kode": "16",
      "kode": "C24",
      "nama_error": "Ignition Coil",
      "deskripsi": "Koil pengapian bermasalah",
      "penyebab": "Koil lemah",
      "solusi": "Ganti koil"
    },
    {
      "id_kode": "17",
      "kode": "C28",
      "nama_error": "Secondary Throttle Valve",
      "deskripsi": "Katup throttle sekunder error",
      "penyebab": "Motor servo rusak",
      "solusi": "Periksa servo"
    },
    {
      "id_kode": "18",
      "kode": "C41",
      "nama_error": "Fuel Pump",
      "deskripsi": "Pompa bahan bakar bermasalah",
      "penyebab": "Fuel pump lemah",
      "solusi": "Ganti fuel pump"
    },
    {
      "id_kode": "19",
      "kode": "C42",
      "nama_error": "Ignition Switch",
      "deskripsi": "Kunci kontak tidak terbaca",
      "penyebab": "Switch rusak",
      "solusi": "Periksa switch"
    },
    {
      "id_kode": "20",
      "kode": "C46",
      "nama_error": "Exhaust Valve Actuator",
      "deskripsi": "Katup knalpot elektronik error",
      "penyebab": "Motor actuator rusak",
      "solusi": "Ganti actuator"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pusat Kode & Pengumuman"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // KOTAK ATAS: Menggunakan Consumer untuk memantau state realtime
          Consumer<AnnouncementProvider>(
            builder: (context, provider, child) {
              final listPesan = provider.announcements;

              if (listPesan.isEmpty) {
                return const SizedBox.shrink(); 
              }

              return Container(
                constraints: const BoxConstraints(maxHeight: 180), 
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber, width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.campaign, color: Colors.orange),
                            SizedBox(width: 6),
                            Text(
                              "Pertanyaan Code Terbaru (Maks 5)",
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () => provider.clearAnnouncements(),
                          child: const Text("Hapus", style: TextStyle(color: Colors.red, fontSize: 12)),
                        )
                      ],
                    ),
                    const Divider(height: 4, color: Colors.amber),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: listPesan.length,
                        itemBuilder: (context, idx) {
                          final msgData = listPesan[idx];
                          final pengirim = msgData['senderName'] ?? 'Anonim';
                          final isiPesan = msgData['message'] ?? '';

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "[$pengirim]: ",
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                Expanded(
                                  child: Text(
                                    isiPesan,
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Label Pembatas List
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 8.0, bottom: 4.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Daftar Panduan Kode Error Motor",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
              ),
            ),
          ),

          // BAGIAN BAWAH: List Builder Data Statis
          Expanded(
            child: ListView.builder(
              itemCount: _listData.length,
              itemBuilder: (context, index) {
                final data = _listData[index];

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.withOpacity(0.1),
                      child: Text(
                        data["kode"],
                        style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      data["nama_error"],
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      "Deskripsi: ${data["deskripsi"]}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailCode(mapData: data),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}