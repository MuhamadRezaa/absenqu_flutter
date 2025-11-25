import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:absenqu_flutter/screens/reimburse/reimburse_process_page.dart';
import 'dart:typed_data';
import 'package:absenqu_flutter/utils/date_time_labels.dart';
import 'package:hijri/hijri_calendar.dart';
import 'dart:async';

class ReimburseFormScreen extends StatefulWidget {
  const ReimburseFormScreen({super.key});

  @override
  State<ReimburseFormScreen> createState() => _ReimburseFormScreenState();
}

class _ReimburseFormScreenState extends State<ReimburseFormScreen> {
  final TextEditingController categoryCtrl = TextEditingController();
  final TextEditingController amountCtrl = TextEditingController();
  final TextEditingController accountCtrl = TextEditingController();
  final TextEditingController bankCtrl = TextEditingController();
  final TextEditingController detailCtrl = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<Uint8List> _images = [];
  late DateTime _now;
  Timer? _timer;

  Future<void> _pickImages() async {
    try {
      final files = await _picker.pickMultiImage(imageQuality: 85);
      if (files.isEmpty) return;
      final bytesList = await Future.wait(files.map((x) => x.readAsBytes()));
      setState(() {
        final combined = <Uint8List>[..._images, ...bytesList];
        _images = combined.length <= 2
            ? combined
            : combined.sublist(combined.length - 2); // simpan 2 terbaru
      });
    } catch (_) {
      // swallow errors silently for now
    }
  }

  void _clearImages() {
    setState(() {
      _images.clear();
    });
  }

  bool _canSubmit() {
    return _images.isNotEmpty &&
        categoryCtrl.text.trim().isNotEmpty &&
        amountCtrl.text.trim().isNotEmpty &&
        accountCtrl.text.trim().isNotEmpty &&
        bankCtrl.text.trim().isNotEmpty &&
        detailCtrl.text.trim().isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    categoryCtrl.dispose();
    amountCtrl.dispose();
    accountCtrl.dispose();
    bankCtrl.dispose();
    detailCtrl.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF95E9E4), Color(0xFF9FA9A7)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      _HeaderItem(label: IndoDateTimeLabels.tanggalPanjang(_now)),
                                      const SizedBox(width: 12),
                                      const _HeaderDivider(),
                                      const SizedBox(width: 12),
                                      _HeaderItem(label: '${HijriCalendar.fromDate(_now).hDay} ${HijriCalendar.fromDate(_now).longMonthName}\n${HijriCalendar.fromDate(_now).hYear} H'),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Today, ${IndoDateTimeLabels.hari(_now)}',
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                _HeaderItem(label: IndoDateTimeLabels.jamWIB(_now)),
                                IconButton(
                                  icon: const Icon(Icons.arrow_back, size: 20),
                                  color: Colors.black87,
                                  padding: const EdgeInsets.only(top: 6),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const _DaySelector(),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFA5EEE9), Color(0xFF8FA7A5)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Center(
                              child: Text(
                                'Ajukan Tagihan Reimburs Anda',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            GestureDetector(
                              onTap: () async {
                                try {
                                  final file = await _picker.pickImage(
                                    source: ImageSource.camera,
                                    imageQuality: 85,
                                    preferredCameraDevice: CameraDevice.rear,
                                  );
                                  if (file == null) return;
                                  final bytes = await file.readAsBytes();
                                  setState(() {
                                    final combined = <Uint8List>[..._images, bytes];
                                    _images = combined.length <= 2
                                        ? combined
                                        : combined.sublist(combined.length - 2);
                                  });
                                } catch (_) {}
                              },
                              child: _UploadBox(images: _images),
                            ),
                            const SizedBox(height: 8),
                            Center(
                              child: Column(
                                children: [
                                  if (_images.isEmpty)
                                    const Text(
                                      'Ambil Bukti Foto Dokumen / Bill / Kwitansi / Tagihan',
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                    ),
                                  if (_images.isNotEmpty)
                                    GestureDetector(
                                      onTap: _clearImages,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Icon(Icons.delete_outline, color: Color(0xFF3D6E63), size: 18),
                                          SizedBox(width: 6),
                                          Text('Hapus gambar', style: TextStyle(color: Color(0xFF3D6E63), fontSize: 12, fontWeight: FontWeight.w600)),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            const _Label('Kategori Reimburs'),
                            _InputField(controller: categoryCtrl, hint: 'Kategori Reimburs', onChanged: (_) => setState(() {})),
                            const SizedBox(height: 10),
                            const _Label('Jumlah Nominal'),
                            _InputField(controller: amountCtrl, hint: 'Jumlah Nominal', keyboardType: TextInputType.number, onChanged: (_) => setState(() {})),
                            const SizedBox(height: 10),
                            const _Label('Nomor Rekening'),
                            _InputField(controller: accountCtrl, hint: 'Nomor Rekening', onChanged: (_) => setState(() {})),
                            const SizedBox(height: 10),
                            const _Label('Nama Bank'),
                            _InputField(controller: bankCtrl, hint: 'Nama Bank', onChanged: (_) => setState(() {})),
                            const SizedBox(height: 10),
                            const _Label('Rincian Reimburs'),
                            _InputField(controller: detailCtrl, hint: 'Rincian Reimburs', maxLines: 3, onChanged: (_) => setState(() {})),
                            const SizedBox(height: 16),
                            if (_canSubmit()) _SubmitButton(onPressed: () async {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Pengajuan dikirim!')),
                              );
                              await Future.delayed(const Duration(milliseconds: 300));
                              if (!mounted) return;
                              final category = categoryCtrl.text.trim();
                              final amountText = amountCtrl.text.trim();
                              final parsedAmount = int.tryParse(amountText.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
                              Navigator.of(context).push(
                                _slideFadeRoute(ReimburseProcessPage(category: category, amount: parsedAmount)),
                              );
                            }),
                          ],
                        ),
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
}

Route _slideFadeRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final offsetTween = Tween<Offset>(begin: const Offset(0.0, 0.06), end: Offset.zero)
          .chain(CurveTween(curve: Curves.easeOutCubic));
      final fadeTween = Tween<double>(begin: 0.0, end: 1.0)
          .chain(CurveTween(curve: Curves.easeOut));
      return FadeTransition(
        opacity: animation.drive(fadeTween),
        child: SlideTransition(position: animation.drive(offsetTween), child: child),
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
    );
  }
}

class _HeaderItem extends StatelessWidget {
  const _HeaderItem({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      textAlign: TextAlign.left,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }
}

class _HeaderDivider extends StatelessWidget {
  const _HeaderDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.5,
      height: 36,
      color: Colors.black.withOpacity(0.35),
    );
  }
}

class _DaySelector extends StatelessWidget {
  const _DaySelector();

