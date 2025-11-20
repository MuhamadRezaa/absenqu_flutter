import 'package:absenqu_flutter/widgets/header_date_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SuratTugasLembur extends StatefulWidget {
  const SuratTugasLembur({super.key});

  @override
  State<SuratTugasLembur> createState() => _SuratTugasLemburState();
}

class _SuratTugasLemburState extends State<SuratTugasLembur> {
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
                height: 197,
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
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 15.0,
                              left: 15.0,
                              right: 15.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Surat Tugas Lembur Anda',
                                  style: TextStyle(
                                    color: Color(0xFF373643),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),

                                const SizedBox(height: 12),

                                _SuratLemburCard(),

                                const SizedBox(height: 20),

                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 15.0,
                                    right: 15.0,
                                  ),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/absenlembur',
                                      );
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 30,
                                        vertical: 14,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Color(
                                          0xFFEDF6B0,
                                        ), // warna kapsul
                                        borderRadius: BorderRadius.circular(
                                          20,
                                        ), // bentuk kapsul
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Absen Lembur',
                                          style: const TextStyle(
                                            color: Color(0xFF373643),
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
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

class _SuratLemburCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/images/surat_tugas_lembur.png',
                fit: BoxFit.contain,
                width: 400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
