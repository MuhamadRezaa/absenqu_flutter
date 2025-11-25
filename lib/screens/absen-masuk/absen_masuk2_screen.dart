import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class AbsenMasuk2Screen extends StatefulWidget {
  const AbsenMasuk2Screen({super.key});

  @override
  State<AbsenMasuk2Screen> createState() => _AbsenMasuk2ScreenState();
}

class _AbsenMasuk2ScreenState extends State<AbsenMasuk2Screen> {
  int _selectedMonthIndex = 0;
  late Timer _timer;
  String _currentTime = '';

  final List<Map<String, String>> _monthList = const [
    {"label": "Jan", "num": "1"},
    {"label": "Feb", "num": "2"},
    {"label": "Mar", "num": "3"},
    {"label": "Apr", "num": "4"},
    {"label": "Mei", "num": "5"},
    {"label": "Jun", "num": "6"},
    {"label": "Jul", "num": "7"},
    {"label": "Agu", "num": "8"},
    {"label": "Sep", "num": "9"},
    {"label": "Okt", "num": "10"},
    {"label": "Nov", "num": "11"},
    {"label": "Des", "num": "12"},
  ];

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
    final args = ModalRoute.of(context)!.settings.arguments as Map?;
    if (args != null && args['selectedMonthIndex'] != null) {
      _selectedMonthIndex = args['selectedMonthIndex'];
    }

    final hijri = HijriCalendar.fromDate(now);
    final tanggalHijriah = '${hijri.hDay}';
    final bulanHijriah = hijri.longMonthName;
    final tahunHijriah = '${hijri.hYear} H';

