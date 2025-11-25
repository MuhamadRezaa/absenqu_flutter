import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' show LatLng;
import '../../utils/date_time_labels.dart';
import 'dart:async';

import 'olahraga_challenge_model.dart';

const String gmapsStaticApiKey = String.fromEnvironment('GMAPS_STATIC_KEY', defaultValue: '');

String _buildStaticMapUrl(double lat, double lng) {
  if (gmapsStaticApiKey.isNotEmpty) {
    final ll = '${lat.toStringAsFixed(6)},${lng.toStringAsFixed(6)}';
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$ll&zoom=16&size=280x160&scale=2&maptype=roadmap&markers=color:red%7C$ll&key=$gmapsStaticApiKey';
  }
  final ll = '${lat.toStringAsFixed(6)},${lng.toStringAsFixed(6)}';
  return 'https://staticmap.openstreetmap.de/staticmap.php?center=$ll&zoom=15&size=280x160&markers=$ll,lightblue1';
}

class OlahragaChallengePage extends StatefulWidget {
  const OlahragaChallengePage({super.key});

  @override
  State<OlahragaChallengePage> createState() => _OlahragaChallengePageState();
}

class _OlahragaChallengePageState extends State<OlahragaChallengePage> {
  final kategoriCtrl = TextEditingController();
  final jenisCtrl = TextEditingController();
  final ketCtrl = TextEditingController();
  final durasiCtrl = TextEditingController();

  List<Uint8List> _images = []; // [0] selfie, [1] lokasi
  double? _latitude;
  double? _longitude;
  bool _saving = false;
  final List<String> _kategoriOptions = const [
    'Berolah Raga',
    'Sholat Berjamaah',
    'Hafalan Quran',
    'Membaca Buku',
  ];
  String? _selectedKategori;

  @override
  void dispose() {
    kategoriCtrl.dispose();
    jenisCtrl.dispose();
    ketCtrl.dispose();
    durasiCtrl.dispose();
    super.dispose();
  }

  Future<void> _captureSelfie() async {
    final bytes = await _openCamera(CameraLensDirection.front);
    if (bytes == null) return;
    setState(() {
      if (_images.isEmpty) {
        _images.add(bytes);
      } else {
        if (_images.length == 1) {
          _images.insert(0, bytes);
        } else {
          _images[0] = bytes;
        }
      }
      if (_images.length > 2) {
        _images = _images.sublist(0, 2);
      }
    });
  }

  Future<void> _captureLokasi() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }
    try {
      final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      setState(() {
        _latitude = pos.latitude;
        _longitude = pos.longitude;
      });
      _showSnack('Lokasi tersimpan');
    } catch (_) {
      _showSnack('Gagal mengambil lokasi', errorColor: true);
    }
  }

  Future<void> _onUploadTap() async {
    if (_images.isEmpty) {
      await _captureSelfie();
      return;
    }
    if (_latitude == null || _longitude == null) {
      await _captureLokasi();
      return;
    }
    _showSnack('Selfie dan lokasi sudah ada');
  }

  void _save() async {
    FocusScope.of(context).unfocus();
    final minutes = int.tryParse(durasiCtrl.text.trim()) ?? 0;
    final data = OlahragaChallengeData(
      kategori: (_selectedKategori ?? kategoriCtrl.text.trim()),
      jenis: jenisCtrl.text.trim(),
      keterangan: ketCtrl.text.trim(),
      durasi: Duration(minutes: minutes),
      selfie: _images.isNotEmpty ? _images.first : null,
      tracking: _images.length > 1 ? _images[1] : null,
      latitude: _latitude,
      longitude: _longitude,
    );

    final error = OlahragaChallengeValidator.validate(data);
    if (error != null) {
      _showSnack(error, errorColor: true);
      return;
    }

    setState(() => _saving = true);
    await Future<void>.delayed(const Duration(milliseconds: 800));
    setState(() => _saving = false);
    // Kembalikan data ke halaman sebelumnya (Challenge)
    if (mounted) {
      Navigator.pop(context, data);
      return;
    }
  }

  void _showSnack(String message, {bool errorColor = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: errorColor ? const Color(0xFFEA5A5A) : const Color(0xFF5ACB85),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<Uint8List?> _openCamera(CameraLensDirection direction) async {
    return await Navigator.push<Uint8List?>(
      context,
      MaterialPageRoute(builder: (_) => CameraCapturePage(direction: direction)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFA5EEE9), Color(0xFF8FA7A5)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _Header(),
                // Konten menyatu dengan header, tanpa lekukan di bagian atas
                Container(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 14),
                          _SelectField(
                            label: 'Kategori Chalange',
                            value: _selectedKategori,
                            options: _kategoriOptions,
                            onChanged: (val) {
                              setState(() {
                                _selectedKategori = val;
                                kategoriCtrl.text = val ?? '';
                              });
                            },
                          ),
                          const SizedBox(height: 10),
                          _InputField(label: 'Jenis Chalange', controller: jenisCtrl),
                          const SizedBox(height: 10),
                          _InputField(label: 'Keterangan', controller: ketCtrl),
                          const SizedBox(height: 10),
                          _InputField(label: 'Durasi Waktu (menit)', controller: durasiCtrl, keyboardType: TextInputType.number),
                          const SizedBox(height: 14),
                          _UploadBox(images: _images, latitude: _latitude, longitude: _longitude, onTapUpload: _onUploadTap),
                          const SizedBox(height: 16),
                          if (!((_images.length >= 2) || (_images.isNotEmpty && _latitude != null && _longitude != null))) const _UploadRules(),
                          const SizedBox(height: 12),
                          if ((_images.isNotEmpty && _latitude != null && _longitude != null) || _images.length >= 2)
                            Center(
                              child: GestureDetector(
                                onTap: _saving ? null : _save,
                                child: Container(
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFBFFEA8),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 3))],
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  alignment: Alignment.center,
                                  child: Text(
                                    _saving ? 'Menyimpan...' : 'Klik Simpan',
                                    style: const TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ),
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
    );
  }
}

