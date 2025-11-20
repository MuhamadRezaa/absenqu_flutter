import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'absen_invalid_page.dart';


class AfterAbsenPage extends StatelessWidget {
  final String nama;
  final String waktu;
  final String status;
  final int poin;
  final String lokasi;
  final String quotes;
  final ImageProvider selfieImage;
  final String mapPosition;

  const AfterAbsenPage({
    super.key,
    required this.nama,
    required this.waktu,
    required this.status,
    required this.poin,
    required this.lokasi,
    required this.quotes,
    required this.selfieImage,
    required this.mapPosition,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF93FFFA), Color(0xFF999999)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("01 April 2025", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 4),
                          Text("1 Syawal 1446 H", style: GoogleFonts.poppins(fontSize: 13)),
                        ],
                      ),
                      Column(
                        children: [
                          Text("07.35 WIB", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 6),
                          GestureDetector(onTap: () => Navigator.of(context).maybePop(), child: const Icon(Icons.arrow_back)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Today, Senin', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text('Terima Kasih,  Sudah Hadir Hari Ini', style: GoogleFonts.poppins(fontSize: 12)),

                  const SizedBox(height: 14),

                  // Day tiles
                  SizedBox(
                    height: 78,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                       _dayBox('Senin', '1', true, context),
                      const SizedBox(width: 12),
                      _dayBox('Selasa', '2', false, context),
                      const SizedBox(width: 12),
                      _dayBox('Rabu', '3', false, context),
                      const SizedBox(width: 12),
                      _dayBox('Kamis', '4', false, context),
                      const SizedBox(width: 12),
                     _dayBox('Jumat', '5', false, context),

                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Icon kiri + Quotes kanan
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon sebelah kiri
                      Container(
                        width: w * 0.35,
                        height: 170,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/icon.png'),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: Offset(0,4))],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Quotes sebelah kanan
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Quotes Anda Hari Ini :', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12)),
                            const SizedBox(height: 6),
                            Text('Bekerja Lah Ikhlas Tuntas Dan Jadikan Hari ini Lebih Baik Dari Esok Hari', style: GoogleFonts.poppins(fontSize: 11)),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // White pill with name/time/status/points
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: Offset(0,4))],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(nama, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            Row(children: [Text(waktu, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)), const SizedBox(width: 8), Text(status, style: GoogleFonts.poppins(color: Colors.black54))]),
                            const SizedBox(height: 6),
                            Text(lokasi, style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54)),
                          ]),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                          decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(12)),
                          child: Column(children: [Text('Nilai Poin', style: GoogleFonts.poppins(fontSize: 12)), const SizedBox(height: 4), Text(poin.toString(), style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700))]),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Card with selfie + map
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        Expanded(
                          child: ClipRRect(borderRadius: BorderRadius.circular(12), child: Image(image: selfieImage, fit: BoxFit.cover, height: 140)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.asset('assets/images/maps.png', fit: BoxFit.cover, height: 140)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

   Widget _dayBox(String day, String number, bool active, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!active) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AbsenInvalidPage()),
          );
        }
      },
      child: Container(
        width: 92,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF9CF68A) : const Color(0xFFE8FBFB),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(day, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13)),
            const SizedBox(height: 6),
            Text(number, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}