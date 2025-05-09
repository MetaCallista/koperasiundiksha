import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/balance_provider.dart';
import '../widgets/profile_card.dart';
import '../widgets/custom_menu_button.dart';
import '../widgets/bottom_navbar.dart';
import '../widgets/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

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

  Future<void> _logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Konfirmasi Logout'),
            content: const Text('Apakah Anda yakin ingin keluar?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      try {
        await Provider.of<UserProvider>(context, listen: false).logout();
        if (mounted) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Gagal logout: $e')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<UserProvider>(context);
    final balanceProvider = Provider.of<BalanceProvider>(context);

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
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Card with user data
            Consumer<UserProvider>(
              builder: (context, userProvider, _) {
                return ProfileCard(
                  name:
                      userProvider
                          .fullName, // Always use the name from provider
                  balance: 'Rp. ${balanceProvider.saldo}',
                  imagePath: 'assets/profile.jpg',
                );
              },
            ),
            const SizedBox(height: 10),

            // Main Menu
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
                      _buildMenu(
                        "Saldo",
                        Icons.account_balance_wallet,
                        '/saldo',
                      ),
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

            // Help Info
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
                    icon: const Icon(
                      Icons.phone,
                      size: 50,
                      color: AppColors.primary,
                    ),
                    onPressed: () {
                      // Add action if needed
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
