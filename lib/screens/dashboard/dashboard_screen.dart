// lib/main.dart
// Copy this file into your Flutter project (replace lib/main.dart)
// No external packages required.

import 'package:flutter/material.dart';
import 'package:absenqu_flutter/screens/absen_masuk/absen_masuk_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF93FFFA), Color(0xFF999999)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // HEADER
                Padding(
                  padding: const EdgeInsets.only(top: 16, left: 24, right: 24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 180,
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/images/absenqu-icon.png',
                                  height: 32,
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'your partner manages employees',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Sandy Pratama',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const Text(
                            'NIP 1897819010001',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Manajer IT &\nSoftware Development',
                            style: TextStyle(fontSize: 12),
                          ),
                          const Text(
                            'Kantor Pusat',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      const Spacer(),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.asset(
                          'assets/images/icon.png',
                          width: 90,
                          height: 110,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // RIWAYAT DAN ICON (cyan background container with gradient)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF93FFFA), Color(0xFF56C1C1)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 4),
                      ],
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        // Tombol Riwayat abu-abu
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF9E9E9E),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.history,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                'Riwayat',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        // Tiga icon kecil di sebelah kanan
                        _smallIconInCyan(Icons.person, 0),
                        const SizedBox(width: 8),
                        _smallIconInCyan(Icons.info, 1),
                        const SizedBox(width: 8),
                        _smallIconInCyan(Icons.mail, 1),
                        const SizedBox(width: 12),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                // INFO & ABSEN
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF9D6),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                '01 April 2025   |   1 Syawal 1446 H',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Waktu Saat ini 08.30',
                                style: TextStyle(fontSize: 13),
                              ),
                              SizedBox(height: 6),
                              Text('Senin', style: TextStyle(fontSize: 13)),
                              SizedBox(height: 6),
                              Text(
                                'Morning Breifing\nRapat Target Marketing April',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            _absenCard(
                              context,
                              Icons.directions_run,
                              'Absen Masuk',
                              '07.30',
                              'SESUAI',
                              'Peraturan Absen Masuk\nSift I Pukul 08.00',
                              const Color(0xFFA0FFF9),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AbsenMasukPage(),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                            _absenCard(
                              context,
                              Icons.directions_walk,
                              'Absen Pulang',
                              '16.32',
                              'SESUAI',
                              'Peraturan Absen Pulang\nSift I Pukul 16.30',
                              const Color(0xFFD8C8FF),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                // MENU CEPAT
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _menuCard('Izin', 'assets/images/icon1.png'),
                      _menuCard('Cuti', 'assets/images/icon2.png'),
                      _menuCard('Pegawai', 'assets/images/icon3.png'),
                      _menuCard('Challenge', 'assets/images/icon4.png'),
                      _menuCard('Slip Gaji', 'assets/images/icon5.png'),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                // RANKING
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ranking Pegawai Bulan ini',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.search,
                                      color: Colors.black38,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: TextField(
                                        decoration: const InputDecoration(
                                          hintText: 'Sandy Pratama',
                                          border: InputBorder.none,
                                          isDense: true,
                                        ),
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            _rankingTile(
                              1,
                              'Rudi Admojo',
                              'Staf Marketing',
                              'Kantor Cabang Ringroad',
                              1100,
                              'assets/images/amrin.png',
                              false,
                            ),
                            _rankingTile(
                              2,
                              'Sandy Pratama',
                              'Manager Marketing',
                              'Kantor Cabang Ringroad',
                              1000,
                              'assets/images/icon.png',
                              true,
                            ),
                            _rankingTile(
                              3,
                              'Amrin Tambunan',
                              'Staf Keuangan',
                              'Kantor Cabang Ringroad',
                              900,
                              'assets/images/amrin.png',
                              false,
                            ),
                            _rankingTile(
                              4,
                              'Rudi Admojo',
                              'Staf Marketing',
                              'Kantor Cabang Ringroad',
                              800,
                              'assets/images/rudi.png',
                              false,
                            ),
                            _rankingTile(
                              5,
                              'Rudi Admojo',
                              'Staf Marketing',
                              'Kantor Cabang Ringroad',
                              810,
                              'assets/images/rudi.png',
                              false,
                            ),
                            _rankingTile(
                              6,
                              'Rudi Admojo',
                              'Staf Marketing',
                              'Kantor Cabang Ringroad',
                              700,
                              'assets/images/rudi.png',
                              false,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                // CHALLENGE
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Chalange Anda Bulan ini',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _challengeRow(
                        Icons.fitness_center,
                        'Berolah Raga',
                        200,
                        20,
                      ),
                      const SizedBox(height: 10),
                      _challengeRow(
                        Icons.self_improvement,
                        'Sholat Berjamaah',
                        400,
                        20,
                      ),
                      const SizedBox(height: 10),
                      _challengeRow(Icons.menu_book, 'Hafalan Quran', 200, 20),
                      const SizedBox(height: 10),
                      _challengeRow(
                        Icons.auto_stories,
                        'Membaca Buku',
                        150,
                        20,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _iconWithBadge(IconData icon, int badge) {
  return Stack(
    alignment: Alignment.topRight,
    children: [
      Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Icon(icon, color: Colors.black54),
      ),
      if (badge > 0)
        Positioned(
          right: 6,
          top: 6,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$badge',
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
        ),
    ],
  );
}

Widget _smallIconWithBadge(IconData icon, int badge) {
  return Stack(
    alignment: Alignment.topRight,
    children: [
      Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white24,
          shape: BoxShape.circle,
        ),
        child: Center(child: Icon(icon, color: Colors.white, size: 18)),
      ),
      if (badge > 0)
        Positioned(
          right: 4,
          top: 4,
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$badge',
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
        ),
    ],
  );
}

Widget _smallIconInCyan(IconData icon, int badge) {
  return Stack(
    alignment: Alignment.topRight,
    children: [
      Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey.shade600,
          shape: BoxShape.circle,
        ),
        child: Center(child: Icon(icon, color: Colors.white, size: 18)),
      ),
      if (badge > 0)
        Positioned(
          right: 2,
          top: 2,
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$badge',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
    ],
  );
}

Widget _absenCard(
  BuildContext context,
  IconData icon,
  String title,
  String time,
  String status,
  String subtitle,
  Color color, {
  VoidCallback? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 32, color: Colors.black),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('$time   $status', style: const TextStyle(fontSize: 15)),
                Text(subtitle, style: const TextStyle(fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _menuCard(String label, String asset) {
  return Container(
    width: 70,
    height: 90,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(asset, height: 32),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );
}

Widget _rankingTile(
  int rank,
  String name,
  String role,
  String kantor,
  int point,
  String asset,
  bool highlight,
) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: highlight ? const Color(0xFFA0FFF9) : Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4)),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Rank circle
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 2,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                '$rank',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Avatar
          CircleAvatar(backgroundImage: AssetImage(asset), radius: 24),
          const SizedBox(width: 12),

          // Name and role
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(role, style: const TextStyle(fontSize: 12)),
                Text(kantor, style: const TextStyle(fontSize: 11)),
              ],
            ),
          ),

          // Trailing points
          Container(
            width: 92,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Nilai Poin', style: TextStyle(fontSize: 12)),
                const SizedBox(height: 6),
                Text(
                  '$point',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _challengeRow(IconData icon, String label, int target, int total) {
  // New layout matching the mockup: left cyan pill + right white pill with vertical divider
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Expanded(
        child: Container(
          // increased height to avoid vertical overflow on various font scales
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF93FFFA), Color(0xFFA0FFF9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 22, color: Colors.black87),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(width: 12),
      Container(
        height: 72,
        width: 170,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Target', style: TextStyle(fontSize: 12)),
                    Text(
                      '$target',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Vertical divider
            Container(width: 1, height: 48, color: Colors.grey.shade300),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Total Poin', style: TextStyle(fontSize: 12)),
                    Text(
                      '$total',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFB8FFF0), Color(0xFF9EE6D8)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
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
                    const SizedBox(height: 8),
                    // Replace text logo with image icon
                    Image.asset(
                      'assets/images/absenqu-icon.png',
                      height: 36,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Sandy Pratama',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'NIP 1897819010001',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Manajer IT &\nSoftware Development',
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(height: 6),
                    Text('Kantor Pusat', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),

              // profile image
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/icon.png',
                  height: 96,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.history),
                label: const Text('Riwayat'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white70,
                  foregroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: Colors.white70,
                child: IconButton(
                  icon: const Icon(Icons.info_outline),
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: Colors.white70,
                child: IconButton(
                  icon: const Icon(Icons.notifications_none),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F4C6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      '01 April 2025 | 1 Syawal 1446 H',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('Waktu Saat ini', style: TextStyle(fontSize: 12)),
                    SizedBox(height: 6),
                    Text(
                      '08.30',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text('Senin', style: TextStyle(fontSize: 14)),
                    SizedBox(height: 6),
                    Text(
                      'Morning Briefing\nRapat Target Marketing April',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  _MiniCard(
                    color: const Color(0xFFBFF7ED),
                    title: 'Absen Masuk',
                    time: '07.30',
                    status: 'SESUAI',
                    subtitle: 'Peraturan Absen Masuk\nSift 1 Pukul 08.00',
                  ),
                  const SizedBox(height: 8),
                  _MiniCard(
                    color: const Color(0xFFD8C8FF),
                    title: 'Absen Pulang',
                    time: '16.32',
                    status: 'SESUAI',
                    subtitle: 'Peraturan Absen Pulang\nSift 1 Pukul 16.30',
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MiniCard extends StatelessWidget {
  final Color color;
  final String title;
  final String time;
  final String status;
  final String subtitle;

  const _MiniCard({
    required this.color,
    required this.title,
    required this.time,
    required this.status,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    time,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(status, style: const TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(subtitle, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }
}

class _FeatureGrid extends StatelessWidget {
  final List<Map<String, dynamic>> features = [
    {'label': 'Izin', 'icon': Icons.person},
    {'label': 'Cuti', 'icon': Icons.beach_access},
    {'label': 'Pegawai', 'icon': Icons.group},
    {'label': 'Challenge', 'icon': Icons.emoji_events},
    {'label': 'Slip Gaji', 'icon': Icons.receipt_long},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: features.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final f = features[index];
          return Container(
            width: 84,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFFE6FFF9),
                  child: Icon(f['icon'], color: Colors.black87),
                ),
                const SizedBox(height: 8),
                Text(f['label'], style: const TextStyle(fontSize: 12)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _RankingCard extends StatelessWidget {
  final List<Map<String, dynamic>> items = List.generate(6, (i) {
    return {
      'name': i == 1 ? 'Sandy Pratama' : 'Rudi Admojo',
      'role': 'Staf Marketing',
      'points': 1100 - i * 100,
      'avatar': 'https://picsum.photos/seed/$i/80',
    };
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ranking Pegawai Bulan ini',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F6F6),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: const [
                Icon(Icons.search),
                SizedBox(width: 8),
                Expanded(child: Text('Sandy Pratama')),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Column(
            children: items.asMap().entries.map((entry) {
              final idx = entry.key + 1;
              final it = entry.value;
              final isHighlight = idx == 2; // highlight second
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(it['avatar']),
                      radius: 26,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isHighlight
                              ? const Color(0xFFE0FFF8)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  it['name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  it['role'],
                                  style: const TextStyle(fontSize: 12),
                                ),
                                Text(
                                  'Kantor Cabang Ringroad',
                                  style: const TextStyle(fontSize: 11),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Nilai Poin',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${it['points']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _ChallengeList extends StatelessWidget {
  final List<Map<String, dynamic>> challenges = [
    {
      'label': 'Berolah Raga',
      'target': 200,
      'total': 20,
      'icon': Icons.fitness_center,
    },
    {
      'label': 'Sholat Berjamaah',
      'target': 400,
      'total': 20,
      'icon': Icons.self_improvement,
    },
    {
      'label': 'Hafalan Quran',
      'target': 200,
      'total': 20,
      'icon': Icons.menu_book,
    },
    {
      'label': 'Membaca Buku',
      'target': 150,
      'total': 20,
      'icon': Icons.auto_stories,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Chalange Anda Bulan ini',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Column(
          children: challenges.map((c) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFBFF7F0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(child: Icon(c['icon'])),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              c['label'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 120,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text('Target', style: TextStyle(fontSize: 12)),
                        Text(
                          '${c['target']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Total Poin',
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          '${c['total']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
