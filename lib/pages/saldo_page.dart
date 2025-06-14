import 'package:flutter/material.dart';
import 'package:koperasi_undiksha/providers/balance_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/app_colors.dart';

class SaldoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final balance = Provider.of<BalanceProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "Saldo Saya",
          style: TextStyle(color: AppColors.background),
        ),
        backgroundColor: AppColors.primary,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.background),
          onPressed:
              () => Navigator.pushNamedAndRemoveUntil(
                context,
                '/home',
                (route) => false,
              ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SaldoCard(
              saldoSaatIni: balance.saldo,
              onRefresh: () => balance.tambahSaldo(50000),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                StatistikCard(
                  title: "Total Pemasukan",
                  amount: balance.totalPemasukan,
                  color: AppColors.income,
                ),
                StatistikCard(
                  title: "Total Pengeluaran",
                  amount: balance.totalPengeluaran,
                  color: AppColors.expense,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SaldoCard extends StatelessWidget {
  final double saldoSaatIni;
  final VoidCallback onRefresh;

  const SaldoCard({required this.saldoSaatIni, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.2),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Saldo Saat Ini",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Rp. ${saldoSaatIni.toStringAsFixed(0)}",
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh, color: AppColors.background),
              label: const Text("Perbarui Saldo"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.background,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StatistikCard extends StatelessWidget {
  final String title;
  final double amount;
  final Color color;

  const StatistikCard({
    required this.title,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.5), width: 1),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "Rp. ${amount.toStringAsFixed(0)}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
