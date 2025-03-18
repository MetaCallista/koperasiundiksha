import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  CustomButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade900, 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), 
        ),
        padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
        elevation: 5, 
        shadowColor: Colors.black45, 
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold, 
          color: Colors.white, 
        ),
      ),
    );
  }
}
