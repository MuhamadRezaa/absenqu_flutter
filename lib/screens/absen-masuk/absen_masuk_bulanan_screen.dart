import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class AbsenMasukBulananScreen extends StatefulWidget {
  const AbsenMasukBulananScreen({super.key});

  @override
  State<AbsenMasukBulananScreen> createState() =>
      _AbsenMasukBulananScreenState();
}

class _AbsenMasukBulananScreenState extends State<AbsenMasukBulananScreen> {
  late Timer _timer;
  String _currentTime = '';

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null);
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      _currentTime = DateFormat('HH:mm:ss').format(now);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final tanggalBulan = DateFormat('d MMMM', 'id_ID').format(now);
    final tahun = DateFormat('yyyy', 'id_ID').format(now);

    final hijri = HijriCalendar.fromDate(now);
    final tanggalHijriah = '${hijri.hDay}';
    final bulanHijriah = hijri.longMonthName;
    final tahunHijriah = '${hijri.hYear} H';

    return Scaffold(
      body: Stack(
        children: [
          // === BACKGROUND GRADIENT ===
          const SizedBox.expand(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF93FFFA), Color(0xFFB4B4B4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),

          // === MAIN CONTENT ===
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // === HEADER ===
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 3),
                                Text(
                                  tanggalBulan,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF373643),
                                  ),
                                ),
                                Text(
                                  tahun,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF373643),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 2,
                              height: 44,
                              color: const Color(0xFF373643),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 3),
                                Row(
                                  children: [
                                    Text(
                                      tanggalHijriah,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF373643),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      bulanHijriah,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF373643),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  tahunHijriah,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF373643),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const SizedBox(height: 3),
                          Text(
                            _currentTime,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF373643),
                            ),
                          ),
                          const SizedBox(height: 1),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.arrow_back,
                              size: 30,
                              color: Color(0xFF373643),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // === JUDUL DI TENGAH ===
                const Center(
                  child: Text(
                    "Riwayat Absensi Masuk Bulan April",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color.fromARGB(255, 19, 19, 19),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // === TIGA KOTAK STATISTIK ===
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildStatCard("Sesuai", "20 Hari", Colors.greenAccent),
                    _buildStatCard(
                      "Tidak Sesuai",
                      "2 Hari",
                      Colors.yellow.shade100,
                    ),
                    _buildStatCard("Poin", "205", Colors.red.shade200),
                  ],
                ),

                const SizedBox(height: 20),

                // === CONTAINER DATA PEGAWAI & RIWAYAT ABSEN ===
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFAEEBE8), Color(0xFFB7B7B7)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListView(
                      children: [
                        _buildAbsenCard(
                          tanggal: "01 Januari 2025",
                          jam: "07.35",
                          status: "SESUAI",
                          poin: 10,
                          lokasi:
                              "Jalan Ringroad Komplek OCBC Toko Cabang Ringroad",
                        ),
                        _buildAbsenCard(
                          tanggal: "02 Januari 2025",
                          jam: "08.10",
                          status: "TIDAK SESUAI",
                          poin: -5,
                          lokasi:
                              "Jalan Ringroad Komplek OCBC Toko Cabang Ringroad",
                        ),
                        _buildAbsenCard(
                          tanggal: "03 Januari 2025",
                          jam: "07.55",
                          status: "SESUAI",
                          poin: 10,
                          lokasi:
                              "Jalan Ringroad Komplek OCBC Toko Cabang Ringroad",
                        ),
                        _buildAbsenCard(
                          tanggal: "03 Januari 2025",
                          jam: "07.55",
                          status: "SESUAI",
                          poin: 10,
                          lokasi:
                              "Jalan Ringroad Komplek OCBC Toko Cabang Ringroad",
                        ),
                        _buildAbsenCard(
                          tanggal: "03 Januari 2025",
                          jam: "07.55",
                          status: "SESUAI",
                          poin: 10,
                          lokasi:
                              "Jalan Ringroad Komplek OCBC Toko Cabang Ringroad",
                        ),
                        _buildAbsenCard(
                          tanggal: "03 Januari 2025",
                          jam: "17.10",
                          status: "TIDAK SESUAI",
                          poin: -5,
                          lokasi:
                              "Jalan Ringroad Komplek OCBC Toko Cabang Ringroad",
                        ),
                        _buildAbsenCard(
                          tanggal: "03 Januari 2025",
                          jam: "17.35",
                          status: "SESUAI",
                          poin: 10,
                          lokasi:
                              "Jalan Ringroad Komplek OCBC Toko Cabang Ringroad",
                        ),
                        _buildAbsenCard(
                          tanggal: "03 Januari 2025",
                          jam: "17.35",
                          status: "SESUAI",
                          poin: 10,
                          lokasi:
                              "Jalan Ringroad Komplek OCBC Toko Cabang Ringroad",
                        ),
                        _buildAbsenCard(
                          tanggal: "03 Januari 2025",
                          jam: "17.35",
                          status: "SESUAI",
                          poin: 10,
                          lokasi:
                              "Jalan Ringroad Komplek OCBC Toko Cabang Ringroad",
                        ),
                        _buildAbsenCard(
                          tanggal: "03 Januari 2025",
                          jam: "17.10",
                          status: "TIDAK SESUAI",
                          poin: -5,
                          lokasi:
                              "Jalan Ringroad Komplek OCBC Toko Cabang Ringroad",
                        ),
                        _buildAbsenCard(
                          tanggal: "03 Januari 2025",
                          jam: "17.35",
                          status: "SESUAI",
                          poin: 10,
                          lokasi:
                              "Jalan Ringroad Komplek OCBC Toko Cabang Ringroad",
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // === Widget Helper untuk Kotak Statistik ===
  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2)),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // === Widget Helper untuk Kartu Absen ===
  // === Widget Helper untuk Kartu Absen ===
  Widget _buildAbsenCard({
    required String tanggal,
    required String jam,
    required String status,
    required int poin,
    required String lokasi,
  }) {
    return Card(
      elevation: 3,
      color: const Color(0xFFF7FEFF),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === BARIS 1: Tanggal & "Nilai Poin" ===
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tanggal,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Color(0xFF2E2E2E),
                  ),
                ),
                const Text(
                  "Nilai Poin",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Color(0xFF2E2E2E),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // === BARIS 2: Jam - Status - Poin ===
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Jam
                  Text(
                    jam,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  // Status rata kiri
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        status,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: status == "SESUAI"
                              ? const Color.fromARGB(255, 0, 0, 0)
                              : Colors.red,
                        ),
                      ),
                    ),
                  ),

                  // Poin
                  Padding(
                    padding: const EdgeInsets.only(right: 14),
                    child: Text(
                      poin.toString(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: poin >= 0
                            ? const Color.fromARGB(255, 0, 0, 0)
                            : Colors.redAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),

            // === BARIS 3: Lokasi (tanpa ikon, teks hitam & kecil) ===
            Padding(
              padding: const EdgeInsets.only(left: 2),
              child: Text(
                "Lokasi – $lokasi",
                style: const TextStyle(
                  fontSize: 11, // 🔹 lebih kecil dari sebelumnya
                  color: Colors.black, // 🔹 teks hitam
                  fontWeight: FontWeight.w400,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
