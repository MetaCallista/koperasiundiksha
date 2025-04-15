import 'package:flutter/material.dart';
import 'package:koperasi_undiksha/balance_state.dart';
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

  Widget _buildMenu(String label, IconData icon, String route) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: CustomMenuButton(
          label: label,
          icon: icon,
          onPressed: () {
            Navigator.pushReplacementNamed(context, route);
          },
        ),
      ),
    );
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
            // Kartu profil dan saldo dinamis
            ValueListenableBuilder<int>(
              valueListenable: BalanceState.saldo,
              builder: (context, saldo, _) {
                return ProfileCard(
                  name: "Putu Meta Callista",
                  balance: 'Rp. $saldo',
                  imagePath: 'assets/profile.jpg',
                );
              },
            ),
            const SizedBox(height: 10),

            // Menu utama
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
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildMenu("Saldo", Icons.account_balance_wallet, '/saldo'),
                      _buildMenu("Transfer", Icons.send, '/transfer'),
                      _buildMenu("Deposito", Icons.savings, '/deposito'),
                      _buildMenu("Mutasi", Icons.receipt_long, '/mutasi'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildMenu("Pinjaman", Icons.attach_money, '/pinjaman'),
                      _buildMenu("Pembayaran", Icons.payment, '/pembayaran'),
                      _buildMenu("Tarik Tunai", Icons.money, '/tariktunai'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Info bantuan
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFBBDEFB), width: 1),
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
                    onPressed: () {
                      // Aksi saat ditekan bisa ditambahkan di sini
                    },
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
