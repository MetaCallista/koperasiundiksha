import 'package:flutter/material.dart';
import '../widgets/profile_card.dart';
import '../widgets/custom_menu_button.dart';
import '../widgets/bottom_navbar.dart';
import '../widgets/app_colors.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Koperasi Undiksha",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProfileCard(
              name: "Putu Meta Callista",
              balance: "Rp. 1.200.000",
              imagePath: 'assets/profile.jpg',
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow.withOpacity(0.2),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1.1,
                children: [
                  CustomMenuButton(
                    label: "Saldo",
                    icon: Icons.account_balance_wallet,
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/saldo');
                    },
                  ),
                  CustomMenuButton(
                    label: "Transfer",
                    icon: Icons.send,
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/transfer');
                    },
                  ),
                  CustomMenuButton(
                    label: "Deposito",
                    icon: Icons.savings,
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/deposito');
                    },
                  ),
                  CustomMenuButton(
                    label: "Pembayaran",
                    icon: Icons.payment,
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/pembayaran');
                    },
                  ),
                  CustomMenuButton(
                    label: "Pinjaman",
                    icon: Icons.attach_money,
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/pinjaman');
                    },
                  ),
                  CustomMenuButton(
                    label: "Mutasi",
                    icon: Icons.receipt_long,
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/mutasi');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD), 
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFFBBDEFB), 
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Butuh Bantuan?",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "0878-1234-1024",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.phone, size: 50, color: AppColors.primary),
                    onPressed: () {},
                  ),
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
