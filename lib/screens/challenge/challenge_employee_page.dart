import 'package:flutter/material.dart';
import 'dart:typed_data';
import '../olahraga/olahraga_challenge_model.dart';
import '../../utils/date_time_labels.dart';
import 'dart:async';

const String gmapsStaticApiKey = String.fromEnvironment('GMAPS_STATIC_KEY', defaultValue: '');
String _staticMapUrl(double lat, double lng) {
  if (gmapsStaticApiKey.isNotEmpty) {
    final ll = '${lat.toStringAsFixed(6)},${lng.toStringAsFixed(6)}';
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$ll&zoom=16&size=280x160&scale=2&maptype=roadmap&markers=color:red%7C$ll&key=$gmapsStaticApiKey';
  }
  final ll = '${lat.toStringAsFixed(6)},${lng.toStringAsFixed(6)}';
  return 'https://staticmap.openstreetmap.de/staticmap.php?center=$ll&zoom=15&size=280x160&markers=$ll,lightblue1';
}

class ChallengeEmployeePage extends StatefulWidget {
  const ChallengeEmployeePage({super.key});

  @override
  State<ChallengeEmployeePage> createState() => _ChallengeEmployeePageState();
}

class _ChallengeEmployeePageState extends State<ChallengeEmployeePage> {
  final GlobalKey<_ChallengeListState> _listKey = GlobalKey<_ChallengeListState>();

  Future<void> _onStartPressed() async {
    final result = await Navigator.of(context).pushNamed('/olahraga');
    if (result is OlahragaChallengeData) {
      _listKey.currentState?.applyOlahragaData(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFA5EEE9), Color(0xFFB7A9CE)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Header(),
              const SizedBox(height: 10),
              const _MonthSelector(),
              const SizedBox(height: 12),
              _TopPills(onStart: _onStartPressed),
              const SizedBox(height: 12),
              Expanded(child: _ChallengeList(key: _listKey)),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapThumb extends StatelessWidget {
  const _MapThumb({required this.latitude, required this.longitude});
  final double latitude; final double longitude;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1.2,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            _staticMapUrl(latitude, longitude),
            fit: BoxFit.cover,
            errorBuilder: (ctx, err, stack) => Container(
              color: Colors.white,
              alignment: Alignment.center,
              child: const Icon(Icons.location_on),
            ),
          ),
        ),
      ),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
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
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, size: 22, color: Color(0xFF4A2A2A)),
              onPressed: () {
                if (Navigator.canPop(context)) Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderItem extends StatelessWidget {
  const _HeaderItem({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) {
    return Text(label, textAlign: TextAlign.left,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600));
  }
}

class _MonthSelector extends StatelessWidget {
  const _MonthSelector();
  @override
  Widget build(BuildContext context) {
    final months = const [
      ('Jan', '1'), ('Feb', '2'), ('Mar', '3'), ('Apr', '4'), ('Mei', '5'),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          for (var i = 0; i < months.length; i++) ...[
            _MonthChip(label: months[i].$1, number: months[i].$2, selected: i == 3),
            if (i != months.length - 1) const SizedBox(width: 12),
          ]
        ]),
      ),
    );
  }
}

class _MonthChip extends StatelessWidget {
  const _MonthChip({required this.label, required this.number, this.selected = false});
  final String label; final String number; final bool selected;
  @override
  Widget build(BuildContext context) {
    final bg = selected ? const Color(0xFFF5EFAF) : const Color(0xFFE0F7F5);
    final border = selected ? Colors.transparent : Colors.black12;
    return Container(
      width: 64, height: 90, padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
        boxShadow: selected ? [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 6, offset: const Offset(0,3))
        ] : null,
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Text(number, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      ]),
    );
  }
}

class _TopPills extends StatelessWidget {
  const _TopPills({this.onStart});
  final VoidCallback? onStart;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        GestureDetector(
          onTap: onStart,
          child: const _Pill(text: 'Klik Mulai', bgColor: Color(0xFFF5EFAF)),
        ),
        const SizedBox(width: 12),
        const _Pill(text: '20 Poin', bgColor: Color(0xFFEFD6F2)),
      ]),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.text, this.bgColor = const Color(0xFFBDEFF0)});
  final String text; final Color bgColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 6, offset: const Offset(0,3))],
      ),
      child: Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
    );
  }
}

class _ChallengeList extends StatefulWidget {
  const _ChallengeList({super.key});
  @override
  State<_ChallengeList> createState() => _ChallengeListState();
}

class _ChallengeListState extends State<_ChallengeList> {
  final items = const [
    ('Berolah Raga', 20, Icons.directions_run),
    ('Sholat Berjamaah', 30, Icons.group),
    ('Hafalan Quran', 30, Icons.menu_book),
    ('Membaca Buku', 15, Icons.book),
  ];

  // Detail per kategori akan terisi setelah user menyimpan form
  final Map<int, Map<String, String>> details = {};

  int? expandedIndex;
  final Map<int, List<Uint8List>> images = {};
  final Map<int, double> latitudes = {};
  final Map<int, double> longitudes = {};

