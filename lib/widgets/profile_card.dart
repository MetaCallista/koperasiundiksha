import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final String name;
  final String balance;
  final String imagePath;

  const ProfileCard({
    required this.name,
    required this.balance,
    required this.imagePath,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300.withOpacity(0.6),
            blurRadius: 4,
            offset: Offset(1, 2),
          ),
        ],
      ),
      child: Row(
        children: [
         
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(imagePath, width: 95, height: 95, fit: BoxFit.cover),
          ),
          SizedBox(width: 10),

         
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoCard("Nasabah", name),
                SizedBox(height: 4), // Jarak antar kolom diperkecil
                _infoCard("Total Saldo Anda", balance, isBalance: true),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _infoCard(String title, String value, {bool isBalance = false}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13, 
              fontWeight: FontWeight.bold,
              color: isBalance ? Colors.blue.shade700 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
