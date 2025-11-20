import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Safe wrapper for GoogleFonts.poppins to avoid runtime lookup failures.
TextStyle _safePoppins({double? fontSize, FontWeight? fontWeight}) {
  try {
    return GoogleFonts.poppins(fontSize: fontSize, fontWeight: fontWeight);
  } catch (_) {
    return TextStyle(fontSize: fontSize, fontWeight: fontWeight);
  }
}

class AbsenMasukPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF93FFFA), Color(0xFF999999)],

          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
        Text("9:41",
          style: _safePoppins(fontWeight: FontWeight.w600, fontSize: 18)),
                    Row(children: const [Icon(Icons.signal_cellular_alt), Icon(Icons.wifi), Icon(Icons.battery_full)])
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
              Text("01 April 2025",
                  style: _safePoppins(fontSize: 16, fontWeight: FontWeight.w600)),
                Text("1 Syawal 1446 H",
                  style: _safePoppins(fontSize: 13)),
                        const SizedBox(height: 6),
            Text("Today, Senin",
              style: _safePoppins(fontSize: 13, fontWeight: FontWeight.w500))
                      ],
                    ),
                    Column(
                      children: [
            Text("07.35 WIB",
              style: _safePoppins(fontWeight: FontWeight.w700, fontSize: 16)),
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.arrow_back),
                        )
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 25),
                SizedBox(
                  height: 75,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _dayCard("Senin", "1", true),
                      _dayCard("Selasa", "2", false),
                      _dayCard("Rabu", "3", false),
                      _dayCard("Kamis", "4", false),
                      _dayCard("Jumat", "5", false),
                      _dayCard("Sabtu", "6", false),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Position image to the right
                Row(
                  children: [
                    const Expanded(child: SizedBox()),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Image.asset(
                        "assets/images/icon.png",
                        height: 180,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                        child: Text(
                      "Anda Belum Melakukan Absensi Masuk",
                      style: _safePoppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Color(0xFF8FF6FF),
                      borderRadius: BorderRadius.circular(18),
                    ),
                      child: Center(
                      child: Text(
                        "Yuk Absen",
                        style: _safePoppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dayCard(String day, String date, bool active) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFFFF9AA) : Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(day, style: _safePoppins(fontWeight: FontWeight.w600)),
          Text(date, style: _safePoppins(fontSize: 14)),
        ],
      ),
    );
  }
}
