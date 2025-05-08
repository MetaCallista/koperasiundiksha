import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/user_provider.dart';
import '../providers/balance_provider.dart';
import '../widgets/app_colors.dart';
import 'home_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> _showEditUsernameDialog(BuildContext context, String currentUsername) async {
    final TextEditingController controller = TextEditingController(text: currentUsername);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Ubah Username"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: "Username Baru",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Batal"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text("Simpan"),
              onPressed: () async {
                final newUsername = controller.text.trim();
                if (newUsername.isNotEmpty) {
                  // Update ke provider
                  Provider.of<UserProvider>(context, listen: false).setUsername(newUsername);

                  // Simpan ke SharedPreferences
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('username', newUsername);

                  Navigator.pop(context); // Tutup dialog
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final username = userProvider.username.isNotEmpty ? userProvider.username : 'Putu Meta Callista';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "Profil",
          style: TextStyle(color: AppColors.background),
        ),
        backgroundColor: AppColors.primary,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.background),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.background),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/profile.jpg'),
            ),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  username,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _showEditUsernameDialog(context, username),
                  child: const Icon(Icons.edit, size: 20, color: AppColors.primary),
                ),
              ],
            ),

            const Text(
              "Nasabah Koperasi Undiksha",
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),

            const _ProfileInfoItem(title: "Email", value: "meta.callista@gmail.com"),
            const _ProfileInfoItem(title: "No. HP", value: "0812-3456-7890"),

            Consumer<BalanceProvider>(
              builder: (context, balanceProvider, _) {
                return _ProfileInfoItem(
                  title: "Saldo",
                  value: "Rp. ${balanceProvider.saldo}",
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileInfoItem extends StatelessWidget {
  final String title;
  final String value;

  const _ProfileInfoItem({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
