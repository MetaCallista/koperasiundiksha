import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';
import '../widgets/app_colors.dart';
import '../providers/deposito_provider.dart';
import '../providers/balance_provider.dart'; // Tambahan penting
import '../providers/mutasi_provider.dart'; // Tambahan MutasiProvider

class DepositoPage extends StatefulWidget {
  @override
  State<DepositoPage> createState() => _DepositoPageState();
}

class _DepositoPageState extends State<DepositoPage> {
  void _showAddDepositoDialog(BuildContext context) {
    final amountController = TextEditingController();
    final durationController = TextEditingController();
    final interestController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Buka Deposito Baru"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Jumlah Deposito (Rp)",
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: durationController,
                decoration: const InputDecoration(
                  labelText: "Durasi (misal: 6 Bulan)",
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: interestController,
                decoration: const InputDecoration(
                  labelText: "Bunga (misal: 5%)",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                final amount = amountController.text;
                final duration = durationController.text;
                final interest = interestController.text;

                if (amount.isNotEmpty &&
                    duration.isNotEmpty &&
                    interest.isNotEmpty) {
                  final depositoProvider = Provider.of<DepositoProvider>(
                    context,
                    listen: false,
                  );
                  final balanceProvider = Provider.of<BalanceProvider>(
                    context,
                    listen: false,
                  );
                  final mutasiProvider = Provider.of<MutasiProvider>(
                    context,
                    listen: false,
                  ); // Mendapatkan MutasiProvider

                  bool success = depositoProvider.addDeposito(
                    amount: amount,
                    duration: duration,
                    interest: interest,
                    balanceProvider: balanceProvider,
                  );

                  // Jika deposito berhasil, catat mutasi
                  if (success) {
                    mutasiProvider.tambahMutasi(
                      'Deposito Baru',
                      'Buka deposito Rp $amount, Durasi: $duration, Bunga: $interest',
                      double.parse(amount.replaceAll(RegExp(r'[^\d]'), '')),
                      DateTime.now().toString(),
                    );
                  }

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        success
                            ? 'Deposito berhasil dibuka.'
                            : 'Saldo tidak mencukupi untuk membuka deposito.',
                      ),
                      backgroundColor: success ? Colors.green : Colors.red,
                    ),
                  );
                }
              },
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
          (route) => false,
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Deposito", style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: AppColors.primary,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
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
              const Text(
                "Saldo Deposito Anda",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Consumer<DepositoProvider>(
                builder: (context, depositoProvider, _) {
                  // Menghitung total deposito
                  double totalDeposito = 0;
                  depositoProvider.depositoList.forEach((deposito) {
                    final amountString = deposito['amount']!;
                    final amount =
                        double.tryParse(
                          amountString.replaceAll(RegExp(r'[^\d]'), ''),
                        ) ??
                        0;
                    totalDeposito += amount;
                  });

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFFBBDEFB),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Total Deposito:",
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Rp. ${_formatCurrency(totalDeposito)}",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              const Text(
                "Riwayat Deposito",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Consumer<DepositoProvider>(
                  builder: (context, depositoProvider, _) {
                    return ListView.builder(
                      itemCount: depositoProvider.depositoList.length,
                      itemBuilder: (context, index) {
                        final deposito = depositoProvider.depositoList[index];
                        return _buildDepositoItem(
                          deposito['title']!,
                          deposito['amount']!,
                          deposito['duration']!,
                          deposito['interest']!,
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => _showAddDepositoDialog(context),
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    "Buka Deposito Baru",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _formatCurrency(double value) {
    return value.toStringAsFixed(0);
  }

  static Widget _buildDepositoItem(
    String title,
    String amount,
    String duration,
    String interest,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(title),
        subtitle: Text("Jumlah: $amount\nDurasi: $duration\nBunga: $interest"),
        isThreeLine: true,
        leading: const Icon(Icons.account_balance_wallet),
      ),
    );
  }
}