  @override
  Widget build(BuildContext context) {
    final days = const ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat'];
    final nums = const ['1', '2', '3', '4', '5'];

    // Hitung index hari (Senin=0). Jika weekend, default ke Senin.
    // Selaraskan dengan reimburse_screen: sorot hari pertama (Senin)
    int selectedIndex = 0;

    return Padding(
      // Ikuti padding header (sudah 20 di parent), jadi 0 di sini
      padding: const EdgeInsets.only(left: 0, right: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            for (var i = 0; i < days.length; i++) ...[
              _DayChip(
                label: days[i],
                number: nums[i],
                selected: i == selectedIndex,
              ),
              if (i != days.length - 1) const SizedBox(width: 12),
            ]
          ],
        ),
      ),
    );
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({
    required this.label,
    required this.number,
    this.selected = false,
  });

  final String label;
  final String number;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final bg = selected ? const Color(0xFFF5EFAF) : const Color(0xFFE0F7F5);
    final border = selected ? Colors.transparent : Colors.black12;
    return Container(
      width: 76,
      height: 96,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                )
              ]
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            number,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.maxLines = 1,
    this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final int maxLines;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              maxLines: maxLines,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hint,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, size: 18),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _UploadBox extends StatelessWidget {
  const _UploadBox({required this.images});
  final List<Uint8List> images;

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return Container(
        width: double.infinity,
        height: 160,
        decoration: ShapeDecoration(
          color: Colors.white.withOpacity(0.22),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: CustomPaint(
          painter: _DashedPainter(),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.arrow_right_alt, color: Color(0xFF3D6E63), size: 28),
                SizedBox(width: 8),
                Icon(Icons.image_outlined, color: Color(0xFF3D6E63), size: 24),
              ],
            ),
          ),
        ),
      );
    }

    final previews = images.take(2).toList();
    return SizedBox(
      height: 160,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (final bytes in previews)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.memory(bytes, width: 140, height: 140, fit: BoxFit.cover),
            ),
        ],
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 42,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFA5EEE9),
          foregroundColor: Colors.black87,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        ),
        child: const Text('Klik Disini Untuk Mengajukan'),
      ),
    );
  }
}

class _DashedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 6.0;
    const dashSpace = 4.0;
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(8, 8, size.width - 16, size.height - 16),
      const Radius.circular(16),
    );

    // Draw dashed around rectangle
    final path = Path()..addRRect(rect);
    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final len = dashWidth;
        final next = distance + len;
        final extractPath = metric.extractPath(distance, next);
        canvas.drawPath(extractPath, paint);
        distance = next + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
