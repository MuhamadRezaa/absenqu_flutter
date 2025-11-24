import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:intl/intl.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:absenqu_flutter/widgets/day_card.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

import 'package:absenqu_flutter/screens/absen_pulang/camera_screen.dart';

class AbsenPulangScreen extends StatefulWidget {
  const AbsenPulangScreen({super.key});

  @override
  State<AbsenPulangScreen> createState() => _AbsenPulangScreenState();
}

class _AbsenPulangScreenState extends State<AbsenPulangScreen> {
  DateTime selectedDay = DateTime.now();
  final Map<DateTime, bool> doneDays = {};
  bool _showForm = false;
  String? _capturedPhotoPath;
  bool _showConfirmation = false;
  bool _showSuccess = false;
  
  // Real-time location tracking
  Position? _currentPosition;
  late StreamSubscription<Position> _positionStreamSubscription;
  bool _isLocationLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDoneDays();
    _startLocationTracking();
  }

  @override
  void dispose() {
    _positionStreamSubscription.cancel();
    super.dispose();
  }

  void _startLocationTracking() {
    // Request location permission and start tracking
    _requestLocationPermission().then((granted) {
      if (granted) {
        const LocationSettings locationSettings = LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10, // Update every 10 meters
        );
        
        _positionStreamSubscription = Geolocator.getPositionStream(
          locationSettings: locationSettings,
        ).listen((Position position) {
          setState(() {
            _currentPosition = position;
            _isLocationLoading = false;
          });
        });
      } else {
        setState(() {
          _isLocationLoading = false;
        });
      }
    });
  }

  Future<bool> _requestLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the 
      // App to enable the location services.
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale 
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately. 
      return false;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: _Design.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header section with transparent background - always visible
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: _CustomHeader(
                  selectedDay: selectedDay,
                  statusMessage: _showSuccess 
                      ? 'Terima Kasih, Sudah Bekerja Hari Ini' 
                      : (_showConfirmation 
                          ? 'Anda Belum Melakukan Absensi Pulang' 
                          : null),
                ),
              ),
              const SizedBox(height: 20),
              
              // Day selector - always visible
              _WeekSelector(
                selected: selectedDay,
                doneDays: doneDays,
                onSelected: (d) {
                  setState(() {
                    selectedDay = d;
                    // Reset all form states when changing day
                    _showForm = false;
                    _showConfirmation = false;
                    _showSuccess = false; // Reset success state when changing day
                  });
                },
              ),
              const SizedBox(height: 16),
              
              // Content area with smooth fade transition
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
                  child: _showSuccess ? _SuccessContent(
                    capturedPhotoPath: _capturedPhotoPath,
                    currentPosition: _currentPosition,
                    isLocationLoading: _isLocationLoading,
                  ) : (_showForm ? (_showConfirmation ? _buildConfirmationContent() : _buildFormContent()) : _buildContentBasedOnDate()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentBasedOnDate() {
    // Check if selected day is today
    final now = DateTime.now();
    final isToday = selectedDay.year == now.year && 
                    selectedDay.month == now.month && 
                    selectedDay.day == now.day;
    final key = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
    if (doneDays[key] == true) {
      return _SuccessContent(
        capturedPhotoPath: _capturedPhotoPath,
        currentPosition: _currentPosition,
        isLocationLoading: _isLocationLoading,
      );
    }
    
    if (!isToday) {
      return _buildNonTodayContent();
    }
    
    return _buildInitialContent();
  }

  Widget _buildInitialContent() {
    return SingleChildScrollView(
      key: const ValueKey('initial'),
      child: Column(
        children: [
          const _AvatarStatusSection(),
          const SizedBox(height: 4),
          _PrimaryCta(text: 'Yuk Absen', onTap: _onAbsen),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildNonTodayContent() {
    return SingleChildScrollView(
      key: const ValueKey('nonToday'),
      child: Column(
        children: [
          _AvatarStatusSection(
            imageAsset: 'assets/images/woman.png',
            statusText: 'Upss, Maaf Hari ini Belum Waktunya Anda Melakukan Absensi Ya....',
            avatarWidth: 240,
            avatarHeight: 260,
          ),
        ],
      ),
    );
  }

  Widget _buildFormContent() {
    return SingleChildScrollView(
      key: const ValueKey('form'),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.8), // Solid white with opacity for better visibility
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Yuk, Absensi Sekarang',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 20),
            _PhotoCaptureCard(onPhotoTaken: _onPhotoTaken),
            const SizedBox(height: 20),
            _LocationMapCard(
              currentPosition: _currentPosition,
              isLocationLoading: _isLocationLoading,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _onAbsen() {
    setState(() {
      _showForm = true;
    });
  }

  Widget _buildConfirmationContent() {
    return SingleChildScrollView(
      key: const ValueKey('confirmation'),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Yuk, Absensi Pulang Sekarang',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                // Location map card (left side)
                Expanded(
                  child: _buildLocationMapCard(),
                ),
                const SizedBox(width: 16),
                // Photo preview card (right side)
                Expanded(
                  child: _buildPhotoPreviewCard(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSubmitButton(),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoPreviewCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Photo preview
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: _capturedPhotoPath != null
                ? Image.file(
                    File(_capturedPhotoPath!),
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 120,
                    color: Colors.grey[200],
                    child: const Icon(Icons.person, size: 60, color: Colors.grey),
                  ),
          ),
          // Delete button
          Padding(
            padding: const EdgeInsets.all(12),
            child: GestureDetector(
              onTap: _deletePhoto,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.delete_outline, size: 20, color: Colors.orange),
                  const SizedBox(width: 6),
                  Text(
                    'Hapus gambar',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.orange[700],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationMapCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Map preview
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: SizedBox(
              height: 120,
              width: double.infinity,
              child: _isLocationLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : FlutterMap(
                      options: MapOptions(
                        initialCenter: _currentPosition != null
                            ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
                            : LatLng(-6.200000, 106.816666),
                        initialZoom: 16,
                        interactionOptions: const InteractionOptions(flags: InteractiveFlag.none),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.absenqu_flutter',
                        ),
                        if (_currentPosition != null)
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                                width: 30,
                                height: 30,
                                child: const Icon(
                                  Icons.location_on,
                                  color: Colors.red,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
            ),
          ),
          // Location text
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              _currentPosition != null
                  ? 'Lokasi: ${_currentPosition!.latitude.toStringAsFixed(4)}, ${_currentPosition!.longitude.toStringAsFixed(4)}'
                  : 'Anda Berada Di Lokasi Kantor',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return GestureDetector(
      onTap: _submitAttendance,
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
          'Kirim Absensi',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ),
    );
  }

  void _deletePhoto() {
    setState(() {
      _capturedPhotoPath = null;
      _showConfirmation = false;
      _showForm = false;
    });
  }

  void _submitAttendance() {
    // Handle attendance submission
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Absensi berhasil dikirim!')),
    );
    
    // Show success screen instead of resetting
    setState(() {
      _showSuccess = true;
      _showConfirmation = false;
      _showForm = false;
      // Mark current day as done
      final key = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
      doneDays[key] = true;
    });
    _persistDoneDays();
  }

  Future<void> _onPhotoTaken() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CameraScreen()),
    );
    
    if (result != null && mounted) {
      setState(() {
        _capturedPhotoPath = result;
        _showConfirmation = true;
      });
    }
  }

  Future<File> _doneDaysFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}${Platform.pathSeparator}absen_done_days.json');
  }

  Future<void> _persistDoneDays() async {
    try {
      final file = await _doneDaysFile();
      final dates = doneDays.entries
          .where((e) => e.value)
          .map((e) => '${e.key.year.toString().padLeft(4, '0')}-${e.key.month.toString().padLeft(2, '0')}-${e.key.day.toString().padLeft(2, '0')}')
          .toList();
      await file.writeAsString(jsonEncode(dates), flush: true);
    } catch (_) {}
  }

  Future<void> _loadDoneDays() async {
    try {
      final file = await _doneDaysFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        final List<dynamic> dates = jsonDecode(content);
        for (final d in dates) {
          if (d is String) {
            final parts = d.split('-');
            if (parts.length == 3) {
              final y = int.parse(parts[0]);
              final m = int.parse(parts[1]);
              final da = int.parse(parts[2]);
              doneDays[DateTime(y, m, da)] = true;
            }
          }
        }
        setState(() {});
      }
    } catch (_) {}
  }
}

// Helper function untuk mendapatkan nama bulan Hijriah yang pendek
String _getShortHijriMonthName(HijriCalendar hijriCalendar) {
  final monthNames = {
    1: 'Muharram',
    2: 'Safar',
    3: 'Rabi Awwal',
    4: 'Rabi Akhir',
    5: 'Jumada Awwal',
    6: 'Jumada Akhir',
    7: 'Rajab',
    8: 'Syaban',
    9: 'Ramadhan',
    10: 'Syawal',
    11: 'Dzul Qaidah',
    12: 'Dzul Hijjah',
  };
  
  int month = hijriCalendar.hMonth;
  String fullName = hijriCalendar.getLongMonthName();
  
  // Untuk bulan yang panjang namanya, gunakan versi pendek
  if (month == 5) return 'Jumada Awwal'; // Jumada Al-Awwal
  if (month == 6) return 'Jumada Akhir'; // Jumada Al-Akhir
  
  // Jika nama panjang mengandung "Al-", pertimbangkan untuk mempersingkat
  if (fullName.contains('Al-Awwal')) return 'Awwal';
  if (fullName.contains('Al-Akhir')) return 'Akhir';
  
  return monthNames[month] ?? fullName.split(' ').last; // Ambil kata terakhir jika tidak ada di mapping
}

class _CustomHeader extends StatefulWidget {
  final String? statusMessage;
  final DateTime selectedDay;
  const _CustomHeader({this.statusMessage, required this.selectedDay});

  @override
  State<_CustomHeader> createState() => _CustomHeaderState();
}

class _CustomHeaderState extends State<_CustomHeader> {
  String _timeString = DateFormat('HH:mm', 'id_ID').format(DateTime.now());
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _timeString = DateFormat('HH:mm', 'id_ID').format(DateTime.now());
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayDate = widget.selectedDay;
    final tanggalBulan = DateFormat('d MMMM', 'id_ID').format(displayDate);
    final tahun = DateFormat('yyyy', 'id_ID').format(displayDate);
    final hari = DateFormat('EEEE', 'id_ID').format(displayDate);
    
    // Hijri calendar - convert display date to hijri
    final hijriCalendar = HijriCalendar.fromDate(displayDate);
    final hijriDate = '${hijriCalendar.hDay} ${hijriCalendar.getLongMonthName()} ${hijriCalendar.hYear} H';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  // Gregorian date
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tanggalBulan,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      Text(
                        tahun,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  // Divider
                  Container(
                    width: 1,
                    height: 40,
                    color: const Color(0xFF1A1A1A).withValues(alpha: 0.3),
                  ),
                  const SizedBox(width: 12),
                  // Hijri date - dengan layout yang lebih fleksibel
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Baris pertama: tanggal dan bulan
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '${hijriCalendar.hDay} ',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                              TextSpan(
                                text: _getShortHijriMonthName(hijriCalendar),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                            ],
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        // Baris kedua: tahun
                        Text(
                          '${hijriCalendar.hYear} H',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Today, $hari',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              if (widget.statusMessage != null) ...[
                const SizedBox(height: 8),
                Text(
                  widget.statusMessage!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _timeString,
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
                    color: Color(0xFF373643),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.location_on,
                    size: 24,
                    color: Color(0xFF373643),
                  ),
                  tooltip: 'Lokasi',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 40,
                    color: Color(0xFF373643),
                  ),
                  tooltip: 'Kembali',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}


class _WeekSelector extends StatelessWidget {
  final DateTime selected;
  final Map<DateTime, bool> doneDays;
  final ValueChanged<DateTime> onSelected;
  const _WeekSelector({
    required this.selected,
    required this.doneDays,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final start = selected.subtract(Duration(days: selected.weekday - 1));
    // Show only 5 days (Monday to Friday)
    final days = List.generate(5, (i) => start.add(Duration(days: i)));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 120,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: days.map((day) {
              final isSelected =
                  day.year == selected.year &&
                  day.month == selected.month &&
                  day.day == selected.day;
              final isDone = doneDays[DateTime(day.year, day.month, day.day)] ?? false;
              
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: DayCard(
                  label: _dayShort(day.weekday),
                  dayNum: '${day.day}',
                  isSelected: isSelected,
                  onTap: () => onSelected(day),
                  selectedColor: isDone ? const Color(0xFF4CAF50) : const Color(0xFFFFF9C4), // Green for completed, yellow for selected
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String text;
  const _StatusPill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Color(0xFFBFC3CC), // Medium gray with slight bluish tint
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x20000000),
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF1A1A1A),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
    );
  }
}

class _PrimaryCta extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  const _PrimaryCta({required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: _Design.ctaBg,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        height: 64,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF1A1A1A),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _AvatarStatusSection extends StatelessWidget {
  final String imageAsset;
  final String statusText;
  final double avatarWidth;
  final double avatarHeight;
  const _AvatarStatusSection({
    this.imageAsset = 'assets/images/Rectangle 1.png',
    this.statusText = 'Anda Belum Melakukan Absensi Pulang',
    this.avatarWidth = 220,
    this.avatarHeight = 230,
  });

  @override
  Widget build(BuildContext context) {
    const double statusHeight = 64;
    const double statusBottom = 18;
    return SizedBox(
      height: statusHeight + avatarHeight + statusBottom,
      child: Stack(
        children: [
          Positioned(
            right: 0,
            bottom: statusHeight,
            child: SizedBox(
              width: avatarWidth,
              height: avatarHeight,
              child: Image(
                image: AssetImage(imageAsset),
                fit: BoxFit.contain,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: statusBottom,
            child: _StatusPill(
              text: statusText,
            ),
          ),
        ],
      ),
    );
  }
}

 

String _dayShort(int weekday) {
  const labels = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];
  return labels[weekday - 1];
}

class _PhotoCaptureCard extends StatelessWidget {
  final VoidCallback? onPhotoTaken;
  const _PhotoCaptureCard({this.onPhotoTaken});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPhotoTaken,
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          dashPattern: const [8, 8],
          strokeWidth: 2,
          radius: const Radius.circular(12),
          color: Color(0xFF1A1A1A),
          padding: const EdgeInsets.all(0),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.transparent, // Transparent to show blue background
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.arrow_right_alt, size: 30, color: Color(0xFF1A1A1A)),
              const SizedBox(width: 12),
              const Icon(Icons.image_outlined, size: 26, color: Color(0xFF1A1A1A)),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Ambil Foto Anda',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
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

class _LocationMapCard extends StatefulWidget {
  final Position? currentPosition;
  final bool isLocationLoading;
  
  const _LocationMapCard({this.currentPosition, this.isLocationLoading = false});

  @override
  State<_LocationMapCard> createState() => _LocationMapCardState();
}

class _LocationMapCardState extends State<_LocationMapCard> {
  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        dashPattern: const [8, 8],
        strokeWidth: 2,
        radius: const Radius.circular(12),
        color: Color(0xFF1A1A1A),
        padding: const EdgeInsets.all(0),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1), // Very light white with transparency
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                height: 226,
                child: widget.isLocationLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : FlutterMap(
                        options: MapOptions(
                          initialCenter: widget.currentPosition != null
                              ? LatLng(widget.currentPosition!.latitude, widget.currentPosition!.longitude)
                              : LatLng(-6.200000, 106.816666),
                          initialZoom: 16,
                          interactionOptions: const InteractionOptions(flags: InteractiveFlag.none),
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.absenqu_flutter',
                          ),
                          if (widget.currentPosition != null)
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: LatLng(widget.currentPosition!.latitude, widget.currentPosition!.longitude),
                                  width: 40,
                                  height: 40,
                                  child: const Icon(
                                    Icons.location_on,
                                    color: Colors.red,
                                    size: 40,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.currentPosition != null
                  ? 'Lokasi Anda: ${widget.currentPosition!.latitude.toStringAsFixed(6)}, ${widget.currentPosition!.longitude.toStringAsFixed(6)}'
                  : 'Anda Berada Pada Lokasi Kantor',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// no standalone route; form ditampilkan inline dengan AnimatedSwitcher

class _SuccessContent extends StatefulWidget {
  final String? capturedPhotoPath;
  final Position? currentPosition;
  final bool isLocationLoading;
  
  const _SuccessContent({
    this.capturedPhotoPath, 
    this.currentPosition, 
    this.isLocationLoading = false,
  });

  @override
  State<_SuccessContent> createState() => _SuccessContentState();
}

class _SuccessContentState extends State<_SuccessContent> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: const ValueKey('success'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            // Portrait image and quote section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Portrait image - Rectangle 1 asset (left side)
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20, right: 16),
                    child: const Image(
                      image: AssetImage('assets/images/Rectangle 1.png'),
                      fit: BoxFit.contain,
                      height: 200,
                    ),
                  ),
                ),
                
                // Inspirational quote section (right side) - tanpa card
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Quotes Anda Hari Ini:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Bekerja Lah Ikhlas Tuntas Dan Jadikan\nHari ini Lebih Baik Dari Esok Hari',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1A1A1A),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Attendance summary card
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Top row: Name and Points
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Sandy Pratama',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const Text(
                        'Nilai Poin',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Middle row: Time and Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '17.35',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      const Text(
                        'SESUAI',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const Text(
                        '10',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Bottom row: Location
                  const Text(
                    'Lokasi : Jalan Ringroad Komplek OCBC Toko Cabang Ringroad',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ),

            // Map and Photo section
            Row(
              children: [
                // Map preview
                Expanded(
                  child: Container(
                    height: 120,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: widget.isLocationLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : FlutterMap(
                              options: MapOptions(
                                initialCenter: widget.currentPosition != null
                                    ? LatLng(widget.currentPosition!.latitude, widget.currentPosition!.longitude)
                                    : LatLng(-6.200000, 106.816666),
                                initialZoom: 16,
                                interactionOptions: const InteractionOptions(flags: InteractiveFlag.none),
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  userAgentPackageName: 'com.example.absenqu_flutter',
                                ),
                                if (widget.currentPosition != null)
                                  MarkerLayer(
                                    markers: [
                                      Marker(
                                        point: LatLng(widget.currentPosition!.latitude, widget.currentPosition!.longitude),
                                        width: 25,
                                        height: 25,
                                        child: const Icon(
                                          Icons.location_on,
                                          color: Colors.red,
                                          size: 25,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                    ),
                  ),
                ),
                // Photo preview
                Expanded(
                  child: Container(
                    height: 120,
                    margin: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: widget.capturedPhotoPath != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(widget.capturedPhotoPath!),
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          )
                        : const Center(
                            child: Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.grey,
                            ),
                          ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _Design {
  static const Color gradientTop = Color(0xFF7FA5E3); // Medium sky-blue (top)
  static const Color gradientMiddle = Color(0xFF9FB7EE); // Muted light blue (middle)
  static const Color gradientBottom = Color(0xFFD6DBE4); // Very light bluish-gray (bottom)
  static const Color ctaBg = Color(0xFFEEE8F6); // Light pastel lilac for CTA button

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [gradientTop, gradientMiddle, gradientBottom],
    stops: [0.0, 0.5, 1.0],
  );
}
