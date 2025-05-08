import 'package:flutter/material.dart';

class MutasiProvider with ChangeNotifier {
  List<Map<String, dynamic>> _mutasiList = [];

  List<Map<String, dynamic>> get mutasiList => _mutasiList;

  // Fungsi untuk menambahkan mutasi
  void tambahMutasi(String tipe, String deskripsi, double nominal, String tanggal) {
    // Normalisasi input tipe (biar tidak peka kapitalisasi)
    final normalizedTipe = tipe.toLowerCase();

    IconData icon;
    Color warna;
    String simbol;

    if (normalizedTipe == 'pemasukan') {
      simbol = '+';
      icon = Icons.arrow_downward;
      warna = Colors.green;
    } else {
      simbol = '-';
      icon = Icons.arrow_upward;
      warna = Colors.red;
    }

    _mutasiList.insert(0, {
      'tipe': tipe,               // Tetap simpan tipe asli
      'deskripsi': deskripsi,     // Deskripsi asli
      'tanggal': tanggal,
      'nominal': nominal,         // Nominal asli
      'simbol': simbol,           // Untuk tampilan
      'icon': icon,
      'warna': warna,
    });

    notifyListeners();
  }
}
