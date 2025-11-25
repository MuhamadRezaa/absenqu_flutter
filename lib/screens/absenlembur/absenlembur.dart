import 'dart:math' as math;
import 'dart:io';
import 'package:absenqu_flutter/screens/absenlembur/cam_absenlembur.dart';
import 'package:absenqu_flutter/widgets/header_date_time.dart';
import 'package:absenqu_flutter/widgets/lokasi_map_test.dart';
import 'package:flutter/material.dart';

class Absenlembur extends StatefulWidget {
  const Absenlembur({super.key});

  @override
  State<Absenlembur> createState() => _AbsenlemburState();
}

class _AbsenlemburState extends State<Absenlembur> {
  int _selectedDayIndex = 0;
  String? _pickedImagePath;
  final List<Map<String, String>> _weekDays = const [
    {"label": "Senin", "num": "1"},
    {"label": "Selasa", "num": "2"},
    {"label": "Rabu", "num": "3"},
    {"label": "Kamis", "num": "4"},
    {"label": "Jumat", "num": "5"},
  ];

  @override
  Widget build(BuildContext context) {
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

                          const SizedBox(height: 10),

                          if (_pickedImagePath == null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Anda Belum Melakukan Absensi Masuk',
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
                                return DayCard(
                                  label: d['label']!,
                                  dayNum: d['num']!,
                                  isSelected: _selectedDayIndex == index,
                                  onTap: () =>
                                      setState(() => _selectedDayIndex = index),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    Expanded(
                      child: BottomActionPanel(
                        pickedImagePath: _pickedImagePath,
                        onDeleteImage: () {
                          if (mounted) setState(() => _pickedImagePath = null);
                        },
                        onBtnDashTap: () async {
                          final result = await Navigator.push<String>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CamAbsenLembur(),
                            ),
                          );

                          if (result != null && mounted) {
                            setState(() {
                              _pickedImagePath = result;
                            });
                          }
                        },
                        child: ImgBorderDash(
                          imagePath: _pickedImagePath,
                          onDelete: () {
                            if (mounted) {
                              setState(() => _pickedImagePath = null);
                            }
                          },
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

class BottomActionPanel extends StatelessWidget {
  final Widget child;
  final String? pickedImagePath;
  final VoidCallback? onDeleteImage;
  final VoidCallback? onBtnDashTap;

  const BottomActionPanel({
    super.key,
    required this.child,
    this.pickedImagePath,
    this.onDeleteImage,
    this.onBtnDashTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(topRight: Radius.circular(100)),
        color: Color(0x40D9D9D9),
        boxShadow: [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 10,
            offset: Offset(0, -6),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              const Text(
                'Yuk, Absensi Sekarang',
                style: TextStyle(
                  color: Color(0xFF181818),
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 20),

              if (pickedImagePath == null)
                BtnDash(
                  height: 52,
                  borderColor: Colors.black,
                  onTap: onBtnDashTap,
                )
              else
                child,

              const SizedBox(height: 20),

              if (pickedImagePath == null)
                RepaintBoundary(
                  child: CustomPaint(
                    painter: DashedBorderPainter(
                      color: Colors.black87,
                      strokeWidth: 4,
                      dashWidth: 14,
                      dashSpace: 10,
                      radius: 20,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 5,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: SizedBox(
                                      height: 191,
                                      width: double.infinity,
                                      // Ganti child di bawah dengan widget map (GoogleMap/Facebook) bila sudah integrasi
                                      /*child: Image.network(
                                  'https://maps.googleapis.com/maps/api/staticmap?center=0,0&zoom=15&size=600x400&key=YOUR_KEY',
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: Colors.grey.shade200,
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.map,
                                      size: 48,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),*/
                                      child: LokasiMapTest(),
                                    ),
                                  ),
                                ),

                                const Text(
                                  'Anda Berada Pada Lokasi Kantor',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 12),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 12),
              if (pickedImagePath != null)
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/detail_absenlembur',
                      arguments: pickedImagePath,
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFFEAD9FF),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Kirim Absensi',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImgBorderDash extends StatelessWidget {
  final String? imagePath;
  final VoidCallback? onDelete;
  const ImgBorderDash({super.key, this.imagePath, this.onDelete});

  @override
  Widget build(BuildContext context) {
    if (imagePath != null) {
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
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    'Anda Berada Dilokasi Kantor',
                    style: TextStyle(
                      color: Color(0xFF373643),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
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
                SizedBox(height: 10),
                GestureDetector(
                  onTap: onDelete,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete_outline, color: Colors.red),
                      SizedBox(width: 6),
                      Text(
                        'Hapus gambar',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    // Kalau belum ada gambar -> tampilkan dashed placeholder (original)
    return RepaintBoundary(
      child: CustomPaint(
        painter: DashedBorderPainter(
          color: Colors.black87,
          strokeWidth: 4,
          dashWidth: 14,
          dashSpace: 10,
          radius: 20,
        ),
        child: SizedBox(
          height: 72,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.arrow_forward, size: 26),
                SizedBox(width: 10),
                Text(
                  'Ambil Foto Anda',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double radius;

  DashedBorderPainter({
    this.color = Colors.black,
    this.strokeWidth = 2.0,
    this.dashWidth = 12.0,
    this.dashSpace = 8.0,
    this.radius = 20.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final double inset = strokeWidth / 2;
    final Rect rect = Rect.fromLTWH(
      inset,
      inset,
      size.width - inset * 2,
      size.height - inset * 2,
    );

    final RRect rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    final Path fullPath = Path()..addRRect(rrect);

    // convert path into dashed segments
    final Path dashed = Path();
    for (final pm in fullPath.computeMetrics()) {
      double distance = 0.0;
      while (distance < pm.length) {
        final double len = math.min(dashWidth, pm.length - distance);
        final Path segment = pm.extractPath(distance, distance + len);
        dashed.addPath(segment, Offset.zero);
        distance += dashWidth + dashSpace;
      }
    }

    canvas.drawPath(dashed, paint);
  }

  @override
  bool shouldRepaint(covariant DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashSpace != dashSpace ||
        oldDelegate.radius != radius;
  }
}

class BtnDash extends StatelessWidget {
  final double? width;
  final double? height;
  final Color borderColor;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double radius;
  final VoidCallback? onTap;

  const BtnDash({
    super.key,
    this.width,
    this.height,
    this.borderColor = Colors.black87,
    this.strokeWidth = 2,
    this.dashWidth = 12,
    this.dashSpace = 8,
    this.radius = 16,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(radius),
        onTap: onTap,
        child: RepaintBoundary(
          child: CustomPaint(
            painter: DashedBorderPainter(
              color: borderColor,
              strokeWidth: strokeWidth,
              dashWidth: dashWidth,
              dashSpace: dashSpace,
              radius: radius,
            ),
            child: SizedBox(
              width: width ?? double.infinity,
              height: height ?? 56,
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Panah kiri
                    const Icon(Icons.arrow_forward, size: 22),

                    const SizedBox(width: 8),

                    // Ikon gambar kecil dengan border hijau
                    SizedBox(
                      width: 28,
                      height: 28,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Icon(
                          Icons.image,
                          size: 16,
                          color: Colors.green.shade800,
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Teks tombol
                    Text(
                      'Ambil Foto Anda',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: borderColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DayCard extends StatelessWidget {
  final String label;
  final String dayNum;
  final bool isSelected;
  final VoidCallback onTap;

  const DayCard({
    super.key,
    required this.label,
    required this.dayNum,
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
