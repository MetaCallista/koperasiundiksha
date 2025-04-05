import 'package:flutter/material.dart';
import 'home_page.dart';
import '../widgets/app_colors.dart';

class DepositoPage extends StatelessWidget {
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
          title: const Text(
            "Deposito",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: AppColors.primary,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
                (route) => false,
              );
            },
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
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFFBBDEFB), 
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Total Deposito:",
                      style: TextStyle(fontSize: 16, color: AppColors.textPrimary),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Rp. 10.000.000",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Bunga Deposito: 5% per tahun",
                      style: TextStyle(color: AppColors.textPrimary),
                    ),
                    Text(
                      "Jangka Waktu: 12 Bulan",
                      style: TextStyle(color: AppColors.textPrimary),
                    ),
                  ],
                ),
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
                child: ListView(
                  children: [
                    _buildDepositoItem("Deposito 1", "Rp. 5.000.000", "12 Bulan", "5%"),
                    _buildDepositoItem("Deposito 2", "Rp. 5.000.000", "6 Bulan", "4.5%"),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Tambahkan logika buka deposito baru di sini
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    "Buka Deposito Baru",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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

  static Widget _buildDepositoItem(String title, String amount, String duration, String interest) {
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
