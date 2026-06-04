import 'package:flutter/material.dart';
import 'package:codeapp/code_error/detail_kode.dart';

class HalamanCode extends StatefulWidget {
  const HalamanCode({super.key});

  @override
  State<HalamanCode> createState() => _HalamanCodeState();
}

class _HalamanCodeState extends State<HalamanCode> {
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
        title: const Text("Data Kode Error"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: _listData.length,
        itemBuilder: (context, index) {
          final data = _listData[index];

          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: CircleAvatar(
                child: Text(
                  data["kode"],
                ),
              ),
              title: Text(
                data["nama_error"],
              ),
              subtitle: Text(
                "Kode Error : ${data["kode"]}",
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DetailCode(mapData: data),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}