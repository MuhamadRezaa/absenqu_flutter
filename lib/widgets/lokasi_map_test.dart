import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class LokasiMapTest extends StatefulWidget {
  const LokasiMapTest({super.key});

  @override
  State<LokasiMapTest> createState() => _LokasiMapTestState();
}

class _LokasiMapTestState extends State<LokasiMapTest> {
  final MapController _mapController = MapController();
  LatLng? _currentLocation;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      // cek apakah GPS (location service) aktif
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        setState(() => _loading = false);
        return;
      }

      // minta/cek permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _loading = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // user menolak selamanya
        setState(() => _loading = false);
        return;
      }

      // ambil posisi terakhir/terbaru
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentLocation = LatLng(pos.latitude, pos.longitude);
        _loading = false;
      });

      // pindahkan kamera kalau map controller sudah siap
      if (_currentLocation != null) {
        _mapController.move(_currentLocation!, 16);
      }
    } catch (e) {
      // log error, jangan crash UI
      debugPrint('Error mendapatkan lokasi: $e');
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_currentLocation == null) {
      return const Center(child: Text("Lokasi tidak ditemukan"));
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: 226,
        width: double.infinity,
        child: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _currentLocation!,
            initialZoom: 16,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.absenqu_flutter',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: _currentLocation!,
                  width: 60,
                  height: 60,
                  child: const Icon(
                    Icons.location_pin,
                    size: 50,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
