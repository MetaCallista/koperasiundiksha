import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Providers
import 'providers/user_provider.dart';
import 'providers/balance_provider.dart'; // Harus tetap diimpor
import 'providers/deposito_provider.dart'; // Tambahkan ini
import 'providers/mutasi_provider.dart';

// Pages
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/saldo_page.dart';
import 'pages/transfer_page.dart';
import 'pages/deposito_page.dart';
import 'pages/mutasi_page.dart';
import 'pages/pembayaran_page.dart';
import 'pages/pinjaman_page.dart';
import 'pages/tarik_tunai_page.dart';
import 'pages/scan_page.dart';
import 'pages/setting_page.dart';
import 'pages/profile_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => BalanceProvider()), // Wajib disediakan
        ChangeNotifierProvider(create: (_) => DepositoProvider()), // Tambahkan ini
        ChangeNotifierProvider(create: (_) => MutasiProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Koperasi Undiksha',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/profile': (context) => ProfilePage(),
        '/settings': (context) => SettingPage(),
        '/saldo': (context) => SaldoPage(),
        '/transfer': (context) => TransferPage(),
        '/deposito': (context) => DepositoPage(),
        '/mutasi': (context) => MutasiPage(),
        '/pinjaman': (context) => PinjamanPage(),
        '/pembayaran': (context) => PembayaranPage(),
        '/tariktunai': (context) => TarikTunaiPage(),
        '/scan': (context) => ScanPage(),
      },
    );
  }
}
