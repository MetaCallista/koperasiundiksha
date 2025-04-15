import 'package:flutter/material.dart';

// Import semua halaman
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
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
        // Auth
        '/login': (context) => LoginPage(),

        // Main Pages
        '/home': (context) => HomePage(),
        '/profile': (context) => ProfilePage(),
        '/settings': (context) => SettingPage(),

        // Fitur Keuangan
        '/saldo': (context) => SaldoPage(),
        '/transfer': (context) => TransferPage(),
        '/deposito': (context) => DepositoPage(),
        '/mutasi': (context) => MutasiPage(),
        '/pinjaman': (context) => PinjamanPage(),
        '/pembayaran': (context) => PembayaranPage(),
        '/tariktunai': (context) => TarikTunaiPage(),

        // Fitur Tambahan
        '/scan': (context) => ScanPage(),
      },
    );
  }
}
