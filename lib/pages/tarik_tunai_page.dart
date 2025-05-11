import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/balance_provider.dart';
import '../providers/mutasi_provider.dart';
import '../widgets/app_colors.dart';

class TarikTunaiPage extends StatefulWidget {
  @override
  _TarikTunaiPageState createState() => _TarikTunaiPageState();
}

class _TarikTunaiPageState extends State<TarikTunaiPage> {
  final TextEditingController _jumlahController = TextEditingController();
  String _message = '';
  String? _selectedJalurTarik;

  final List<String> jalurTarikOptions = [
    'Loket Koperasi',
    'ATM',
    'Indomaret/Alfamart',
  ];

  void _tarikUang() {
    final jumlah = int.tryParse(_jumlahController.text);
    final saldoSekarang =
        Provider.of<BalanceProvider>(context, listen: false).saldo;

    if (jumlah == null || jumlah <= 0) {
      setState(() {
        _message = "Masukkan jumlah yang valid.";
      });
      return;
    }

    if (jumlah > saldoSekarang) {
      setState(() {
        _message = "Saldo tidak mencukupi untuk penarikan sebesar Rp. $jumlah.";
      });
      return;
    }

    Provider.of<BalanceProvider>(
      context,
      listen: false,
    ).kurangiSaldo(jumlah.toDouble());

    Provider.of<MutasiProvider>(context, listen: false).tambahMutasi(
      'pengeluaran',
      'Tarik Tunai dari Saldo Koperasi melalui $_selectedJalurTarik',
      jumlah.toDouble(),
      DateTime.now().toString(),
    );

    setState(() {
      _message =
          "Penarikan sebesar Rp. $jumlah berhasil melalui $_selectedJalurTarik.\nSisa saldo: Rp. ${Provider.of<BalanceProvider>(context, listen: false).saldo}";
      _jumlahController.clear();
      _selectedJalurTarik = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: AppColors.background,
      appBar: AppBar(
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
        centerTitle: true,
        title: const Text("Tarik Tunai", style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Saldo
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet,
                          color: AppColors.background,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Saldo Anda",
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Consumer<BalanceProvider>(
                              builder: (context, balanceProvider, _) {
                                return Text(
                                  "Rp. ${balanceProvider.saldo}",
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Form Input Jumlah dan Jalur
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Masukkan jumlah yang ingin ditarik:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _jumlahController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Jumlah (Rp)",
                        hintText: "Contoh: 100000",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedJalurTarik,
                      items:
                          jalurTarikOptions.map((value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                      decoration: InputDecoration(
                        labelText: "Jalur Tarik Tunai",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _selectedJalurTarik = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _tarikUang,
                icon: const Icon(Icons.money, color: Colors.white),
                label: const Text("Tarik Sekarang"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  foregroundColor: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 20),

            if (_message.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color:
                      _message.contains("berhasil")
                          ? AppColors.income.withOpacity(0.2)
                          : AppColors.expense.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _message,
                  style: TextStyle(
                    color:
                        _message.contains("berhasil")
                            ? AppColors.income
                            : AppColors.expense,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
