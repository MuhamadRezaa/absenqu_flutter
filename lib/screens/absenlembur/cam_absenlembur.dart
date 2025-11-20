import 'package:image/image.dart' as img;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:absenqu_flutter/widgets/header_date_time.dart';

class CamAbsenLembur extends StatefulWidget {
  const CamAbsenLembur({super.key});

  @override
  State<CamAbsenLembur> createState() => _CamAbsenLemburState();
}

class _CamAbsenLemburState extends State<CamAbsenLembur>
    with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  XFile? _lastPicture;
  bool _isInit = true;
  bool _isTaking = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      final cam = _cameras!.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras!.first,
      );
      _controller = CameraController(
        cam,
        ResolutionPreset.high,
        enableAudio: false,
      );
      await _controller!.initialize();
    } catch (e) {
      debugPrint('camera init error: $e');
    } finally {
      if (mounted) setState(() => _isInit = false);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final c = _controller;
    if (c == null || !c.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      c.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized || _isTaking)
      return;
    setState(() => _isTaking = true);

    try {
      final xfile = await _controller!.takePicture();

      // hanya flip kalau kamera depan
      if (_controller!.description.lensDirection == CameraLensDirection.front) {
        final file = File(xfile.path);
        final bytes = await file.readAsBytes();

        final decoded = img.decodeImage(bytes);
        if (decoded != null) {
          final flipped = img.flipHorizontal(decoded);
          final outBytes = img.encodeJpg(flipped, quality: 90);
          await file.writeAsBytes(outBytes);
        }
      }

      setState(() => _lastPicture = xfile); // XFile tetap pakai path yg sama
    } catch (e) {
      debugPrint('takePicture error: $e');
    } finally {
      setState(() => _isTaking = false);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          HeaderDateTime(),
                          SizedBox(height: 25),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Center(
                      child: Text(
                        'Selfie Sekarang',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // PREVIEW AREA
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Container(
                            width: double.infinity,
                            color: Colors.black,
                            child:
                                _isInit ||
                                    _controller == null ||
                                    !_controller!.value.isInitialized
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : AspectRatio(
                                    aspectRatio: _controller!.value.aspectRatio,
                                    child: Stack(
                                      children: [
                                        Positioned.fill(
                                          child: _lastPicture != null
                                              ? Image.file(
                                                  File(_lastPicture!.path),
                                                  fit: BoxFit.cover,
                                                )
                                              : CameraPreview(_controller!),
                                        ),
                                        // overlay corners (non-interactive)
                                        const Positioned.fill(
                                          child: IgnorePointer(
                                            child: _CornerOverlay(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Kontrol tombol
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _lastPicture == null
                                      ? _takePicture
                                      : () => Navigator.pop(
                                          context,
                                          _lastPicture!.path,
                                        ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFEAD9FF),
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    _lastPicture == null
                                        ? 'Ambil Foto'
                                        : 'Simpan & Gunakan',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (_lastPicture != null)
                                TextButton(
                                  onPressed: () =>
                                      setState(() => _lastPicture = null),
                                  child: const Text('Ambil Ulang'),
                                )
                              else
                                IconButton(
                                  onPressed: _switchCamera,
                                  icon: const Icon(Icons.cameraswitch),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
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

  Future<void> _switchCamera() async {
    if (_cameras == null || _cameras!.length < 2) return;
    final current = _controller!.description;
    final newCam = _cameras!.firstWhere(
      (c) => c.name != current.name,
      orElse: () => _cameras!.first,
    );
    await _controller?.dispose();
    _controller = CameraController(
      newCam,
      ResolutionPreset.high,
      enableAudio: false,
    );
    await _controller!.initialize();
    if (mounted) setState(() {});
  }
}

class _CornerOverlay extends StatelessWidget {
  const _CornerOverlay({super.key});
  @override
  Widget build(BuildContext context) => CustomPaint(painter: _CornerPainter());
}

class _CornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white.withValues(alpha: 0.9)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    const len = 36.0;
    const pad = 12.0;
    // top-left
    canvas.drawLine(Offset(pad, pad), Offset(pad + len, pad), p);
    canvas.drawLine(Offset(pad, pad), Offset(pad, pad + len), p);
    // top-right
    canvas.drawLine(
      Offset(size.width - pad, pad),
      Offset(size.width - pad - len, pad),
      p,
    );
    canvas.drawLine(
      Offset(size.width - pad, pad),
      Offset(size.width - pad, pad + len),
      p,
    );
    // bottom-left
    canvas.drawLine(
      Offset(pad, size.height - pad),
      Offset(pad + len, size.height - pad),
      p,
    );
    canvas.drawLine(
      Offset(pad, size.height - pad),
      Offset(pad, size.height - pad - len),
      p,
    );
    // bottom-right
    canvas.drawLine(
      Offset(size.width - pad, size.height - pad),
      Offset(size.width - pad - len, size.height - pad),
      p,
    );
    canvas.drawLine(
      Offset(size.width - pad, size.height - pad),
      Offset(size.width - pad, size.height - pad - len),
      p,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
