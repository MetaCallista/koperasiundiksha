import 'package:flutter/material.dart';
import 'package:koperasi_undiksha/pages/deposito_page.dart';
import 'package:koperasi_undiksha/pages/mutasi_page.dart';
import 'package:koperasi_undiksha/pages/pembayaran_page.dart';
import 'package:koperasi_undiksha/pages/pinjaman_page.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/saldo_page.dart';
import 'pages/transfer_page.dart';
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
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/saldo': (context) => SaldoPage(),
        '/transfer': (context) => TransferPage(),
        '/scan': (context) => ScanPage(),
        '/settings': (context) => SettingPage(),
        '/profile': (context) => ProfilePage(),
        '/deposito': (context) => DepositoPage(),
        '/pembayaran': (context) => PembayaranPage(),
        '/pinjaman': (context) => PinjamanPage(),
        '/mutasi': (context) => MutasiPage(),
      },
    );
  }
}
