// lib/absen_masuk_page.dart
import 'dart:io';

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'absen_masuk_selfie.dart';


class AbsenMasukPage extends StatefulWidget {
  const AbsenMasukPage({super.key});

  @override
  State<AbsenMasukPage> createState() => _AbsenMasukPageState();
}

class _AbsenMasukPageState extends State<AbsenMasukPage> {
  bool _locationPermissionGranted = false;
  File? _pickedImage;

  // warna gradient di-sampling dari gambar (aproksimasi)
  final Color _gradTop = const Color(0xFF93F9F4); // cyan atas
  final Color _gradBottom = const Color(0xFF96B7B5); // abu-hijau bawah

  // warna kartu hari (kuning aktif dan kartu lain)
  final Color _dayActive = const Color(0xFFFFF9AA);
  final Color _dayInactive = const Color(0x55FFFFFF);

  // posisi awal map (contoh: kantor / kota) — untuk flutter_map
  final LatLng _initialLocation = const LatLng(-6.914744, 107.609810);

  @override
  void initState() {
    super.initState();
    _askPermissions();
  }

  Future<void> _askPermissions() async {
    // request location and camera permission
    final locStatus = await Permission.location.request();
    final camStatus = await Permission.camera.request();

    setState(() {
      _locationPermissionGranted = locStatus.isGranted;
    });

    // Show simple message if camera denied (we still allow pressing but will ask again)
    if (!camStatus.isGranted) {
      // do nothing here; image picker will request permission when used
    }
  }

  Future<void> _openCamera() async {
    final picker = ImagePicker();
    try {
      final XFile? photo = await picker.pickImage(source: ImageSource.camera, imageQuality: 85);
      if (photo != null) {
        final File photoFile = File(photo.path);
        // Navigasi ke layar Selfie untuk preview dan simpan foto
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AbsenMasukSelfieScreen(fotoSelfie: photoFile),
          ),
        );
      }
    } catch (e) {
      // ignore / optionally show snackbar
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal membuka kamera')));
    }
  }

  Widget _dashedBorder({required Widget child, EdgeInsetsGeometry? padding}) {
    // Simple dashed border using a CustomPaint
    return CustomPaint(
      painter: _DashedRectPainter(),
      child: Padding(padding: padding ?? const EdgeInsets.all(8.0), child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ukuran responsif berdasarkan lebar layar
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_gradTop, _gradBottom],
            stops: const [0.12, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // status bar row (time + icons)
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

                  // tanggal | hari | jam
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // kiri (tanggal & hijri)
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
                      // kanan jam & arrow back
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('07.35 WIB', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14)),
                          const SizedBox(height: 8),
                          GestureDetector(
                              onTap: () => Navigator.of(context).maybePop(),
                              child: const Icon(Icons.arrow_back, size: 20)),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // subtitle Today, Senin
                  Text('Today, Senin', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500)),

                  const SizedBox(height: 18),

                  // row hari horizontal
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
                        const SizedBox(width: 10),
                        _dayTile('Sabtu', '6', color: Colors.pink.shade200),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  // card area (rounded top-left decoration mimic)
                  Container(
                    width: double.infinity,
                    // height: 420,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Stack(
                        children: [
                          // the curved top-right circle decoration (to mimic design)
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
                                Text('Yuk, Absensi Sekarang',
                                    style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),

                                const SizedBox(height: 12),

                                // dashed box "Ambil Foto Anda" (tappable)
                                GestureDetector(
                                  onTap: _openCamera,
                                  child: _dashedBorder(
                                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.arrow_forward, size: 18),
                                        const SizedBox(width: 8),
                                        const Icon(Icons.image, size: 18),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text('Ambil Foto Anda',
                                              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
                                        ),
                                        const Icon(Icons.camera_alt_outlined),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // jika ada preview foto, tampilkan
                                if (_pickedImage != null) ...[
                                  Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.file(
                                        _pickedImage!,
                                        width: w * 0.84,
                                        height: 160,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                ],

                                // dashed box dengan maps di dalam
                                _dashedBorder(
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width: double.infinity,
                                        height: 160,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: FlutterMap(
                                            options: MapOptions(
                                              initialCenter: _initialLocation,
                                              initialZoom: 15.0,
                                            ),
                                            children: [
                                              TileLayer(
                                                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                                userAgentPackageName: 'com.example.app',
                                              ),
                                              MarkerLayer(
                                                markers: [
                                                  Marker(
                                                    point: _initialLocation,
                                                    child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text('Anda Berada Pada Lokasi Kantor',
                                          style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ],
                      ),
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

  Widget _dayTile(String day, String number, {bool active = false, Color? color}) {
    final bg = active ? _dayActive : (color ?? _dayInactive);
    return Container(
      width: 92,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(day, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Text(number, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
      ]),
    );
  }
}

/// Simple dashed rectangle painter used to mimic dotted border in the design.
class _DashedRectPainter extends CustomPainter {
  final Paint _paint = Paint()
    ..color = Colors.black38
    ..strokeWidth = 1
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 6.0;
    const dashSpace = 6.0;
    final double width = size.width;
    final double height = size.height;

    // Draw dashed lines for all 4 sides
    _drawDashedLine(canvas, const Offset(0, 0), Offset(width, 0), dashWidth, dashSpace); // Top
    _drawDashedLine(canvas, Offset(width, 0), Offset(width, height), dashWidth, dashSpace); // Right
    _drawDashedLine(canvas, Offset(width, height), Offset(0, height), dashWidth, dashSpace); // Bottom
    _drawDashedLine(canvas, Offset(0, height), const Offset(0, 0), dashWidth, dashSpace); // Left
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, double dashWidth, double dashSpace) {
    final paint = _paint;
    double distance = 0.0;
    final totalDistance = (end - start).distance;
    final normalizedOffset = (end - start) / totalDistance;

    while (distance < totalDistance) {
      final startPoint = start + normalizedOffset * distance;
      final endPoint = start + normalizedOffset * (distance + dashWidth);
      canvas.drawLine(startPoint, endPoint, paint);
      distance += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}