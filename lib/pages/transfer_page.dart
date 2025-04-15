import 'package:flutter/material.dart';
import '../widgets/app_colors.dart';
import '../balance_state.dart';
import 'home_page.dart';

class TransferPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "Transfer Uang",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.background),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
      ),
      body: const TransferForm(),
    );
  }
}

class TransferForm extends StatefulWidget {
  const TransferForm({Key? key}) : super(key: key);

  @override
  _TransferFormState createState() => _TransferFormState();
}

class _TransferFormState extends State<TransferForm> {
  final TextEditingController rekeningController = TextEditingController();
  final TextEditingController jumlahController = TextEditingController();
  String selectedBank = "Bank Mandiri";

  final List<String> daftarBank = ["Bank Mandiri", "Bank BRI", "Bank BNI", "Bank BCA"];

  void _konfirmasiTransfer() {
    String rekening = rekeningController.text.trim();
    String jumlah = jumlahController.text.trim();

    if (rekening.isEmpty || jumlah.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Harap isi semua kolom!")),
      );
      return;
    }

    int jumlahInt = int.tryParse(jumlah) ?? 0;
    if (jumlahInt <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Jumlah transfer tidak valid!")),
      );
      return;
    }

    if (jumlahInt > BalanceState.saldo.value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Saldo tidak mencukupi untuk transfer!")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return TransferConfirmationDialog(
          rekening: rekening,
          jumlah: jumlahInt,
          bank: selectedBank,
          onConfirm: () {
            // Kurangi saldo
            BalanceState.saldo.value -= jumlahInt;

            // Tampilkan notifikasi
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Transfer berhasil dikirim!")),
            );

            // Kembali ke halaman utama
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Rekening Tujuan",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          TextField(
            controller: rekeningController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "Masukkan nomor rekening",
              hintStyle: TextStyle(color: AppColors.textSecondary),
              border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.border)),
              prefixIcon: Icon(Icons.account_balance, color: AppColors.primary),
            ),
          ),
          const SizedBox(height: 16),

          const Text(
            "Bank Tujuan",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          DropdownButtonFormField(
            value: selectedBank,
            items: daftarBank.map((bank) {
              return DropdownMenuItem(value: bank, child: Text(bank));
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedBank = value.toString();
              });
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.border)),
              prefixIcon: Icon(Icons.account_balance_wallet, color: AppColors.primary),
            ),
          ),
          const SizedBox(height: 16),

          const Text(
            "Jumlah Transfer",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          TextField(
            controller: jumlahController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "Masukkan jumlah transfer",
              hintStyle: TextStyle(color: AppColors.textSecondary),
              border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.border)),
              prefixIcon: Icon(Icons.money, color: AppColors.primary),
            ),
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _konfirmasiTransfer,
              icon: const Icon(Icons.send, color: Colors.white),
              label: const Text("Kirim Transfer"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shadowColor: AppColors.shadow,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TransferConfirmationDialog extends StatelessWidget {
  final String rekening;
  final int jumlah;
  final String bank;
  final VoidCallback onConfirm;

  const TransferConfirmationDialog({
    required this.rekening,
    required this.jumlah,
    required this.bank,
    required this.onConfirm,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Konfirmasi Transfer", style: TextStyle(color: AppColors.textPrimary)),
      content: Text(
        "Anda akan mentransfer Rp. $jumlah ke rekening $rekening di $bank.",
        style: const TextStyle(color: AppColors.textSecondary),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Batal", style: TextStyle(color: AppColors.expense)),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context); // Tutup dialog
            onConfirm(); // Jalankan aksi konfirmasi
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.income),
          child: const Text("Kirim"),
        ),
      ],
    );
  }
}