class _SelectField extends StatelessWidget {
  const _SelectField({required this.label, required this.value, required this.options, required this.onChanged});
  final String label; final String? value; final List<String> options; final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isDense: true,
                value: value,
                hint: const Text('Pilih...'),
                items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: onChanged,
              ),
            ),
          ]),
        ),
        const SizedBox(width: 8),
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 3))],
          ),
          child: const Icon(Icons.edit, size: 18),
        ),
      ]),
    );
  }
}

class CameraCapturePage extends StatefulWidget {
  const CameraCapturePage({super.key, required this.direction});
  final CameraLensDirection direction;

  @override
  State<CameraCapturePage> createState() => _CameraCapturePageState();
}

class _CameraCapturePageState extends State<CameraCapturePage> {
  CameraController? _controller;
  bool _initializing = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      final cameras = await availableCameras();
      CameraDescription? selected;
      for (final c in cameras) {
        if (c.lensDirection == widget.direction) { selected = c; break; }
      }
      selected ??= cameras.isNotEmpty ? cameras.first : null;
      if (selected == null) {
        setState(() { _error = 'Kamera tidak ditemukan'; _initializing = false; });
        return;
      }
      final controller = CameraController(selected, ResolutionPreset.medium, enableAudio: false);
      await controller.initialize();
      setState(() { _controller = controller; _initializing = false; });
    } catch (e) {
      setState(() { _error = 'Gagal membuka kamera: $e'; _initializing = false; });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _capture() async {
    try {
      if (_controller == null || !_controller!.value.isInitialized) return;
      final XFile file = await _controller!.takePicture();
      final bytes = await file.readAsBytes();
      if (!mounted) return;
      Navigator.pop(context, bytes);
    } catch (e) {
      setState(() { _error = 'Gagal mengambil foto: $e'; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Ambil Foto'),
      ),
      body: Center(
        child: _error != null
            ? Text(_error!, style: const TextStyle(color: Colors.white))
            : (_initializing || _controller == null)
                ? const CircularProgressIndicator(color: Colors.white)
                : AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: CameraPreview(_controller!),
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _capture,
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

class _UploadBox extends StatelessWidget {
  const _UploadBox({required this.images, required this.latitude, required this.longitude, required this.onTapUpload});
  final List<Uint8List> images;
  final double? latitude;
  final double? longitude;
  final VoidCallback onTapUpload;

  @override
  Widget build(BuildContext context) {
    final hasImages = images.isNotEmpty;
    return Column(
      children: [
        GestureDetector(
          onTap: onTapUpload,
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFA5EEE9), Color(0xFF8FA7A5)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              borderRadius: BorderRadius.zero,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 3))],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.zero,
              child: CustomPaint(
                painter: _DashedRectPainter(),
                child: hasImages
                    ? Padding(
                        padding: const EdgeInsets.all(12),
                        child: images.length == 1
                            ? Row(
                                children: [
                                  Expanded(
                                    child: AspectRatio(
                                      aspectRatio: 4 / 3,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.memory(images.first, fit: BoxFit.cover),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  (latitude != null && longitude != null)
                                      ? Expanded(
                                          child: AspectRatio(
                                            aspectRatio: 4 / 3,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(12),
                                              child: FlutterMap(
                                                options: MapOptions(
                                                  initialCenter: LatLng(latitude!, longitude!),
                                                  initialZoom: 16,
                                                  interactionOptions: const InteractionOptions(flags: InteractiveFlag.none),
                                                ),
                                                children: [
                                                  TileLayer(
                                                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                                    userAgentPackageName: 'com.example.absenqu_flutter',
                                                  ),
                                                  MarkerLayer(
                                                    markers: [
                                                      Marker(
                                                        point: LatLng(latitude!, longitude!),
                                                        width: 36,
                                                        height: 36,
                                                        child: const Icon(Icons.location_pin, color: Colors.redAccent, size: 32),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      : GestureDetector(
                                          onTap: onTapUpload,
                                          child: Container(
                                            width: 80,
                                            height: 80,
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.6),
                                              borderRadius: BorderRadius.circular(12),
                                              border: Border.all(color: const Color(0xFF3D6E63).withOpacity(0.6)),
                                            ),
                                            alignment: Alignment.center,
                                            child: const Icon(Icons.add, size: 26, color: Color(0xFF3D6E63)),
                                          ),
                                        ),
                                ],
                              )
                            : GridView.builder(
                                itemCount: images.length,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 8, crossAxisSpacing: 8),
                                itemBuilder: (ctx, i) => ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.memory(images[i], fit: BoxFit.cover),
                                ),
                              ),
                      )
                    : Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.arrow_right_alt, size: 28, color: Color(0xFF3D6E63)),
                            SizedBox(width: 10),
                            Icon(Icons.image, size: 28, color: Color(0xFF3D6E63)),
                          ],
                        ),
                      ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        if (hasImages && latitude != null && longitude != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Ambil Bukti Foto', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              Text('Lokasi Anda Saat Ini', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          )
        else
          const Text(
            'Upload Bukti Chalange',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
      ],
    );
  }
}

class _DashedRectPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(10, 10, size.width - 20, size.height - 20);
    final paint = Paint()
      ..color = const Color(0xFF3D6E63)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;
    const dashWidth = 6.0;
    const dashSpace = 4.0;

    void drawDashedPath(ui.Path source) {
      final ui.Path path = ui.Path();
      for (final metric in source.computeMetrics()) {
        double distance = 0.0;
        while (distance < metric.length) {
          final double next = distance + dashWidth;
          path.addPath(metric.extractPath(distance, next), Offset.zero);
          distance = next + dashSpace;
        }
      }
      canvas.drawPath(path, paint);
    }

    final ui.Path rectPath = ui.Path()..addRect(rect);
    drawDashedPath(rectPath);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _InputField extends StatelessWidget {
  const _InputField({required this.label, required this.controller, this.keyboardType, this.readOnly = false});
  final String label; final TextEditingController controller; final TextInputType? keyboardType; final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            TextField(
              controller: controller,
              keyboardType: keyboardType,
              readOnly: readOnly,
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ]),
        ),
        const SizedBox(width: 8),
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 3))],
          ),
          child: const Icon(Icons.edit, size: 18),
        ),
      ]),
    );
  }
}

