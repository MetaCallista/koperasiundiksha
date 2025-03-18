import 'package:flutter/material.dart';
import 'home_page.dart';
import '../widgets/custom_textfield.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
        
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 15),
            color: Colors.blue.shade900,
            child: Center(
              child: Text(
                "Koperasi Undiksha",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          
        
          SizedBox(height: 20),
          Image.asset('assets/logo.png', width: 140), 
          SizedBox(height: 20),

         
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue.shade900, width: 2),
              ),
              child: Column(
                children: [
                  CustomTextField(label: "Username", controller: usernameController),
                  SizedBox(height: 10),
                  CustomTextField(label: "Password", controller: passwordController, isPassword: true),
                  SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      // Validasi login
                      if (usernameController.text == "2315091004") {
                        // Kondisi jika benar, maka masuk ke halaman homepage
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      } else {
                        // Jika salah, menampilkan pesan peringatan
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Login Gagal"),
                              content: Text("Username salah! Silakan coba lagi."),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade900,
                      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 60),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: Text("Login", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),

                  // Link "Daftar Mbanking" dan "Lupa Password?" dimasukkan ke dalam Card
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text("Daftar Mbanking", style: TextStyle(color: Colors.blue.shade900, fontSize: 14, fontWeight: FontWeight.bold)),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text("Lupa password?", style: TextStyle(color: Colors.blue.shade900, fontSize: 14, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Spacer(),

          // Footer dengan copyright
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 10),
            color: Colors.grey.shade300,
            child: Center(
              child: Text(
                "copyright @2022 by Undiksha",
                style: TextStyle(color: Colors.black87, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
