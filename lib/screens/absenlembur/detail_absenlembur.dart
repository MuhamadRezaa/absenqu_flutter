import 'dart:async';
import 'package:absenqu_flutter/screens/lembur/lembur.dart';
import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:absenqu_flutter/widgets/lokasi_map_test.dart';

class DetailAbsenLembur extends StatefulWidget {
  const DetailAbsenLembur({super.key});

  @override
  State<DetailAbsenLembur> createState() => _DetailAbsenLemburState();
}

class _DetailAbsenLemburState extends State<DetailAbsenLembur> {
  String? imagePath;
  final List<Map<String, String>> _weekDays = const [
    {"label": "Senin", "num": "1"},
    {"label": "Selasa", "num": "2"},
    {"label": "Rabu", "num": "3"},
    {"label": "Kamis", "num": "4"},
    {"label": "Jumat", "num": "5"},
  ];

  @override
  Widget build(BuildContext context) {
    var imagePath = ModalRoute.of(context)?.settings.arguments as String?;
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          const SizedBox.expand(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFEAD9FF), Color(0xFF999999)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final w = constraints.maxWidth;
                final h = constraints.maxHeight;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),

                      // ===== TATA LETAK UTAMA: COLUMN =====
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ========== HEADER: Row (kiri: tanggal, kanan: jam) ==========
                          HeaderDateTime(imagePath: imagePath),

                          const SizedBox(height: 10),

                          if (imagePath != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Terima Kasih,  Sudah Bekerja Lembur Hari Ini',
                                  style: TextStyle(
                                    color: Color(0xFF181818),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),

                          const SizedBox(height: 20),

                          // ========== LIST HORIZONTAL SENIN–JUMAT ==========
                          SizedBox(
                            height: h * 0.14,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: _weekDays.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 8),
                              itemBuilder: (context, index) {
                                final d = _weekDays[index];

                                // Misalnya Senin–Rabu hijau (selected)
                                final bool isGreen = index <= 0;

                                return DayCard(
                                  label: d['label']!,
                                  dayNum: d['num']!,
                                  isSelected: isGreen, // nonaktifkan tap
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: h * 0.02,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 40.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 15.0,
                          left: 30.0,
                          right: 30.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 20,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFEAD9FF),
                                    Color(0xFF6D6767),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(28),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.08),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(height: 12),
                                  _LemburItem(
                                    tanggal: '04 April 2025',
                                    title: 'Menyusun Laporan Audit Stok',
                                    lamaWaktu: '3 Jam',
                                    jam: '19.00 - 21.00',
                                    suketLembur:
                                        'Surat Lembur No. 123/LR.01/04/2025',
                                  ),
                                  const SizedBox(height: 12),

                                  if (imagePath != null)
                                    MapImgField(imagePath: imagePath),

                                  const SizedBox(height: 12),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // kiri
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Absen Lembur',
                                              style: TextStyle(
                                                color: Color(0xFF181818),
                                                fontWeight: FontWeight.w800,
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            // kartu putih bulat
                                            Container(
                                              width: double
                                                  .infinity, // Expanded menentukan lebar
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 12,
                                                    horizontal: 20,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(28),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(
                                                          0.08,
                                                        ), // <- perbaikan
                                                    blurRadius: 12,
                                                    offset: const Offset(0, 6),
                                                  ),
                                                ],
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '21.30', // isi sesuai kebutuhan
                                                  style: TextStyle(
                                                    color: Color(0xFF181818),
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      const SizedBox(width: 20),

                                      // kanan
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Status',
                                              style: TextStyle(
                                                color: Color(0xFF181818),
                                                fontWeight: FontWeight.w800,
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            // kartu putih bulat
                                            Container(
                                              width: double
                                                  .infinity, // Expanded menentukan lebar
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 12,
                                                    horizontal: 20,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(28),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(
                                                          0.08,
                                                        ), // <- perbaikan
                                                    blurRadius: 12,
                                                    offset: const Offset(0, 6),
                                                  ),
                                                ],
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'SESUAI', // isi sesuai kebutuhan
                                                  style: TextStyle(
                                                    color: Color(0xFF181818),
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DayCard extends StatelessWidget {
  final String label;
  final String dayNum;
  final bool isSelected;

  const DayCard({
    super.key,
    required this.label,
    required this.dayNum,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color base = isSelected
        ? const Color(0xFF76FF63)
        : const Color(0xFFFFFFFF).withValues(alpha: 0.35);
    return GestureDetector(
      child: Container(
        width: 80,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: base,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Color(0xFF373643),
              ),
            ),
            const Spacer(),
            Text(
              dayNum,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 22,
                color: Color(0xFF373643),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LemburItem extends StatelessWidget {
  final String tanggal, title, lamaWaktu, jam, suketLembur;
  const _LemburItem({
    required this.tanggal,
    required this.title,
    required this.lamaWaktu,
    required this.jam,
    required this.suketLembur,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Color(0xFF6D6767),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // BARIS TANGGAL & STATUS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tanggal,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  RichText(
                    text: TextSpan(
                      text: '$lamaWaktu |',
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      children: [
                        TextSpan(
                          text: ' $jam',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                suketLembur,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MapImgField extends StatelessWidget {
  final String? imagePath;
  const MapImgField({super.key, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // MAP di kiri
        Expanded(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: SizedBox(
                  height: 226,
                  width: double.infinity,
                  child: LokasiMapTest(),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        // FOTO di kanan
        Expanded(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: SizedBox(
                  height: 226,
                  width: double.infinity,
                  child: Image.file(File(imagePath!), fit: BoxFit.cover),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class HeaderDateTime extends StatefulWidget {
  final String? imagePath;
  const HeaderDateTime({super.key, this.imagePath});

  @override
  State<HeaderDateTime> createState() => _HeaderDateTimeState();
}

class _HeaderDateTimeState extends State<HeaderDateTime> {
  String _timeString = DateFormat('HH.mm', 'id_ID').format(DateTime.now());
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _timeString = DateFormat('HH.mm', 'id_ID').format(DateTime.now());
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final tanggalBulan = DateFormat('d MMMM', 'id_ID').format(now);
    final tahun = DateFormat('yyyy', 'id_ID').format(now);
    final hari = DateFormat('EEEE', 'id_ID').format(now);

    final hijri = HijriCalendar.now();
    final tanggalHijriah = '${hijri.hDay}';
    final bulanHijriah = hijri.longMonthName;
    final tahunHijriah = '${hijri.hYear} H';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tanggalBulan,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF373643),
                    ),
                  ),
                  Text(
                    tahun,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF373643),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Today, $hari',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF373643),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Container(
                width: 2,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFF373643),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          tanggalHijriah,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF373643),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            bulanHijriah,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF373643),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      tahunHijriah,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF373643),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _timeString,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF373643),
                  ),
                ),
                const SizedBox(width: 4),
                const Text(
                  'WIB',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF373643),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            IconButton(
              onPressed: () => Navigator.pushNamed(
                context,
                '/lembur',
                arguments: widget.imagePath,
              ),
              icon: const Icon(
                Icons.arrow_back,
                size: 40,
                color: Color(0xFF373643),
              ),
              tooltip: 'Kembali',
            ),
          ],
        ),
      ],
    );
  }
}