class _Header extends StatefulWidget {
  const _Header();
  @override
  State<_Header> createState() => _HeaderState();
}

class _HeaderState extends State<_Header> {
  late DateTime _now;
  Timer? _timer;
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
    _timer?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final tanggal = IndoDateTimeLabels.tanggalPanjang(_now);
    final hari = IndoDateTimeLabels.hari(_now);
    final jam = IndoDateTimeLabels.jamWIB(_now);
    return ClipRRect(
      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(48)),
      child: Container(
        color: const Color(0xFFD9D9D9),
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              _HeaderItem(label: tanggal),
              const SizedBox(width: 12),
              Container(width: 1.5, height: 36, color: Colors.black.withOpacity(0.35)),
              const SizedBox(width: 12),
              _HeaderItem(label: hari),
              const Spacer(),
              _HeaderItem(label: jam),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(hari, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                const Text('Chalange Hari ini', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
              ]),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.arrow_back, size: 22, color: Color(0xFF4A2A2A)),
                onPressed: () {
                  if (Navigator.canPop(context)) Navigator.pop(context);
                },
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

class _HeaderItem extends StatelessWidget {
  const _HeaderItem({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) {
    return Text(label, textAlign: TextAlign.left, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600));
  }
}

class _DaySelector extends StatelessWidget {
  const _DaySelector();
  @override
  Widget build(BuildContext context) {
    final items = const ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    return Row(children: [
      for (var i = 0; i < items.length; i++) ...[
        Container(
          decoration: BoxDecoration(
            color: i == 0 ? const Color(0xFFF5EFAF) : const Color(0xFFE0F7F5),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(items[i], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ),
        if (i != items.length - 1) const SizedBox(width: 8),
      ]
    ]);
  }
}

class _UploadRules extends StatelessWidget {
  const _UploadRules();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('Ketentuan Upload Bukti :', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
        SizedBox(height: 6),
        Text('Maksimal 2 foto: Selfie & Foto Lokasi', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        SizedBox(height: 4),
        Text('1. (satu) Foto Selfie', style: TextStyle(fontSize: 12)),
        Text('2. (satu) Foto Lokasi', style: TextStyle(fontSize: 12)),
      ],
    );
  }
}