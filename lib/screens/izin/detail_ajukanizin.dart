import 'dart:math' as math;
import 'dart:io';
import 'package:absenqu_flutter/screens/izin/cam_ajukanizin.dart';
import 'package:absenqu_flutter/widgets/lokasi_map_test.dart';
import 'package:flutter/material.dart';
import 'package:absenqu_flutter/widgets/header_date_time.dart';
import 'package:absenqu_flutter/widgets/day_card.dart';

class DetailAjukanIzin extends StatefulWidget {
  const DetailAjukanIzin({super.key});

  @override
  State<DetailAjukanIzin> createState() => _DetailAjukanIzinState();
}

class _DetailAjukanIzinState extends State<DetailAjukanIzin> {
  int _selectedDayIndex = 0;
  String? _pickedImagePath;
  bool _argumentsProcessed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_argumentsProcessed) {
      final imagePath = ModalRoute.of(context)?.settings.arguments as String?;
      if (imagePath != null) {
        setState(() {
          _pickedImagePath = imagePath;
        });
      }
      _argumentsProcessed = true;
    }
  }

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
                  colors: [Color(0xFF93FFFA), Color(0xFF999999)],
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

                          const SizedBox(height: 40),

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
                    const SizedBox(height: 20),

                    Expanded(
                      child: BottomActionPanel(
                        onAjukan: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Form izin belum dibuat 🙂'),
                            ),
                          );
                        },
                        pickedImagePath: _pickedImagePath,
                        onDeleteImage: () {
                          if (mounted) setState(() => _pickedImagePath = null);
                        },
                        child: ImgBorderDash(
                          imagePath: _pickedImagePath,
                          onDelete: () {
                            if (mounted) {
                              setState(() => _pickedImagePath = null);
                            }
                          },
                        ),
                        onImageTap: () async {
                          final result = await Navigator.push<String>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CamAjukanIzin(),
                            ),
                          );

                          if (result != null && mounted) {
                            setState(() {
                              _pickedImagePath =
                                  result; // simpan path foto ke state
                            });
                          }
                        },
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
  final VoidCallback onAjukan;
  final Widget child;
  final VoidCallback onImageTap;
  final String? pickedImagePath;
  final VoidCallback? onDeleteImage;

  const BottomActionPanel({
    super.key,
    required this.onAjukan,
    required this.child,
    required this.onImageTap,
    this.pickedImagePath,
    this.onDeleteImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        color: Color(0x40D9D9D9),
        boxShadow: [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 20,
            offset: Offset(0, -8),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Ajukan Izin Anda',
                  style: TextStyle(
                    color: Color(0xFF181818),
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // KIRI: kotak foto (ambil bukti)
                    Flexible(
                      flex: 48,
                      child: Column(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: onImageTap,
                              child: child,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // ubah teks di bawah gambar sesuai kondisi
                          if (child is ImgBorderDash &&
                              (child as ImgBorderDash).imagePath != null)
                            SizedBox.shrink()
                          else
                            const Text(
                              'Ambil Bukti Foto',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Flexible(
                      flex: 52,
                      child: Column(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: SizedBox(
                                height: 226,
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

                          const SizedBox(height: 8),
                          const Text(
                            'Lokasi Anda Saat Ini',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              BtnDash(height: 52, borderColor: Colors.black),

              const SizedBox(height: 6),

              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    _TanggalCard(label: 'Mulai', tanggal: 'Senin, 1 Maret'),
                    SizedBox(width: 8),
                    _TanggalCard(label: 'Akhir', tanggal: 'Rabu, 3 Maret'),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFF93FFFA),
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
                  child: Text(
                    '3 Hari',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Soon...')));
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
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
                          'Izin Sakit',
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

              const SizedBox(height: 8),
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
      // tampilkan gambar + tombol hapus di bawahnya
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Gambar dengan sudut membulat
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              height: 226,
              width: double.infinity,
              child: Image.file(
                File(imagePath!),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _placeholderDashed(),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Tombol hapus (ikon + teks), tampilkan hanya kalau callback tersedia
          if (onDelete != null)
            GestureDetector(
              onTap: onDelete,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: Colors.red.shade400,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Hapus gambar',
                    style: TextStyle(
                      color: Colors.red.shade400,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      );
    }
    // Kalau belum ada gambar -> tampilkan dashed placeholder (original)
    return _placeholderDashed();
  }

  Widget _placeholderDashed() {
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
          height: 226, // sesuaikan tinggi kotak seperti yg Anda mau
          width: double.infinity,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.arrow_forward, size: 36), // panah
                const SizedBox(width: 8),
                // ikon gambar
                Container(
                  width: 44,
                  height: 44,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Icon(
                      Icons.image,
                      size: 20,
                      color: Colors.green.shade800,
                    ),
                  ),
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
                      'Upload Surat Sakit',
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

class _TanggalCard extends StatelessWidget {
  final String label;
  final String tanggal;

  const _TanggalCard({super.key, required this.label, required this.tanggal});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Center(
              child: Text(
                tanggal,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
