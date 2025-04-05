import 'package:flutter/material.dart';
import 'home_page.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/app_colors.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 15),
            color: AppColors.primary,
            child: const Center(
              child: Text(
                "Koperasi Undiksha",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.background,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
          Image.asset('assets/logo.png', width: 140),
          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.primary, width: 2),
              ),
              child: Column(
                children: [
                  CustomTextField(label: "Username", controller: usernameController),
                  const SizedBox(height: 10),
                  CustomTextField(label: "Password", controller: passwordController, isPassword: true),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      if (usernameController.text == "2315091004") {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Login Gagal"),
                              content: const Text("Username salah! Silakan coba lagi."),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 60),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.background,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Daftar Mbanking",
                          style: TextStyle(color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Lupa password?",
                          style: TextStyle(color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const Spacer(),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: AppColors.border,
            child: const Center(
              child: Text(
                "copyright @2022 by Undiksha",
                style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