    return Scaffold(
      body: Stack(
        children: [
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
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
                            const SizedBox(height: 10),
                            const Text(
                              "Riwayat Absensi",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF373643),
                              ),
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
                const SizedBox(height: 15),

                // === LIST BULAN ===
                SizedBox(
                  height: 90,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: _monthList.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final m = _monthList[index];
                      return _MonthCard(
                        label: m['label']!,
                        number: m['num']!,
                        isSelected: _selectedMonthIndex == index,
                        onTap: () {
                          setState(() {
                            _selectedMonthIndex = index;
                          });

                          // Delay biar warna kuning muncul dulu
                          Future.delayed(const Duration(milliseconds: 150), () {
                            if (index == 2) {
                              // 🔹 Tetap ke halaman berikutnya (AbsenMasuk3)
                              Navigator.pushNamed(
                                context,
                                '/absen_masuk3',
                                arguments: {'selectedMonthIndex': index},
                              );
                            } else {
                              // 🔹 Selain index 2, balik ke halaman pertama (AbsenMasukScreen1)
                              Navigator.pushNamed(
                                context,
                                '/absen_masuk',
                                arguments: {'selectedMonthIndex': index},
                              );
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),

                // === AREA KONTEN ===
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 30, bottom: 1),
                    child: Column(
                      children: [
                        InfoContainer(
                          title: "Riwayat Absensi Masuk",
                          icon: Icons.login_rounded,
                          gradientColors: const [
                            Color(0xFFC5E8EE),
                            Color(0xFFBAD3D7),
                          ],
                          items: const [
                            AbsensiField(
                              tanggal: "01 Januari 2025",
                              jam: "07.35",
                              status: "SESUAI",
                              poin: 10,
                              lokasi:
                                  "Jalan Ringroad Komplek OCBC Toko Cabang Ringroad",
                            ),
                            AbsensiField(
                              tanggal: "02 Januari 2025",
                              jam: "07.35",
                              status: "TIDAK SESUAI",
                              poin: -5,
                              lokasi:
                                  "Jalan Ringroad Komplek OCBC Toko Cabang Ringroad",
                            ),
                            AbsensiField(
                              tanggal: "03 Januari 2025",
                              jam: "07.55",
                              status: "SESUAI",
                              poin: 10,
                              lokasi:
                                  "Jalan Ringroad Komplek OCBC Toko Cabang Ringroad",
                            ),
                          ],
                        ),
                        Transform.translate(
                          offset: const Offset(0, -20),
                          child: InfoContainer(
                            title: "Riwayat Absensi Pulang",
                            icon: Icons.logout_rounded,
                            gradientColors: const [
                              Color(0xFFD6DFE8),
                              Color(0xFFBFC3C8),
                            ],
                            items: const [
                              AbsensiField(
                                tanggal: "01 Januari 2025",
                                jam: "17.35",
                                status: "SESUAI",
                                poin: 10,
                                lokasi:
                                    "Jalan Ringroad Komplek OCBC Toko Cabang Ringroad",
                              ),
                              AbsensiField(
                                tanggal: "02 Januari 2025",
                                jam: "17.35",
                                status: "SESUAI",
                                poin: 10,
                                lokasi:
                                    "Jalan Ringroad Komplek OCBC Toko Cabang Ringroad",
                              ),
                              AbsensiField(
                                tanggal: "03 Januari 2025",
                                jam: "17.10",
                                status: "TIDAK SESUAI",
                                poin: -5,
                                lokasi:
                                    "Jalan Ringroad Komplek OCBC Toko Cabang Ringroad",
                              ),
                            ],
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(0, -40),
                          child: InfoContainer(
                            title: "Riwayat Izin",
                            icon: Icons.assignment_turned_in_rounded,
                            gradientColors: const [
                              Color(0xFFD9D7E1),
                              Color(0xFFC7C5CC),
                            ],
                            items: const [
                              // IzinField(
                              //   jenisIzin: "Izin Sakit",
                              //   rentangWaktu: "1 Maret – 3 Maret 2025",
                              //   tanggalPengajuan: "Senin, 1 April 2025",
                              //   status: "DITERIMA",
                              // ),
                            ],
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(
                            0,
                            -70,
                          ), // nilai negatif = naik ke atas
                          child: InfoContainer(
                            title: "Riwayat Cuti",
                            icon: Icons.beach_access_rounded,
                            gradientColors: const [
                              Color(0xFFD9D7E1),
                              Color(0xFFC7C5CC),
                            ],
                            items: const [
                              // CutiField(
                              //   jenisCuti: "Cuti Tahunan",
                              //   rentangWaktu: "10 Mei – 15 Mei 2025",
                              //   tanggalPengajuan: "Senin, 5 Mei 2025",
                              //   status: "DITERIMA",
                              // ),
                              // CutiField(
                              //   jenisCuti: "Cuti Pribadi",
                              //   rentangWaktu: "20 Juni – 22 Juni 2025",
                              //   tanggalPengajuan: "Rabu, 18 Juni 2025",
                              //   status: "DITOLAK",
                              // ),
                            ],
                          ),
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
}

// === BULAN CARD ===
class _MonthCard extends StatelessWidget {
  final String label;
  final String number;
  final bool isSelected;
  final VoidCallback onTap;

  const _MonthCard({
    required this.label,
    required this.number,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor = label == "Feb"
        ? const Color(0xFFFFF9C4) // kuning lembut untuk Januari
        : const Color(0xFFDFF8F8); // biru muda untuk lainnya

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 60,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: Color(0xFF373643),
              ),
            ),
            const Spacer(),
            Text(
              number,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: Color(0xFF373643),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// === INFO CONTAINER DENGAN ICON ===
class InfoContainer extends StatelessWidget {
  final String title;
  final List<Widget> items;
  final List<Color>? gradientColors;
  final IconData? icon;

  const InfoContainer({
    super.key,
    required this.title,
    required this.items,
    this.gradientColors,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:
              gradientColors ?? const [Color(0xFFDAD9E4), Color(0xFFB4B3B6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(topRight: Radius.circular(45)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (icon != null)
                    Icon(icon, size: 22, color: const Color(0xFF373643)),
                  if (icon != null) const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF373643),
                    ),
                  ),
                ],
              ),
              InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () {
                  Navigator.pushNamed(context, '/absen_masuk_bulanan');
                },
                child: const Icon(
                  Icons.arrow_forward,
                  size: 22,
                  color: Color(0xFF373643),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          ...items,
        ],
      ),
    );
  }
}

// === ABSENSI FIELD ===
class AbsensiField extends StatelessWidget {
  final String tanggal;
  final String jam;
  final String status;
  final int poin;
  final String lokasi;

  const AbsensiField({
    super.key,
    required this.tanggal,
    required this.jam,
    required this.status,
    required this.poin,
    required this.lokasi,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSesuai = status.toUpperCase() == "SESUAI";
    final Color statusColor = isSesuai
        ? const Color(0xFF008000)
        : const Color(0xFFE53935);
    final Color poinColor = isSesuai ? Colors.black : const Color(0xFFE53935);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tanggal,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const Text(
                "Nilai Poin",
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    jam,
                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
              Text(
                poin.toString(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: poinColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            'Lokasi – $lokasi',
            style: const TextStyle(fontSize: 11.5, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

// === IZIN FIELD ===
class IzinField extends StatelessWidget {
  final String jenisIzin;
  final String rentangWaktu;
  final String tanggalPengajuan;
  final String status;

  const IzinField({
    super.key,
    required this.jenisIzin,
    required this.rentangWaktu,
    required this.tanggalPengajuan,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDiterima = status.toUpperCase() == "DITERIMA";
    final Color statusColor = isDiterima
        ? Colors.black
        : const Color(0xFFE53935);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F6),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                jenisIzin,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Waktu $rentangWaktu',
                style: const TextStyle(fontSize: 12.5, color: Colors.black87),
              ),
              const SizedBox(height: 3),
              Text(
                tanggalPengajuan,
                style: const TextStyle(fontSize: 12.5, color: Colors.black87),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                "Status",
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                status.toUpperCase(),
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: statusColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// === CUTI FIELD ===
class CutiField extends StatelessWidget {
  final String jenisCuti;
  final String rentangWaktu;
  final String tanggalPengajuan;
  final String status;

  const CutiField({
    super.key,
    required this.jenisCuti,
    required this.rentangWaktu,
    required this.tanggalPengajuan,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDiterima = status.toUpperCase() == "DITERIMA";
    final Color statusColor = isDiterima
        ? Colors.black
        : const Color(0xFFE53935);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F6),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Kiri: Info cuti
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                jenisCuti,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Waktu $rentangWaktu',
                style: const TextStyle(fontSize: 12.5, color: Colors.black87),
              ),
              const SizedBox(height: 3),
              Text(
                tanggalPengajuan,
                style: const TextStyle(fontSize: 12.5, color: Colors.black87),
              ),
            ],
          ),

          // Kanan: Status cuti
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                "Status",
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                status.toUpperCase(),
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: statusColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
