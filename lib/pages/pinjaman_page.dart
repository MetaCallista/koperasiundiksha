import 'package:flutter/material.dart';
import 'package:koperasi_undiksha/pages/home_page.dart';
import 'package:koperasi_undiksha/widgets/app_colors.dart';
import 'package:provider/provider.dart';
import '../providers/balance_provider.dart';
import '../providers/mutasi_provider.dart';  // Import MutasiProvider

class PinjamanPage extends StatefulWidget {
  const PinjamanPage({super.key});

  @override
  State<PinjamanPage> createState() => _PinjamanPageState();
}

class _PinjamanPageState extends State<PinjamanPage> {
  String? selectedJenisPinjaman;
  final nominalController = TextEditingController();
  final durasiController = TextEditingController();

  final List<String> jenisPinjamanList = [
    'Pinjaman Pendidikan',
    'Pinjaman Modal Usaha',
    'Pinjaman Kesehatan',
    'Pinjaman Konsumtif',
  ];

  void ajukanPinjaman() {
    if (selectedJenisPinjaman != null &&
        nominalController.text.isNotEmpty &&
        durasiController.text.isNotEmpty) {
      // Parsing the nominal pinjaman (loan amount)
      final nominal = int.tryParse(nominalController.text.replaceAll('.', '')) ?? 0;

      // Check if the loan amount is valid
      if (nominal <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Nominal pinjaman tidak valid!")),
        );
        return;
      }

      // Get the current balance using BalanceProvider
      final balanceProvider = Provider.of<BalanceProvider>(context, listen: false);

      // Add the loan amount to the current balance using BalanceProvider
      balanceProvider.tambahSaldo(nominal.toDouble());

      // Menambahkan mutasi pinjaman
      final mutasiProvider = Provider.of<MutasiProvider>(context, listen: false);
      mutasiProvider.tambahMutasi(
        'Pemasukan', // Tipe mutasi
        'Pinjaman: ${selectedJenisPinjaman}', // Deskripsi mutasi
        nominal.toDouble(), // Nominal mutasi
        DateTime.now().toString(), // Tanggal mutasi
      );

      // Show success message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Pengajuan Berhasil"),
          content: const Text("Pengajuan pinjaman Anda telah berhasil dikirim."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Harap lengkapi semua data!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'Pinjaman',
          style: TextStyle(
            color: AppColors.background,
            fontWeight: FontWeight.normal,
          ),
        ),
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Jenis Pinjaman",
              style: TextStyle(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.border),
                ),
              ),
              hint: const Text("Pilih Jenis Pinjaman"),
              value: selectedJenisPinjaman,
              items: jenisPinjamanList.map((jenis) {
                return DropdownMenuItem(
                  value: jenis,
                  child: Text(jenis),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedJenisPinjaman = value;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text(
              "Nominal Pinjaman",
              style: TextStyle(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: nominalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Contoh: 5000000",
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.border),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Durasi Pinjaman (bulan)",
              style: TextStyle(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: durasiController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Contoh: 12",
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.border),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: TextButton.icon(
                onPressed: ajukanPinjaman,
                icon: const Icon(Icons.send, color: AppColors.background),
                label: const Text(
                  "Ajukan Pinjaman",
                  style: TextStyle(color: AppColors.background),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(23),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
