import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final Function(int) onTap;
  final int selectedIndex;

  const BottomNavBar({Key? key, required this.onTap, required this.selectedIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5, spreadRadius: 2)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.settings, "Setting", 0, context, '/settings'),
          _buildQRISButton(context),
          _buildNavItem(Icons.person, "Profile", 1, context, '/profile'),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, BuildContext context, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 30, color: Colors.blue),
          Text(label, style: TextStyle(color: Colors.black)),
        ],
      ),
    );
  }

  Widget _buildQRISButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (ModalRoute.of(context)?.settings.name != '/scan') {
          Navigator.pushNamed(context, '/scan');
        }
      },
      child: Container(
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue[900]),
        padding: EdgeInsets.all(15),
        child: Icon(Icons.qr_code, size: 30, color: Colors.white),
      ),
    );
  }
}