  // Dipanggil ketika form olahraga selesai disimpan
  void applyOlahragaData(OlahragaChallengeData data) {
    setState(() {
      // Tentukan index berdasarkan kategori yang dipilih
      int targetIndex = 0;
      final kategoriLower = data.kategori.toLowerCase();
      for (var i = 0; i < items.length; i++) {
        if (items[i].$1.toLowerCase() == kategoriLower) {
          targetIndex = i; break;
        }
      }
      details[targetIndex] = {
        'date': '01 April 2025',
        'activity': data.jenis,
        'noteTitle': 'Keterangan',
        'keterangan': data.keterangan,
        'waktu': '${data.durasi.inMinutes} menit',
      };
      final list = <Uint8List>[];
      if (data.selfie != null) list.add(data.selfie!);
      if (data.tracking != null) list.add(data.tracking!);
      images[targetIndex] = list;
      if (data.latitude != null && data.longitude != null) {
        latitudes[targetIndex] = data.latitude!;
        longitudes[targetIndex] = data.longitude!;
      }
      expandedIndex = targetIndex; // buka panel sesuai kategori
    });
  }

  // Kamera dinonaktifkan di halaman Challenge. Tidak ada aksi tambah foto di sini.

  void _toggle(int index) {
    setState(() {
      expandedIndex = expandedIndex == index ? null : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 32),
      itemCount: items.length,
      itemBuilder: (ctx, i) {
        final (title, point, icon) = items[i];
        final imgs = images[i] ?? const <Uint8List>[];
        final d = details[i];
        return Padding(
          padding: EdgeInsets.only(top: i == 0 ? 0 : 14),
          child: _ChallengeItem(
            index: i,
            title: title,
            point: point,
            icon: icon,
            isExpanded: expandedIndex == i,
            onToggle: () => _toggle(i),
            images: imgs,
            date: d?['date'],
            activity: d?['activity'],
            noteTitle: d?['noteTitle'],
            noteValue: d?['keterangan'],
            timeValue: d?['waktu'],
            latitude: latitudes[i],
            longitude: longitudes[i],
          ),
        );
      },
    );
  }
}

class _ChallengeItem extends StatelessWidget {
  const _ChallengeItem({
    required this.index,
    required this.title,
    required this.point,
    required this.icon,
    required this.isExpanded,
    required this.onToggle,
    required this.images,
    this.date,
    this.activity,
    this.noteTitle,
    this.noteValue,
    this.timeValue,
    this.latitude,
    this.longitude,
  });
  final int index; final String title; final int point; final IconData icon;
  final bool isExpanded; final VoidCallback onToggle;
  final List<Uint8List> images;
  final String? date; final String? activity; final String? noteTitle; final String? noteValue; final String? timeValue;
  final double? latitude; final double? longitude;
  @override
  Widget build(BuildContext context) {
    void _handleTap() {
      if (title.toLowerCase().contains('berolah raga')) {
        Navigator.of(context).pushNamed('/olahraga');
      }
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        // tinggi dinamis: lebih tinggi saat expanded
        padding: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.92),
          border: Border.all(color: Colors.black.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        constraints: const BoxConstraints(minHeight: 86),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(children: [
                Icon(icon, size: 32, color: Colors.black87),
                const SizedBox(width: 12),
                Expanded(child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700))),
                _PointPill(point: point),
                const SizedBox(width: 12),
                InkWell(
                  onTap: onToggle,
                  child: Container(
                    width: 32, height: 32,
                    decoration: const BoxDecoration(color: Color(0xFFE0E0E0), shape: BoxShape.circle),
                    child: Icon(isExpanded ? Icons.arrow_upward : Icons.arrow_downward, size: 20, color: Colors.black87),
                  ),
                ),
              ]),
            ),
            if (isExpanded) ...[
              const SizedBox(height: 8),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0,3))],
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Container(
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDEDED),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text('Total $point Poin', style: const TextStyle(fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(height: 12),
                  if (date != null && activity != null && noteTitle != null && noteValue != null && timeValue != null)
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Expanded(
                        flex: 6,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(date!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 2),
                          Text(activity!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          Text(noteTitle!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 2),
                          Text(noteValue!, style: const TextStyle(fontSize: 12)),
                          const SizedBox(height: 8),
                          Row(children: [
                            Expanded(child: Text('Poin\n$point', style: const TextStyle(fontSize: 12)) ),
                            Expanded(child: Text('Waktu\n$timeValue', style: const TextStyle(fontSize: 12)) ),
                          ]),
                        ]),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 7,
                        child: Row(children: [
                          _Thumb(images.isNotEmpty ? images[0] : null),
                          const SizedBox(width: 10),
                          if (images.length > 1)
                            _Thumb(images[1])
                          else if (latitude != null && longitude != null)
                            _MapThumb(latitude: latitude!, longitude: longitude!)
                          else
                            _Thumb(null),
                        ]),
                      ),
                    ]),
                ]),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb(this.bytes);
  final Uint8List? bytes;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1.2,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF3D6E63).withOpacity(0.2)),
          ),
          clipBehavior: Clip.antiAlias,
          child: bytes == null
              ? const Center(child: Icon(Icons.image))
              : Image.memory(bytes!, fit: BoxFit.cover),
        ),
      ),
    );
  }
}

class _PointPill extends StatelessWidget {
  const _PointPill({required this.point});
  final int point;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFD0D0D0),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text('$point poin', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
    );
  }
}