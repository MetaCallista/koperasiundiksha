import 'package:flutter/material.dart';
import 'home_page.dart';
import '../widgets/app_colors.dart'; 

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
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
          children: const [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/profile.jpg'),
            ),
            SizedBox(height: 10),
            Text(
              "Putu Meta Callista",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              "Nasabah Koperasi Undiksha",
              style: TextStyle(color: AppColors.textSecondary),
            ),
            SizedBox(height: 20),
            _ProfileInfoItem(title: "Email", value: "meta.callista@gmail.com"),
            _ProfileInfoItem(title: "No. HP", value: "0812-3456-7890"),
            _ProfileInfoItem(title: "Saldo", value: "Rp. 1.200.000"),
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
