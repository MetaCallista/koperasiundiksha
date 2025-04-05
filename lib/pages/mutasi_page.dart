import 'package:flutter/material.dart';
import 'home_page.dart';
import '../widgets/app_colors.dart'; 

class MutasiPage extends StatelessWidget {
  const MutasiPage({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> dummyMutasi = const [
    {
      'tipe': 'Masuk',
      'deskripsi': 'Simpanan Wajib',
      'tanggal': '25 Mar 2025',
      'nominal': 500000,
    },
    {
      'tipe': 'Keluar',
      'deskripsi': 'Penarikan Dana',
      'tanggal': '24 Mar 2025',
      'nominal': 200000,
    },
    {
      'tipe': 'Masuk',
      'deskripsi': 'Iuran Bulanan',
      'tanggal': '20 Mar 2025',
      'nominal': 100000,
    },
    {
      'tipe': 'Keluar',
      'deskripsi': 'Biaya Admin',
      'tanggal': '19 Mar 2025',
      'nominal': 5000,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: const Text(
          'Mutasi',
          style: TextStyle(color: AppColors.background),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.background),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => HomePage()),
            );
          },
        ),
      ),
      backgroundColor: AppColors.background,
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: dummyMutasi.length,
        itemBuilder: (context, index) {
          final item = dummyMutasi[index];
          final isMasuk = item['tipe'] == 'Masuk';
          return Card(
            elevation: 2,
            shadowColor: AppColors.shadow,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: isMasuk ? AppColors.income : AppColors.expense,
                child: Icon(
                  isMasuk ? Icons.arrow_downward : Icons.arrow_upward,
                  color: AppColors.background,
                ),
              ),
              title: Text(
                item['deskripsi'],
                style: const TextStyle(color: AppColors.textPrimary),
              ),
              subtitle: Text(
                item['tanggal'],
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              trailing: Text(
                (isMasuk ? '+ ' : '- ') + 'Rp${item['nominal'].toString()}',
                style: TextStyle(
                  color: isMasuk ? AppColors.income : AppColors.expense,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
