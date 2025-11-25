import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'absen_masuk_setelah_selesai.dart';

class AbsenMasukSelesaiPage extends StatefulWidget {
  final File? fotoSelfie; // diterima dari halaman sebelumnya

  const AbsenMasukSelesaiPage({super.key, this.fotoSelfie});

  @override
  State<AbsenMasukSelesaiPage> createState() => _AbsenMasukSelesaiPageState();
}

class _AbsenMasukSelesaiPageState extends State<AbsenMasukSelesaiPage> {
  final TextEditingController _quoteController = TextEditingController();

  final String _lokasiKantor = '-6.200000, 106.816666'; // Jakarta contoh

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
             Color(0xFF93FFFA), Color(0xFF999999)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header tanggal dan waktu
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("01 April 2025",
                              style: GoogleFonts.poppins(
                                  fontSize: 13, fontWeight: FontWeight.w600)),
                          Text("1 Syawal 1446 H",
                              style: GoogleFonts.poppins(
                                  fontSize: 13, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          Text("Today, Senin",
                              style: GoogleFonts.poppins(
                                  fontSize: 12, fontWeight: FontWeight.w400)),
                        ],
                      ),
                      Column(
                        children: [
                          Text("07.35 WIB",
                              style: GoogleFonts.poppins(
                                  fontSize: 13, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(Icons.arrow_back),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Row day tiles
                  SizedBox(
                    height: 80,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _dayTile('Senin', '1', active: true),
                        const SizedBox(width: 10),
                        _dayTile('Selasa', '2'),
                        const SizedBox(width: 10),
                        _dayTile('Rabu', '3'),
                        const SizedBox(width: 10),
                        _dayTile('Kamis', '4'),
                        const SizedBox(width: 10),
                        _dayTile('Jumat', '5'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),

                  // Card "Yuk Absen Masuk"
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Stack(
                        children: [
                          Positioned(
                            right: -40,
                            top: -30,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(60),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Yuk Absen Masuk.',
                                    style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600)),

                                const SizedBox(height: 12),

                                // Row Map + Foto
                                Row(
                                  children: [
                                    // MAP (left side)
                                    Expanded(
                                      child: Container(
                                        height: 150,
                                        margin: const EdgeInsets.only(right: 12),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          color: Colors.grey.shade200,
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                          child: Image.asset(
                                            'assets/images/maps.png',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // FOTO SELFIE (right side)
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 150,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15),
                                              color: Colors.grey.shade200,
                                              image: DecorationImage(
                                                image: widget.fotoSelfie != null
                                                    ? FileImage(widget.fotoSelfie!) as ImageProvider
                                                    : const AssetImage('assets/images/selfie.png'),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          GestureDetector(
                                            onTap: () {},
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                const Icon(Icons.delete_outline, color: Colors.red, size: 18),
                                                const SizedBox(width: 6),
                                                Text('Hapus gambar',
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.red, fontSize: 12, fontWeight: FontWeight.w500)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                // Keterangan lokasi
                                Center(
                                  child: Text('Anda Berada Dilokasi Kantor',
                                      style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500)),
                                ),

                                const SizedBox(height: 18),

                                // Card nama + quotes (pill-shaped)
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.06),
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      )
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Sandy Pratama',
                                          style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
                                      const SizedBox(height: 6),
                                      Text(
                                        _quoteController.text.isEmpty ? 'Tulis Quots dan Semangat Anda Hari ini' : _quoteController.text,
                                        style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // Tombol "Kirim Absensi"
                                GestureDetector(
                                  onTap: () {
                                    // Navigasi ke halaman setelah absen dengan data contoh
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AfterAbsenPage(
                                          nama: 'Sandy Pratama',
                                          waktu: '07.35 WIB',
                                          status: 'Berhasil',
                                          poin: 10,
                                          lokasi: 'Kantor Pusat',
                                          quotes: _quoteController.text.isEmpty ? 'Tulis Quots dan Semangat Anda Hari ini' : _quoteController.text,
                                          selfieImage: widget.fotoSelfie != null
                                              ? FileImage(widget.fotoSelfie!)
                                              : const AssetImage('assets/images/selfie.png'),
                                          mapPosition: '-6.200000, 106.816666',
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF93FFFA),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.08),
                                          blurRadius: 6,
                                          offset: const Offset(0, 3),
                                        )
                                      ],
                                    ),
                                    child: Center(
                                      child: Text('Kirim Absensi',
                                          style: GoogleFonts.poppins(
                                              fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black)),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _dayTile(String day, String number, {bool active = false}) {
    return Container(
      width: 75,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFFFF9AA) : const Color(0xFFE8FBFB),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
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
    );
  }
}
