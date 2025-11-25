import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:hijri/hijri_calendar.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      // Check camera permission
      final cameraStatus = await Permission.camera.request();
      if (cameraStatus.isDenied || cameraStatus.isPermanentlyDenied) {
        setState(() {
          _errorMessage = 'Izin kamera diperlukan untuk mengambil foto';
          _isLoading = false;
        });
        return;
      }

      // Get available cameras
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        setState(() {
          _errorMessage = 'Tidak ada kamera yang tersedia';
          _isLoading = false;
        });
        return;
      }

      // Initialize camera controller with front camera
      final frontCamera = _cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras.first,
      );

      _controller = CameraController(
        frontCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _controller!.initialize();
      
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal menginisialisasi kamera: $e';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (!_isCameraInitialized || _controller == null) return;

    try {
      final image = await _controller!.takePicture();
      if (mounted) {
        Navigator.pop(context, image.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengambil foto: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF7FA5E3), // Medium sky-blue (top)
              Color(0xFF9FB7EE), // Muted light blue (middle)
              Color(0xFFD6DBE4), // Very light bluish-gray (bottom)
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Absen Pulang',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          DateFormat('HH.mm', 'id_ID').format(DateTime.now()),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'WIB',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Date/Time Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left side - Gregorian date
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat('d MMMM', 'id_ID').format(DateTime.now()),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                            Text(
                              DateFormat('yyyy', 'id_ID').format(DateTime.now()),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 2,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1A1A),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${HijriCalendar.now().hDay} ${HijriCalendar.now().longMonthName}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                            Text(
                              '${HijriCalendar.now().hYear} H',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Back button
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 40,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Subheader
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Today, ${DateFormat('EEEE', 'id_ID').format(DateTime.now())}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Camera preview section
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'Selfie Sekarang',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20), // Same horizontal padding as button
                        child: Center(
                          child: _isLoading
                              ? const CircularProgressIndicator()
                              : _errorMessage != null
                                  ? Text(
                                      _errorMessage!,
                                      style: const TextStyle(color: Colors.white),
                                    )
                                  : _isCameraInitialized
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(20),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              // Camera preview - fill available width
                                              Positioned.fill(
                                                child: CameraPreview(_controller!),
                                              ),
                                              
                                              // Corner brackets
                                              Positioned(
                                                top: 10,
                                                left: 10,
                                                child: _buildCornerBracket(true, true),
                                              ),
                                              Positioned(
                                                top: 10,
                                                right: 10,
                                                child: _buildCornerBracket(true, false),
                                              ),
                                              Positioned(
                                                bottom: 10,
                                                left: 10,
                                                child: _buildCornerBracket(false, true),
                                              ),
                                              Positioned(
                                                bottom: 10,
                                                right: 10,
                                                child: _buildCornerBracket(false, false),
                                              ),
                                            ],
                                          ),
                                        )
                                      : const Text(
                                          'Kamera tidak tersedia',
                                          style: TextStyle(color: Colors.white),
                                        ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Save photo button
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                child: GestureDetector(
                  onTap: _takePicture,
                  child: Container(
                    width: double.infinity,
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEE8F6), // Light pastel lilac
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x12000000),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Simpan Foto',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
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

  Widget _buildCornerBracket(bool isTop, bool isLeft) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        border: Border(
          top: isTop ? const BorderSide(color: Colors.white, width: 3) : BorderSide.none,
          bottom: !isTop ? const BorderSide(color: Colors.white, width: 3) : BorderSide.none,
          left: isLeft ? const BorderSide(color: Colors.white, width: 3) : BorderSide.none,
          right: !isLeft ? const BorderSide(color: Colors.white, width: 3) : BorderSide.none,
        ),
      ),
    );
  }
}