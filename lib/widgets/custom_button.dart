import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  CustomButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade900, // Warna biru tua sesuai desain
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Lebih membulat seperti di gambar
        ),
        padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
        elevation: 5, // Efek bayangan agar lebih tegas
        shadowColor: Colors.black45, // Warna bayangan untuk efek depth
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold, // Bold agar lebih jelas
          color: Colors.white, // Warna teks putih
        ),
      ),
    );
  }
}
