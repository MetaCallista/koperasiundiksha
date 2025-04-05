import 'package:flutter/material.dart';
import 'home_page.dart';
import '../widgets/app_colors.dart'; 

class PembayaranPage extends StatefulWidget {
  const PembayaranPage({Key? key}) : super(key: key);

  @override
  State<PembayaranPage> createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  String? jenisPembayaran = 'Iuran Bulanan';
  String? metodePembayaran = 'QRIS';
  final nominalController = TextEditingController(text: '1.000.000');

  final List<String> jenisPembayaranList = [
    'Iuran Bulanan',
    'Simpanan Pokok',
    'Simpanan Wajib',
    'Simpanan Sukarela',
  ];

  final List<String> metodePembayaranList = [
    'QRIS',
    'Transfer Bank',
    'Tunai',
  ];

  void _showSuccessNotification() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pembayaran Berhasil'),
          content: const Text('Terima kasih, pembayaran Anda telah diproses.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: const Text(
          'Pembayaran',
          style: TextStyle(color: AppColors.background),
        ),
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
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Jenis Pembayaran",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 5),
            DropdownButtonFormField<String>(
              value: jenisPembayaran,
              items: jenisPembayaranList.map((jenis) {
                return DropdownMenuItem(
                  value: jenis,
                  child: Text(jenis),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  jenisPembayaran = value;
                });
              },
              decoration: const InputDecoration(
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.border),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Nominal",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: nominalController,
              readOnly: true,
              decoration: const InputDecoration(
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.border),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Metode Pembayaran",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 5),
            DropdownButtonFormField<String>(
              value: metodePembayaran,
              items: metodePembayaranList.map((metode) {
                return DropdownMenuItem(
                  value: metode,
                  child: Text(metode),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  metodePembayaran = value;
                });
              },
              decoration: const InputDecoration(
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.border),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                onPressed: _showSuccessNotification,
                icon: const Icon(Icons.payment, color: AppColors.background),
                label: const Text(
                  'Bayar Sekarang',
                  style: TextStyle(color: AppColors.background),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5, 
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
