import 'dart:typed_data';

class OlahragaChallengeData {
  final String kategori; // contoh: "Olahraga"
  final String jenis; // contoh: "Lari Pagi"
  final String keterangan; // contoh: "5 Km"
  final Duration durasi; // contoh: 35 menit
  final Uint8List? selfie;
  final Uint8List? tracking;
  final double? latitude;
  final double? longitude;

  const OlahragaChallengeData({
    required this.kategori,
    required this.jenis,
    required this.keterangan,
    required this.durasi,
    this.selfie,
    this.tracking,
    this.latitude,
    this.longitude,
  });
}

class OlahragaChallengeValidator {
  static String? validate(OlahragaChallengeData data) {
    if (data.jenis.trim().isEmpty) return 'Jenis olahraga wajib diisi';
    if (data.keterangan.trim().isEmpty) return 'Keterangan wajib diisi';
    if (data.durasi.inMinutes <= 0) return 'Durasi harus lebih dari 0 menit';
    if (data.selfie == null) return 'Selfie wajib diunggah';
    final hasTrackingPhoto = data.tracking != null;
    final hasCompleteGps = data.latitude != null && data.longitude != null;
    if (!hasTrackingPhoto && !hasCompleteGps) return 'Lengkapi lokasi: foto lokasi atau GPS';
    if ((data.latitude != null && data.longitude == null) || (data.latitude == null && data.longitude != null)) return 'Koordinat lokasi tidak lengkap';
    return null;
  }
}