import 'package:absenqu_flutter/widgets/header_date_time.dart';
import 'package:flutter/material.dart';

class ProsesAjukanIzin extends StatefulWidget {
  const ProsesAjukanIzin({super.key});

  @override
  State<ProsesAjukanIzin> createState() => _ProsesAjukanizinState();
}

class _ProsesAjukanizinState extends State<ProsesAjukanIzin> {
  // ===== List kotak hari (Senin–Jumat) =====
  final List<Map<String, String>> _weekDays = const [
    {"label": "Senin", "num": "1"},
    {"label": "Selasa", "num": "2"},
    {"label": "Rabu", "num": "3"},
    {"label": "Kamis", "num": "4"},
    {"label": "Jumat", "num": "5"},
  ];

  @override
  Widget build(BuildContext context) {
    final imagePath = ModalRoute.of(context)?.settings.arguments as String?;
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

                                // Misalnya Senin–Rabu hijau (selected)
                                final bool isGreen = index <= 2;

                                return DayCard(
                                  label: d['label']!,
                                  dayNum: d['num']!,
                                  isSelected: isGreen, // nonaktifkan tap
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: h * 0.02,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 40.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [],
                        ),
                      ),
                    ),

                    Expanded(
                      child: BottomActionPanel(
                        onAjukan: () {
                          Navigator.pushNamed(context, '/form_ajukanizin');
                        },
                        imagePath: imagePath,
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
  final String? imagePath;
  const BottomActionPanel(
      {super.key, required this.onAjukan, this.imagePath});

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
            Center(
              child: Text(
                'Proses Pengajuan Izin Anda',
                style: TextStyle(
                  color: Color(0xFF181818),
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // === Item riwayat berbentuk kapsul ===
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _RiwayatItem(
                    title: 'Izin Sakit | Diajukan Tanggal 1 Maret 2025',
                    waktu: 'Waktu 1 Maret – 3 Maret 2025',
                    lama: 'Lama izin 3 Hari',
                    onDetail: () {
                      Navigator.pushNamed(context, '/detail_ajukanizin',
                          arguments: imagePath);
                    },
                  ),
                  const SizedBox(height: 12),
                  _PengajuanItem(
                    title: 'Pengajuan',
                    subtitle:
                        'Pengajuan izin anda sedang dalam proses Verifikasi',
                  ),
                  const SizedBox(height: 12),
                  _VerifikasiItem(
                    title: 'Verifikasi',
                    subtitle: 'Izin anda Diterima',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RiwayatItem extends StatelessWidget {
  final String title, waktu, lama;
  final VoidCallback onDetail;
  const _RiwayatItem({
    required this.title,
    required this.waktu,
    required this.lama,
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
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.center, // biar angka dan isi sejajar vertikal
        children: [
          // angka di kiri (bisa dibungkus Container kalau mau lingkaran)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '1',
                style: const TextStyle(
                  color: Color(0xFF373643),
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),

          // bagian tengah (judul + detail)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Baris judul — boleh multi-line
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Color(0xFF373643),
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                        softWrap: true,
                        overflow:
                            TextOverflow.visible, // tampil penuh (multi-line)
                      ),
                    ),
                    // kalau mau ada space antara title dan kanan (opsional)
                    // const SizedBox(width: 8),
                  ],
                ),

                const SizedBox(height: 6),

                // Baris waktu + lama di kiri, tombol di kanan
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // kiri: waktu + lama (ambil ruang yang tersedia)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
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

                    // kanan: tombol lihat detail (tidak mengambil ruang lebih)
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
          ),

          // kalau nanti perlu elemen di paling kanan (status), tambahkan di sini
        ],
      ),
    );
  }
}

class _PengajuanItem extends StatelessWidget {
  final String title, subtitle;
  const _PengajuanItem({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '2',
                style: const TextStyle(
                  color: Color(0xFF373643),
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),

          // bagian tengah (judul + detail)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Baris judul — boleh multi-line
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Color(0xFF373643),
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                        softWrap: true,
                        overflow:
                            TextOverflow.visible, // tampil penuh (multi-line)
                      ),
                    ),
                    // kalau mau ada space antara title dan kanan (opsional)
                    // const SizedBox(width: 8),
                  ],
                ),

                const SizedBox(height: 6),

                // Baris waktu + lama di kiri, tombol di kanan
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // kiri: waktu + lama (ambil ruang yang tersedia)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            subtitle,
                            style: const TextStyle(
                              color: Color(0xFF4A4A4A),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // kalau nanti perlu elemen di paling kanan (status), tambahkan di sini
        ],
      ),
    );
  }
}

class _VerifikasiItem extends StatelessWidget {
  final String title, subtitle;
  const _VerifikasiItem({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Color(0xFF7AFF99).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '3',
                style: const TextStyle(
                  color: Color(0xFF373643),
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),

          // bagian tengah (judul + detail)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Baris judul — boleh multi-line
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Color(0xFF373643),
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                        softWrap: true,
                        overflow:
                            TextOverflow.visible, // tampil penuh (multi-line)
                      ),
                    ),
                    // kalau mau ada space antara title dan kanan (opsional)
                    // const SizedBox(width: 8),
                  ],
                ),

                const SizedBox(height: 6),

                // Baris waktu + lama di kiri, tombol di kanan
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // kiri: waktu + lama (ambil ruang yang tersedia)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            subtitle,
                            style: const TextStyle(
                              color: Color(0xFF4A4A4A),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // kalau nanti perlu elemen di paling kanan (status), tambahkan di sini
        ],
      ),
    );
  }
}

class DayCard extends StatelessWidget {
  final String label;
  final String dayNum;
  final bool isSelected;

  const DayCard({
    super.key,
    required this.label,
    required this.dayNum,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color base = isSelected
        ? const Color(0xFF76FF63)
        : const Color(0xFFCDEFF1);
    return GestureDetector(
      child: Container(
        width: 80,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: base,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Color(0xFF373643),
              ),
            ),
            const Spacer(),
            Text(
              dayNum,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 22,
                color: Color(0xFF373643),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
