import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AbsenInvalidPage extends StatelessWidget {
  const AbsenInvalidPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF93FFFA), Color(0xFF999999)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header tanggal & jam (styled like mockup)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "01 April 2025",
                          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "1 Syawal 1446 H",
                          style: GoogleFonts.poppins(fontSize: 13),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "07.35 WIB",
                          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: () => Navigator.of(context).maybePop(),
                          child: const Icon(Icons.arrow_back),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Today, Senin', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),

                // Day tiles (horizontal) — match mockup
                SizedBox(
                  height: 78,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _dayBox('Senin', '1', false),
                      const SizedBox(width: 12),
                      _dayBox('Selasa', '2', true),
                      const SizedBox(width: 12),
                      _dayBox('Rabu', '3', false),
                      const SizedBox(width: 12),
                      _dayBox('Kamis', '4', false),
                      const SizedBox(width: 12),
                      _dayBox('Jumat', '5', false),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // Illustration (woman) and message box styled to match mockup
                SizedBox(
                  height: 260,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Woman illustration positioned to the right
                      Positioned(
                        right: 0,
                        top: 0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.asset(
                            "assets/images/woman.png",
                            height: 220,
                            width: 220,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      // Message card overlapping to the left-bottom of the image
                      Positioned(
                        left: 8,
                        right: 110,
                        bottom: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xFF93FFFA), Color(0xFF999999)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            // Keep a subtle blue border to match mockup
                            
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF1AA0C2).withOpacity(0.18),
                                blurRadius: 18,
                                offset: const Offset(6, 10),
                              ),
                            ],
                          ),
                          child: Text(
                            "Upss, Maaf Hari ini Belum Waktunya Anda\nMelakukan Absensi Ya....",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dayBox(String day, String number, bool active) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      width: 86,
      height: 78,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(  
        color: active ? const Color(0xFFF7F19A) : const Color(0xFFE8FBFB),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: active ? Colors.black.withOpacity(0.10) : Colors.black.withOpacity(0.02),
            blurRadius: active ? 12 : 6,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Text(
            number,
            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
