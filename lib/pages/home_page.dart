import 'package:flutter/material.dart';
import '../widgets/profile_card.dart';
import '../widgets/custom_menu_button.dart';
import '../widgets/bottom_navbar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1; // Indeks halaman aktif

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Koperasi Undiksha",
          style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade900,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              // Mengarahkan ke halaman login
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileCard(
              name: "Putu Meta Callista",
              balance: "Rp. 1.200.000",
              imagePath: 'assets/profile.jpg',
            ),
            SizedBox(height: 10),

            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: GridView.count(
                shrinkWrap: true, 
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1.1, 
                children: [
                  CustomMenuButton(label: "Saldo", icon: Icons.account_balance_wallet, onPressed: () {}),
                  CustomMenuButton(label: "Transfer", icon: Icons.send, onPressed: () {}),
                  CustomMenuButton(label: "Deposito", icon: Icons.savings, onPressed: () {}),
                  CustomMenuButton(label: "Pembayaran", icon: Icons.payment, onPressed: () {}),
                  CustomMenuButton(label: "Pinjaman", icon: Icons.attach_money, onPressed: () {}),
                  CustomMenuButton(label: "Mutasi", icon: Icons.receipt_long, onPressed: () {}),
                ],
              ),
            ),

            SizedBox(height: 12),

            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade100, width: 1),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Butuh Bantuan?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 2),
                        Text("0878-1234-1024", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  IconButton(icon: Icon(Icons.phone, size: 50, color: Colors.blue.shade900), onPressed: () {}),
                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onNavItemTapped,
      ),
    );
  }
}
