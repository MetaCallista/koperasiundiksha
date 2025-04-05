import 'package:flutter/material.dart';
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
            onTap: () {},
          ),
          _SettingItem(
            icon: Icons.notifications,
            title: "Notifikasi",
            onTap: () {},
          ),
          _SettingItem(
            icon: Icons.color_lens,
            title: "Tema Aplikasi",
            onTap: () {},
          ),
          const Divider(color: AppColors.border),
          _SettingItem(
            icon: Icons.logout,
            title: "Keluar",
            onTap: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}

// Custom Widget SettingItem (Dijadikan Private _SettingItem)
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
