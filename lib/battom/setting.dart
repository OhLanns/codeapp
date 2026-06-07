import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'package:shared_preferences/shared_preferences.dart';
import '/provider/auth_provider.dart';
import 'package:codeapp/provider/iklan_provider.dart';
import 'package:codeapp/models/iklan_model.dart';
import 'package:codeapp/pages/tambah_iklan.dart';
import 'dart:io';

class SettingPage extends StatefulWidget {  
  const SettingPage({super.key});
 
  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  SharedPreferences? prefs;
  String username = '';
  String email = '';
  bool isNotificationEnabled = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    loadUserData();      
    loadNotificationSettings();
    _loadIklanData();
  }

  Future<void> loadUserData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs?.getString('username') ?? 'Belum login';
      email = prefs?.getString('email') ?? 'user@example.com';
    });
  }

  Future<void> loadNotificationSettings() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      isNotificationEnabled = prefs?.getBool('notificationEnabled') ?? true;
    });
  }

  Future<void> saveNotification(bool value) async {
    prefs = await SharedPreferences.getInstance();
    await prefs?.setBool('notificationEnabled', value);
    setState(() {
      isNotificationEnabled = value;
    });
  }

  Future<void> _loadIklanData() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final provider = Provider.of<IklanProvider>(context, listen: false);
      await provider.loadIklan();
      print('Total iklan setelah load: ${provider.iklanList.length}');
    } catch (e) {
      print('Error loading iklan: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> logout() async {
    prefs = await SharedPreferences.getInstance();
    await prefs?.setBool('isLoggedIn', false);
    
    if (mounted) {
      Provider.of<AuthProvider>(context, listen: false).signOut();
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  // Fungsi untuk menghapus iklan
  Future<void> _deleteIklan(int id, String namaUsaha) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi Hapus"),
        content: Text("Apakah Anda yakin ingin menghapus iklan '$namaUsaha'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), 
            child: const Text("Batal")
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
    
    if (confirm != true) return;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    
    try {
      final iklanProvider = Provider.of<IklanProvider>(context, listen: false);
      bool berhasil = await iklanProvider.deleteIklan(id);
      
      if (context.mounted) {
        Navigator.pop(context);
        
        if (berhasil) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Iklan berhasil dihapus'), backgroundColor: Colors.green),
          );
          await _loadIklanData();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal menghapus iklan'), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  // Fungsi untuk edit iklan
  Future<void> _editIklan(IklanModel iklan) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditIklanPage(iklan: iklan),
      ),
    );
    
    if (result == true) {
      await _loadIklanData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Iklan berhasil diupdate'), backgroundColor: Colors.green),
      );
    }
  }

  // Fungsi untuk menampilkan detail iklan
  void _showIklanDetail(IklanModel iklan) {
    print('Menampilkan detail iklan: ${iklan.namaUsaha}');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          iklan.namaUsaha,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gambar
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    'http://10.230.232.96/api_code/upload/${iklan.gambar}',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 200,
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      print('Error loading image: $error');
                      return Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.broken_image, size: 50, color: Colors.grey),
                              SizedBox(height: 8),
                              Text('Gambar tidak ditemukan'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                
                // Lokasi
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 18, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        iklan.lokasi.isNotEmpty ? iklan.lokasi : "Lokasi tidak tersedia",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Deskripsi
                Text(
                  iklan.deskripsi.isNotEmpty ? iklan.deskripsi : "Toko terpercaya dengan pelayanan terbaik",
                  style: const TextStyle(fontSize: 14, height: 1.5),
                ),
                const SizedBox(height: 12),
                
                // WhatsApp
                if (iklan.whatsapp.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.message, color: Colors.green, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            iklan.whatsapp,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                const SizedBox(height: 12),
                
                // Paket Iklan
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.timer, size: 18, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        "Paket: ${iklan.paket}",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Status Iklan
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: iklan.statusIklan == 'Aktif' 
                        ? Colors.green.withOpacity(0.1) 
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        iklan.statusIklan == 'Aktif' ? Icons.check_circle : Icons.cancel,
                        size: 18,
                        color: iklan.statusIklan == 'Aktif' ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Status: ${iklan.statusIklan}",
                        style: TextStyle(
                          fontSize: 14,
                          color: iklan.statusIklan == 'Aktif' ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text("Tutup"),
          ),
        ],
      ),
    );
  }

  // Fungsi logout confirmation
  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi Logout"),
        content: const Text("Apakah Anda yakin ingin logout?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          TextButton(
            onPressed: () { 
              Navigator.pop(context); 
              logout(); 
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final iklanProvider = Provider.of<IklanProvider>(context);
    final allIklan = iklanProvider.iklanList;

    print('BUILD SETTING PAGE - Total iklan: ${allIklan.length}');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengaturan"),
        backgroundColor: authProvider.isDarkMode ? Colors.grey[900] : Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadIklanData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadIklanData,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  // ========== SECTION: PROFIL PENGGUNA ==========
                  Card(
                    margin: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text("PROFIL PENGGUNA", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.person),
                          title: const Text("Username"),
                          subtitle: Text(username),
                        ),
                        ListTile(
                          leading: const Icon(Icons.email),
                          title: const Text("Email"),
                          subtitle: Text(email),
                        ),
                      ],
                    ),
                  ),
            
                  // ========== SECTION: DAFTAR IKLAN SAYA ==========
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text("DAFTAR IKLAN SAYA", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                        const Divider(),
                        
                        // Tombol tambah iklan
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              print('Tombol Pasang Iklan Baru ditekan');
                              try {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const TambahIklanPage(),
                                  ),
                                );
                                print('Hasil dari TambahIklanPage: $result');
                                if (result == true) {
                                  await _loadIklanData();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Iklan berhasil dipasang!'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              } catch (e) {
                                print('Error saat navigasi: $e');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: $e')),
                                );
                              }
                            },
                            icon: const Icon(Icons.add),
                            label: const Text("Pasang Iklan Baru"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 45),
                            ),
                          ),
                        ),
                        
                        // Info jumlah iklan
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'Total iklan: ${allIklan.length}',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                        
                        const SizedBox(height: 10),
                        
                        if (allIklan.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(32),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(Icons.campaign, size: 50, color: Colors.grey),
                                  SizedBox(height: 10),
                                  Text("Belum ada iklan", style: TextStyle(color: Colors.grey)),
                                  SizedBox(height: 5),
                                  Text("Klik tombol di atas untuk pasang iklan", style: TextStyle(fontSize: 12, color: Colors.grey)),
                                ],
                              ),
                            ),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: allIklan.length,
                            itemBuilder: (context, index) {
                              final iklan = allIklan[index];
                              return Dismissible(
                                key: Key(iklan.id.toString()),
                                background: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 20),
                                  child: const Icon(Icons.delete, color: Colors.white),
                                ),
                                direction: DismissDirection.endToStart,
                                onDismissed: (direction) {
                                  _deleteIklan(iklan.id!, iklan.namaUsaha);
                                },
                                child: Card(
                                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  child: InkWell(
                                    onTap: () {
                                      print('Card ditekan: ${iklan.namaUsaha}');
                                      _showIklanDetail(iklan);
                                    },
                                    child: ListTile(
                                      leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          'http://10.230.232.96/api_code/upload/${iklan.gambar}',
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              width: 60,
                                              height: 60,
                                              color: Colors.grey[300],
                                              child: const Icon(Icons.broken_image, size: 30),
                                            );
                                          },
                                        ),
                                      ),
                                      title: Text(
                                        iklan.namaUsaha,
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("📍 ${iklan.lokasi}"),
                                          const SizedBox(height: 4),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: iklan.statusIklan == 'Aktif' 
                                                  ? Colors.green.withOpacity(0.2) 
                                                  : Colors.red.withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              iklan.statusIklan,
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: iklan.statusIklan == 'Aktif' ? Colors.green : Colors.red,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit, color: Colors.blue),
                                            onPressed: () => _editIklan(iklan),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete, color: Colors.red),
                                            onPressed: () => _deleteIklan(iklan.id!, iklan.namaUsaha),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
            
                  // ========== SECTION: PENGATURAN APLIKASI ==========
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text("PENGATURAN APLIKASI", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                        const Divider(),
                        SwitchListTile(
                          title: const Text("Mode Gelap"),
                          subtitle: const Text("Ubah tampilan aplikasi menjadi gelap"),
                          secondary: const Icon(Icons.dark_mode),
                          value: authProvider.isDarkMode,
                          onChanged: (bool value) {
                            authProvider.toggleTheme(value);
                          },
                        ),
                        SwitchListTile(
                          title: const Text("Notifikasi"),
                          subtitle: const Text("Aktifkan atau matikan notifikasi"),
                          secondary: const Icon(Icons.notifications),
                          value: isNotificationEnabled,
                          onChanged: saveNotification,
                        ),
                      ],
                    ),
                  ),
            
                  // ========== Logout ==========
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: _showLogoutConfirmation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text("LOGOUT", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// Halaman Edit Iklan (sama seperti sebelumnya)
class EditIklanPage extends StatefulWidget {
  final IklanModel iklan;
  const EditIklanPage({super.key, required this.iklan});

  @override
  State<EditIklanPage> createState() => _EditIklanPageState();
}

class _EditIklanPageState extends State<EditIklanPage> {
  late TextEditingController _namaController;
  late TextEditingController _lokasiController;
  late TextEditingController _deskripsiController;
  late TextEditingController _whatsappController;
  late String _paket;
  bool _isLoading = false;
  
  final List<String> _paketOptions = ['7 Hari', '30 Hari', '90 Hari'];

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.iklan.namaUsaha);
    _lokasiController = TextEditingController(text: widget.iklan.lokasi);
    _deskripsiController = TextEditingController(text: widget.iklan.deskripsi);
    _whatsappController = TextEditingController(text: widget.iklan.whatsapp);
    _paket = widget.iklan.paket;
  }

  @override
  void dispose() {
    _namaController.dispose();
    _lokasiController.dispose();
    _deskripsiController.dispose();
    _whatsappController.dispose();
    super.dispose();
  }

  Future<void> _updateIklan() async {
    if (_namaController.text.isEmpty || _lokasiController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama dan lokasi harus diisi')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      bool berhasil = await Provider.of<IklanProvider>(context, listen: false).updateIklan(
        id: widget.iklan.id!,
        namaUsaha: _namaController.text,
        lokasi: _lokasiController.text,
        deskripsi: _deskripsiController.text,
        whatsapp: _whatsappController.text,
        paket: _paket,
      );

      setState(() {
        _isLoading = false;
      });

      if (context.mounted) {
        if (berhasil) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Iklan berhasil diupdate'), backgroundColor: Colors.green),
          );
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal mengupdate iklan'), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Iklan'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: _namaController,
              decoration: const InputDecoration(
                labelText: 'Nama Toko',
                prefixIcon: Icon(Icons.store),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _lokasiController,
              decoration: const InputDecoration(
                labelText: 'Lokasi',
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(),
              ),
            ),
            
            const SizedBox(height: 16),
            
            const Text(
              'Durasi Iklan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _paket,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: _paketOptions.map((String paket) {
                return DropdownMenuItem<String>(
                  value: paket,
                  child: Text(paket),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _paket = newValue!;
                });
              },
            ),
            const SizedBox(height: 24),
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Preview Gambar', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        'http://10.230.232.96/api_code/upload/${widget.iklan.gambar}',
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 150,
                            color: Colors.grey[300],
                            child: const Center(child: Text('Gambar tidak ditemukan')),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _updateIklan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Simpan Perubahan', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}