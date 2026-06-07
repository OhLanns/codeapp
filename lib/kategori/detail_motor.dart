import 'package:flutter/material.dart';
import 'package:codeapp/models/motor_model.dart';

class DetailMotorPage extends StatelessWidget {
  final MotorModel motor;

  const DetailMotorPage({super.key, required this.motor});

  Color _getBrandColor() {
    switch (motor.merek) {
      case "Yamaha":
        return Colors.blue;
      case "Honda":
        return Colors.red;
      case "Suzuki":
        return Colors.orange;
      case "Kawasaki":
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final brandColor = _getBrandColor();
    
    return Scaffold(
      appBar: AppBar(
        title: Text(motor.nama),
        backgroundColor: brandColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image dari asset
            Container(
              height: 250,
              width: double.infinity,
              color: Colors.grey[200],
              child: Image.asset(
                motor.gambarAsset,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info Motor
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.qr_code, color: brandColor),
                              const SizedBox(width: 10),
                              Text(
                                "Kode Motor: ${motor.kodeMotor}",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            children: [
                              Icon(Icons.calendar_today, color: brandColor),
                              const SizedBox(width: 10),
                              Text(
                                "Tahun Produksi: ${motor.tahun}",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            children: [
                              Icon(Icons.business, color: brandColor),
                              const SizedBox(width: 10),
                              Text(
                                "Merek: ${motor.merek}",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Masalah Umum
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.warning, color: Colors.orange),
                              const SizedBox(width: 10),
                              const Text(
                                "Masalah yang Sering Dialami",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ...motor.masalahUmum.map((masalah) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("• ", style: TextStyle(fontSize: 16)),
                                Expanded(child: Text(masalah)),
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Solusi
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.handyman, color: Colors.green),
                              const SizedBox(width: 10),
                              const Text(
                                "Solusi Perbaikan",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ...motor.solusi.map((solusi) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("✔ ", style: TextStyle(fontSize: 16, color: Colors.green)),
                                Expanded(child: Text(solusi)),
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Tombol Kembali
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text("Kembali ke Daftar Motor"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brandColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}