import 'dart:io';
import 'package:absenqu_flutter/widgets/header_date_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Lembur extends StatefulWidget {
  const Lembur({super.key});

  @override
  State<Lembur> createState() => _LemburState();
}

class _LemburState extends State<Lembur> {
  String? _selectedImagePath;
  int _selectedMonthIndex = 0;
  final List<Map<String, String>> _monthEach = const [
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    final imagePath = ModalRoute.of(context)?.settings.arguments as String?;
    if (imagePath != null) {
      setState(() {
        _selectedImagePath = imagePath;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEDF6B0), Color(0xFF736F6F)],
            stops: [
              0.25, // warna pertama berhenti di 25%
              1.0, // warna kedua sampai 100%
            ],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Container(
                height: 364,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFFFFFF), Color(0xFF737373)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(40),
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
                              const HeaderDateTime(),

                              const SizedBox(height: 40),

                              // ========== LIST HORIZONTAL ==========
                              SizedBox(
                                height: h * 0.14,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _monthEach.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(width: 8),
                                  itemBuilder: (context, index) {
                                    final d = _monthEach[index];
                                    return MonthCard(
                                      label: d['label']!,
                                      monthNum: d['num']!,
                                      isSelected: _selectedMonthIndex == index,
                                      onTap: () => setState(
                                        () => _selectedMonthIndex = index,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 80),

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
                                Text(
                                  'Anda Memiliki Tugas Lembur',
                                  style: TextStyle(
                                    color: Color(0xFF373643),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _LemburItem(
                                  tanggal: '04 April 2025',
                                  title: 'Menyusun Laporan Audit Stok',
                                  lamaWaktu: '3 Jam',
                                  jam: '19.00 - 21.00',
                                  suketLembur:
                                      'Surat Lembur No. 123/LR.01/04/2025',
                                  imagePath: _selectedImagePath,
                                  onDetail: () {
                                    if (_selectedImagePath == null) {
                                      Navigator.pushNamed(
                                        context,
                                        '/surat_tugas_lembur',
                                      );
                                    } else {
                                      Navigator.pop(context);
                                    }
                                  },
                                ),
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
        ),
      ),
    );
  }
}

class MonthCard extends StatelessWidget {
  final String label;
  final String monthNum;
  final bool isSelected;
  final VoidCallback onTap;

  const MonthCard({
    super.key,
    required this.label,
    required this.monthNum,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color base = isSelected
        ? const Color(0xFFEFF4A8)
        : const Color(0xFFFFFFFF).withValues(alpha: 0.35);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 65,
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
                fontSize: 14,
                color: Color(0xFF373643),
              ),
            ),
            const Spacer(),
            Text(
              monthNum,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 14,
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
  final String? imagePath;
  final String tanggal, title, lamaWaktu, jam, suketLembur;
  final VoidCallback onDetail;

  const _LemburItem({
    required this.tanggal,
    required this.title,
    required this.lamaWaktu,
    required this.jam,
    required this.suketLembur,
    required this.onDetail,
    this.imagePath,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasImage =
        imagePath != null &&
        imagePath!.isNotEmpty &&
        File(imagePath!).existsSync();

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
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: hasImage
                      ? const Color(0xFF76FF63)
                      : const Color(0xFFEDF6B0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  hasImage ? 'SELESAI' : 'Belum Dimulai',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
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

          const SizedBox(height: 4),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                suketLembur,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              InkWell(
                onTap: onDetail,
                borderRadius: BorderRadius.circular(20),
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(
                    Icons.arrow_forward,
                    size: 24,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
