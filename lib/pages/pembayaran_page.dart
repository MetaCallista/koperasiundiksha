import 'package:flutter/material.dart';
import 'package:koperasi_undiksha/providers/balance_provider.dart';
import 'package:koperasi_undiksha/providers/mutasi_provider.dart'; // Tambahkan import ini
import 'package:provider/provider.dart';
import 'home_page.dart';
import '../widgets/app_colors.dart';

class PembayaranPage extends StatefulWidget {
  const PembayaranPage({Key? key}) : super(key: key);

  @override
  State<PembayaranPage> createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  String? jenisPembayaran;
  String? metodePembayaran;
  String? nomorRekening;
  String? bank;
  final nominalController = TextEditingController();

  final List<String> jenisPembayaranList = [
    'Iuran Bulanan',
    'Simpanan Pokok',
    'Simpanan Wajib',
    'Simpanan Sukarela',
  ];

  final List<String> metodePembayaranList = [
    'BI Fast',
    'Saldo Koperasi',
    'Transfer Online',
    'Dompet Digital',
  ];

  final List<String> bankList = [
    'Bank BCA',
    'Bank Mandiri',
    'Bank BRI',
    'Bank BTN',
    // Tambahkan bank lainnya jika perlu
  ];

  String getDeskripsiMetodePembayaran(String? metode) {
    switch (metode) {
      case 'Saldo Koperasi':
        return 'Waktu pembayaran cepat, biasanya hanya beberapa menit, dengan biaya admin Rp 2.500,- per transaksi.';
      case 'BI Fast':
        return 'Waktu pembayaran cepat, biasanya hanya beberapa menit, dengan biaya admin Rp 6.500,- per transaksi.';
      case 'Transfer Online':
        return 'Pembayaran melalui transfer bank biasa yang dapat memakan waktu beberapa jam, biaya admin Rp 10.000,-.';
      case 'Dompet Digital':
        return 'Pembayaran melalui dompet digital seperti OVO, GoPay, atau Dana dengan biaya admin rendah atau tanpa biaya.';
      default:
        return '';
    }
  }

  void _showSuccessNotification() {
    final nominal = int.tryParse(nominalController.text.replaceAll('.', '')) ?? 0;

    // Pastikan nominal valid
    if (nominal <= 0) {
      return;
    }

    // Ambil saldo dari Provider
    final balanceProvider = Provider.of<BalanceProvider>(context, listen: false);

    // Cek apakah saldo mencukupi
    if (balanceProvider.saldo < nominal) {
      _showErrorNotification();
    } else {
      // Jika saldo cukup, proses pembayaran
      balanceProvider.kurangiSaldo(nominal.toDouble()); // Mengurangi saldo dengan menggunakan metode dari BalanceProvider

      // Menambahkan mutasi pengeluaran ke MutasiProvider
      final mutasiProvider = Provider.of<MutasiProvider>(context, listen: false);
      mutasiProvider.tambahMutasi(
        'pengeluaran',       // Tipe transaksi adalah pengeluaran
        jenisPembayaran ?? '',  // Deskripsi pembayaran
        nominal.toDouble(),    // Nominal pengeluaran
        DateTime.now().toString(), // Tanggal transaksi
      );

      // Tampilkan notifikasi pembayaran berhasil
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
  }

  void _showErrorNotification() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pembayaran Gagal'),
          content: const Text('Saldo Anda tidak mencukupi untuk melakukan pembayaran.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    nominalController.clear(); // Mengosongkan controller saat halaman pertama kali dibuka
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
              hint: const Text(
                "Pilih Jenis Pembayaran",
                style: TextStyle(color: Colors.grey), // Ukuran huruf kecil
              ),
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
              decoration: const InputDecoration(
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.border),
                ),
                hintText: "Contoh : 1000000",
                hintStyle: TextStyle(color: Colors.grey), // Hint text abu dan ukuran kecil
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
              hint: const Text(
                "Pilih Metode Pembayaran",
                style: TextStyle(color: Colors.grey), // Ukuran huruf kecil
              ),
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
            const SizedBox(height: 10),
            // Menambahkan deskripsi metode pembayaran
            if (metodePembayaran != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  getDeskripsiMetodePembayaran(metodePembayaran),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                onPressed: _showSuccessNotification,
                icon: const Icon(Icons.payment, color: AppColors.background),
                label: const Text(
                  'Bayar',
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
