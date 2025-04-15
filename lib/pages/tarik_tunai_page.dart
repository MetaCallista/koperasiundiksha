import 'package:flutter/material.dart';
import 'package:koperasi_undiksha/balance_state.dart';
import 'package:koperasi_undiksha/pages/home_page.dart';
import '../widgets/app_colors.dart';

class TarikTunaiPage extends StatefulWidget {
  @override
  _TarikTunaiPageState createState() => _TarikTunaiPageState();
}

class _TarikTunaiPageState extends State<TarikTunaiPage> {
  final TextEditingController _jumlahController = TextEditingController();
  String _message = '';

  String? _selectedSumberDana;
  String? _selectedJalurTarik;

  final List<String> sumberDanaOptions = [
    'Tabungan',
    'Simpanan Sukarela',
    'Deposito',
  ];

  final List<String> jalurTarikOptions = [
    'Loket Koperasi',
    'ATM',
    'Indomaret/Alfamart',
  ];

  void _tarikUang() {
    final jumlah = int.tryParse(_jumlahController.text);
    final saldoSekarang = BalanceState.saldo.value;

    if (_selectedSumberDana == null || _selectedJalurTarik == null) {
      setState(() {
        _message = "Silakan pilih sumber dana dan jalur tarik tunai.";
      });
      return;
    }

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

    // Update saldo global
    BalanceState.saldo.value = saldoSekarang - jumlah;

    setState(() {
      _message =
          "Penarikan sebesar Rp. $jumlah berhasil dari $_selectedSumberDana melalui $_selectedJalurTarik.\nSisa saldo: Rp. ${BalanceState.saldo.value}";
      _jumlahController.clear();
      _selectedSumberDana = null;
      _selectedJalurTarik = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.background),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
        centerTitle: true,
        title: const Text(
          "Tarik Tunai",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Saldo dengan ValueListenableBuilder
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
                          color: Colors.white,
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
                            ValueListenableBuilder<int>(
                              valueListenable: BalanceState.saldo,
                              builder: (context, saldo, _) {
                                return Text(
                                  "Rp. $saldo",
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

            // Form input
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
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                      value: _selectedSumberDana,
                      items: sumberDanaOptions.map((value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        labelText: "Sumber Dana",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _selectedSumberDana = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedJalurTarik,
                      items: jalurTarikOptions.map((value) {
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
                  color: _message.contains("berhasil")
                      ? AppColors.income.withOpacity(0.2)
                      : AppColors.expense.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _message,
                  style: TextStyle(
                    color: _message.contains("berhasil")
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
