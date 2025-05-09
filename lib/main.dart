import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Providers
import 'package:koperasi_undiksha/providers/user_provider.dart';
import 'package:koperasi_undiksha/providers/balance_provider.dart';
import 'package:koperasi_undiksha/providers/deposito_provider.dart';
import 'package:koperasi_undiksha/providers/mutasi_provider.dart';

// Pages
import 'package:koperasi_undiksha/pages/login_page.dart';
import 'package:koperasi_undiksha/pages/register_page.dart';
import 'package:koperasi_undiksha/pages/home_page.dart';
import 'package:koperasi_undiksha/pages/profile_page.dart';
import 'package:koperasi_undiksha/pages/setting_page.dart';
import 'package:koperasi_undiksha/pages/saldo_page.dart';
import 'package:koperasi_undiksha/pages/transfer_page.dart';
import 'package:koperasi_undiksha/pages/deposito_page.dart';
import 'package:koperasi_undiksha/pages/mutasi_page.dart';
import 'package:koperasi_undiksha/pages/pinjaman_page.dart';
import 'package:koperasi_undiksha/pages/pembayaran_page.dart';
import 'package:koperasi_undiksha/pages/tarik_tunai_page.dart';
import 'package:koperasi_undiksha/pages/scan_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => BalanceProvider()),
        ChangeNotifierProvider(create: (_) => DepositoProvider()),
        ChangeNotifierProvider(create: (_) => MutasiProvider()),
      ],
      child: MyApp(isLoggedIn: isLoggedIn),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Koperasi Undiksha',
      initialRoute: isLoggedIn ? '/home' : '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(),
        '/settings': (context) => const SettingPage(),
        '/saldo': (context) => SaldoPage(),
        '/transfer': (context) => TransferPage(),
        '/deposito': (context) => DepositoPage(),
        '/mutasi': (context) => const MutasiPage(),
        '/pinjaman': (context) => const PinjamanPage(),
        '/pembayaran': (context) => const PembayaranPage(),
        '/tariktunai': (context) => TarikTunaiPage(),
        '/scan': (context) => ScanPage(),
      },
    );
  }
}
