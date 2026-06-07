import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:codeapp/data/motor_data.dart';
import 'package:codeapp/kategori/detail_motor.dart';
import 'package:codeapp/models/motor_model.dart';
import '/provider/auth_provider.dart';

class KawasakiPage extends StatelessWidget {
  const KawasakiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isDark = authProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Kawasaki Motor"),
        backgroundColor: isDark ? Colors.grey[900] : Colors.green,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                  ? [Colors.grey[900]!, Colors.grey[800]!]
                  : [Colors.green.shade50, Colors.white],
            ),
          ),
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: motorKawasaki.length,
            itemBuilder: (context, index) {
              final motor = motorKawasaki[index];
              return _MotorCard(motor: motor, isDark: isDark);
            },
          ),
        ),
      ),
    );
  }
}

class _MotorCard extends StatelessWidget {
  final MotorModel motor;
  final bool isDark;

  const _MotorCard({required this.motor, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailMotorPage(motor: motor),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: isDark 
                  ? Colors.black.withOpacity(0.3) 
                  : Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.asset(
                motor.gambarAsset,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 120,
                    width: double.infinity,
                    color: isDark ? Colors.grey[700] : Colors.green[50],
                    child: Icon(Icons.motorcycle, size: 40, color: isDark ? Colors.grey[400] : Colors.green),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    motor.nama,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    motor.model,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: isDark 
                          ? Colors.green.withOpacity(0.2) 
                          : Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      motor.kodeMotor,
                      style: TextStyle(
                        fontSize: 9,
                        color: isDark ? Colors.green[300] : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.warning, size: 10, color: Colors.orange),
                      const SizedBox(width: 2),
                      Text(
                        "${motor.masalahUmum.length} Masalah",
                        style: const TextStyle(fontSize: 9, color: Colors.orange),
                      ),
                    ],
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