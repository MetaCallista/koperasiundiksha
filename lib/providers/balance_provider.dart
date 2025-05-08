import 'package:flutter/material.dart';

class BalanceProvider extends ChangeNotifier {
  double _saldo = 2050000;
  double _totalPemasukan = 2050000;
  double _totalPengeluaran = 850000;

  double get saldo => _saldo;
  double get totalPemasukan => _totalPemasukan;
  double get totalPengeluaran => _totalPengeluaran;

  // Add money to saldo and totalPemasukan
  void tambahSaldo(double nominal) {
    _saldo += nominal;
    _totalPemasukan += nominal;
    notifyListeners();
  }

  // Subtract money from saldo and totalPengeluaran
  void kurangiSaldo(double nominal) {
    if (nominal <= _saldo) {
      _saldo -= nominal;
      _totalPengeluaran += nominal;
      notifyListeners();
    }
  }
}
