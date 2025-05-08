import 'package:flutter/material.dart';
import 'balance_provider.dart';

class DepositoProvider extends ChangeNotifier {
  final List<Map<String, String>> _depositoList = [];

  List<Map<String, String>> get depositoList => _depositoList;

  bool addDeposito({
    required String amount,
    required String duration,
    required String interest,
    required BalanceProvider balanceProvider,
  }) {
    // Menghilangkan karakter selain digit, lalu konversi ke double
    final sanitizedAmount = amount.replaceAll(RegExp(r'[^\d]'), '');
    final nominal = double.tryParse(sanitizedAmount);

    if (nominal == null || nominal <= 0) {
      return false;
    }

    if (balanceProvider.saldo >= nominal) {
      // Kurangi saldo utama
      balanceProvider.kurangiSaldo(nominal);

      // Menambahkan deposito ke list deposito
      _depositoList.add({
        'title': 'Deposito ${_depositoList.length + 1}',
        'amount': 'Rp. ${_formatCurrency(nominal)}',
        'duration': duration,
        'interest': interest,
      });

      notifyListeners();
      return true;
    } else {
      return false; // saldo tidak mencukupi
    }
  }

  String _formatCurrency(double value) {
    // Format manual ke "5.000.000" tanpa package tambahan
    return value.toStringAsFixed(0);
  }
}
