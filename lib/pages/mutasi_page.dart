import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_colors.dart';
import '../providers/mutasi_provider.dart';

class MutasiPage extends StatelessWidget {
  const MutasiPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mutasiList = context.watch<MutasiProvider>().mutasiList;

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
          onPressed:
              () => Navigator.pushNamedAndRemoveUntil(
                context,
                '/home',
                (route) => false,
              ),
        ),
      ),
      backgroundColor: AppColors.background,
      body:
          mutasiList.isEmpty
              ? const Center(
                child: Text(
                  'Belum ada mutasi.',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: mutasiList.length,
                itemBuilder: (context, index) {
                  final item = mutasiList[index];
                  return Card(
                    elevation: 2,
                    shadowColor: AppColors.shadow,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: item['warna'],
                        child: Icon(item['icon'], color: AppColors.background),
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
                        '${item['simbol']} Rp${item['nominal'].toStringAsFixed(0)}',
                        style: TextStyle(
                          color: item['warna'],
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
