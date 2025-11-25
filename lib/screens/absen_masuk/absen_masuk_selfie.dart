import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'absen_masuk_selesai.dart';

class AbsenMasukSelfieScreen extends StatelessWidget {
  final File fotoSelfie;

  const AbsenMasukSelfieScreen({super.key, required this.fotoSelfie});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF93FFFA), Color(0xFF999999)],
            stops: [0.12, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status bar row (time + icons)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('9:41', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
                      Row(
                        children: const [
                          Icon(Icons.signal_cellular_4_bar_rounded, size: 16),
                          SizedBox(width: 6),
                          Icon(Icons.wifi, size: 16),
                          SizedBox(width: 6),
                          Icon(Icons.battery_full, size: 16),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Tanggal, hari, jam
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('01 April 2025', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14)),
                            const SizedBox(height: 6),
                            Text('1 Syawal 1446 H', style: GoogleFonts.poppins(fontSize: 13)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('07.35 WIB', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14)),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () => Navigator.of(context).maybePop(),
                            child: const Icon(Icons.arrow_back, size: 20),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Subtitle "Today, Senin"
                  Text('Today, Senin', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500)),

                  const SizedBox(height: 32),

                  // Label "Selfie Sekarang"
                  Center(
                    child: Text('Selfie Sekarang',
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),

                  const SizedBox(height: 24),

                  // Foto preview
                  Center(
                    child: Container(
                      width: w * 0.75,
                      height: 380,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: FileImage(fotoSelfie),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Tombol "Simpan Foto"
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        // Navigasi ke absen_masuk_selesai_screen dengan membawa foto
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AbsenMasukSelesaiPage(fotoSelfie: fotoSelfie),
                          ),
                        );
                      },
                      child: Container(
                        width: w * 0.6,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF93FFFA),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            )
                          ],
                        ),
                        child: Center(
                          child: Text('Simpan Foto',
                              style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
