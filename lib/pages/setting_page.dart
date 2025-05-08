import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/user_provider.dart';
import '../widgets/app_colors.dart';
import 'home_page.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "Pengaturan",
          style: TextStyle(color: AppColors.background),
        ),
        backgroundColor: AppColors.primary,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.background),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => HomePage()),
            );
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SettingItem(
            icon: Icons.lock,
            title: "Ubah Kata Sandi",
            onTap: () {
              _showChangePasswordDialog(context);
            },
          ),
          _SettingItem(
            icon: Icons.notifications,
            title: "Notifikasi",
            onTap: () {
              _showNotificationSwitchDialog(context);
            },
          ),
          _SettingItem(
            icon: Icons.color_lens,
            title: "Tema Aplikasi",
            onTap: () {
              _showThemeDialog(context);
            },
          ),
          const Divider(color: AppColors.border),
          _SettingItem(
            icon: Icons.logout,
            title: "Keluar",
            onTap: () async {
              // Hapus data login dari SharedPreferences
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('isLoggedIn');
              await prefs.remove('username');

              // Bersihkan data dari provider
              Provider.of<UserProvider>(context, listen: false).clearUser();

              // Navigasi ke login page
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }

  // Dialog untuk Ubah Kata Sandi
  void _showChangePasswordDialog(BuildContext context) {
    TextEditingController _oldPasswordController = TextEditingController();
    TextEditingController _newPasswordController = TextEditingController();
    TextEditingController _confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Ubah Kata Sandi"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _oldPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Kata Sandi Lama",
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Kata Sandi Baru",
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Konfirmasi Kata Sandi Baru",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                String newPassword = _newPasswordController.text;
                String confirmPassword = _confirmPasswordController.text;

                if (newPassword == confirmPassword) {
                  // Lakukan penyimpanan kata sandi baru
                  Navigator.of(context).pop();
                } else {
                  // Tampilkan error jika konfirmasi kata sandi tidak sama
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Error"),
                        content: const Text("Kata sandi baru dan konfirmasi tidak cocok."),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Tutup"),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  // Dialog untuk Notifikasi
  void _showNotificationSwitchDialog(BuildContext context) {
    bool isNotificationEnabled = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Notifikasi"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SwitchListTile(
                title: const Text("Aktifkan Notifikasi"),
                value: isNotificationEnabled,
                activeColor: AppColors.primary, // Mengubah warna switch saat aktif
                onChanged: (bool value) {
                  setState(() {
                    isNotificationEnabled = value;
                  });
                },
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Tutup"),
            ),
          ],
        );
      },
    );
  }

  // Dialog untuk Tema Aplikasi
  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Pilih Tema"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("Tema Terang"),
                onTap: () {
                  // Update tema aplikasi
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text("Tema Gelap"),
                onTap: () {
                  // Update tema aplikasi
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

// Custom Widget SettingItem
class _SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SettingItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        title,
        style: const TextStyle(color: AppColors.textPrimary),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
      onTap: onTap,
    );
  }
}
