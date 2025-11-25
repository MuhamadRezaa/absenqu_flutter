import 'package:absenqu_flutter/widgets/day_card.dart';
import 'package:absenqu_flutter/widgets/header_date_time.dart';
import 'package:flutter/material.dart';

class AjukanIzin extends StatefulWidget {
  const AjukanIzin({super.key});

  @override
  State<AjukanIzin> createState() => _AjukanIzinState();
}

class _AjukanIzinState extends State<AjukanIzin> {
  // ===== List kotak hari (Senin–Jumat) =====
  int _selectedDayIndex = 0;
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
                final w = constraints.maxWidth;
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
                    Container(
                      height: h * 0.25,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 40.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 3,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Transform.translate(
                                  offset: const Offset(10, 0),
                                  child: Image.asset(
                                    'assets/images/batuk.png',
                                    fit: BoxFit.contain,
                                    width: w * 0.35,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: w * 0.02,
                            ), // spasi antar gambar & teks
                            Expanded(
                              flex: 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Selalu Jaga Kesehatan, Olahraga dan Istirahat Yang Cukup.',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF373643),
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Expanded(
                      child: BottomActionPanel(
                        onAjukan: () {
                          Navigator.pushNamed(context, '/form_ajukanizin');
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
  const BottomActionPanel({super.key, required this.onAjukan});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // Panel penuh ke bawah, radius hanya di ATAS
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        // abu-abu lembut + sedikit transparan biar nyatu dg background
        color: Color(0x40D9D9D9),
        boxShadow: [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 20,
            offset: Offset(0, -8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === Tombol pil "Ajukan Izin" ===
            Center(
              child: GestureDetector(
                onTap: onAjukan,
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 520),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF93FFFA),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 14,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'Ajukan Izin',
                      style: TextStyle(
                        color: Color(0xFF373643),
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 18),

            // === Kuota Izin ===
            const Center(
              child: Text(
                'Kuota Izin Anda Bulan Ini 3 Hari',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF181818),
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(height: 22),

            // === Judul Riwayat ===
            const Text(
              'Riwayat Izin Anda',
              style: TextStyle(
                color: Color(0xFF181818),
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 12),

            // === Item riwayat berbentuk kapsul ===
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: 1, // bisa diganti jumlah dinamis
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) => _RiwayatItem(
                  title: 'Izin Sakit | Diajukan Tanggal 1 Maret 2025',
                  waktu: 'Waktu 1 Maret – 3 Maret 2025',
                  lama: 'Lama izin 3 Hari',
                  status: 'Diterima',
                  onDetail: () {
                    // TODO: buka detail
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RiwayatItem extends StatelessWidget {
  final String title, waktu, lama, status;
  final VoidCallback onDetail;
  const _RiwayatItem({
    required this.title,
    required this.waktu,
    required this.lama,
    required this.status,
    required this.onDetail,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Kiri: info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF373643),
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  waktu,
                  style: const TextStyle(
                    color: Color(0xFF4A4A4A),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  lama,
                  style: const TextStyle(
                    color: Color(0xFF4A4A4A),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          // Kanan: status + panah
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                status,
                style: const TextStyle(
                  color: Color(0xFF373643),
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: onDetail,
                borderRadius: BorderRadius.circular(20),
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Lihat Detail',
                        style: TextStyle(
                          color: Color(0xFF373643),
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward,
                        size: 24,
                        color: Color(0xFF373643),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
