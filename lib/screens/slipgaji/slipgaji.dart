import 'package:absenqu_flutter/widgets/header_date_time.dart';
import 'package:flutter/material.dart';

String formatRupiah(dynamic value) {
  final s = value == null
      ? '0'
      : value.toString().replaceAll(RegExp(r'[^0-9]'), '');
  final number = int.tryParse(s) ?? 0;
  final str = number.toString();
  final buffer = StringBuffer();
  int count = 0;
  for (int i = str.length - 1; i >= 0; i--) {
    buffer.write(str[i]);
    count++;
    if (count == 3 && i != 0) {
      buffer.write('.');
      count = 0;
    }
  }
  return buffer.toString().split('').reversed.join('');
}

class SlipGaji extends StatefulWidget {
  const SlipGaji({super.key});

  @override
  State<SlipGaji> createState() => _SlipGajiState();
}

class _SlipGajiState extends State<SlipGaji> {
  int _selectedMonthIndex = 3;
  final List<Map<String, String>> _weekDays = const [
    {"label": "Jan", "num": "1"},
    {"label": "Feb", "num": "2"},
    {"label": "Mar", "num": "3"},
    {"label": "Apr", "num": "4"},
    {"label": "Mei", "num": "5"},
    {"label": "Jun", "num": "6"},
    {"label": "Jul", "num": "7"},
    {"label": "Agu", "num": "8"},
    {"label": "Sep", "num": "9"},
    {"label": "Okt", "num": "10"},
    {"label": "Nov", "num": "11"},
    {"label": "Des", "num": "12"},
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

                          //const Text('Header (test)'),
                          const SizedBox(height: 20),

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
                                return MonthCard(
                                  label: d['label']!,
                                  monthNum: d['num']!,
                                  isSelected: _selectedMonthIndex == index,
                                  onTap: () => setState(
                                    () => _selectedMonthIndex = index,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    Expanded(child: BottomActionPanel()),
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
  BottomActionPanel({super.key});
  final List<Map<String, String>> penerimaanSlipList = [
    {"title": "Gaji Pokok", "jumlah": "3300000", "lama": "1", "waktu": "Bulan"},
    {"title": "Uang Makan", "jumlah": "20000", "lama": "20", "waktu": "Hari"},
    {
      "title": "Uang Transport",
      "jumlah": "15000",
      "lama": "20",
      "waktu": "Hari",
    },
    {"title": "Tunjangan", "jumlah": "800000", "lama": "1", "waktu": "Bulan"},
    {"title": "Lembur", "jumlah": "50000", "lama": "10", "waktu": "Jam"},
  ];

  final List<Map<String, String>> potonganSlipList = [
    {"title": "Iuran BPJS Tenaga Kerja", "jumlah": "120000"},
    {"title": "Iuran BPJS Kesehatan", "jumlah": "100000"},
  ];

  final Map<String, String> potonganPajak = {
    "title": "Pajak",
    "jumlah": "210000",
  };

  @override
  Widget build(BuildContext context) {
    // Penerimaan Gaji
    final List<int> penerimaanItemTotals = penerimaanSlipList.map((item) {
      final unit = int.tryParse(item['jumlah'] ?? '') ?? 0;
      final qty = int.tryParse(item['lama'] ?? '') ?? 1;

      return unit * qty;
    }).toList();

    final int totalAll = penerimaanItemTotals.fold<int>(0, (s, e) => s + e);
    final String totalFormattedPenerimaan = formatRupiah(totalAll);

    // Potongan Gaji
    final List<int> potonganItemTotals = potonganSlipList.map((item) {
      // safe parse: jika bukan angka, jadi 0
      final unit = int.tryParse(item['jumlah'] ?? '') ?? 0;
      final qty = int.tryParse(item['lama'] ?? '') ?? 1;
      return unit * qty;
    }).toList();

    final int totalAllPotongan = potonganItemTotals.fold<int>(
      0,
      (s, e) => s + e,
    );
    final String totalFormattedPotongan = formatRupiah(totalAllPotongan);

    // Gaji Bruto
    final int gajiBruto = totalAll - totalAllPotongan;
    final String totalGajiBrutoFormatted = formatRupiah(gajiBruto);

    // Pajak
    final int pajak =
        int.tryParse(
          potonganPajak['jumlah']?.replaceAll(RegExp(r'[^0-9]'), '') ?? '0',
        ) ??
        0;
    final String totalPajakFormatted = formatRupiah(pajak);

    // Gaji Bersih
    final int gajiBersih = gajiBruto - pajak;
    final String totalGajiBersihFormatted = formatRupiah(gajiBersih);

    return Container(
      width: double.infinity,
      // Panel penuh ke bawah, radius hanya di ATAS
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topRight: Radius.circular(100)),
        // abu-abu lembut + sedikit transparan biar nyatu dg background
        gradient: const LinearGradient(
          colors: [Color(0xFFF6EFFF), Color(0xFFA4A4A4)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).withOpacity(0.5),
        boxShadow: [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 20,
            offset: Offset(0, -8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(40, 10, 40, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 14),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/womenicon.png',
                  width: 40,
                  height: 55,
                ),
                const SizedBox(width: 6),
                const Text(
                  'Slip Gaji Anda',
                  style: TextStyle(
                    color: Color(0xFF181818),
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(width: 18),
                GestureDetector(
                  onTap: () {
                    // TODO: cetak slip action
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFF878689),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Cetak Slip',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Text(
                    'Perhitungan Penerimaan Gaji Anda',
                    style: TextStyle(
                      color: Color(0xFF181818),
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Column(
                    children: [
                      ...penerimaanSlipList.asMap().entries.map((entry) {
                        final i = entry.key;
                        final item = entry.value;
                        final itemTotal = penerimaanItemTotals[i];
                        final itemTotalFormattedPenerimaan = formatRupiah(
                          itemTotal,
                        );

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _PenerimaanGajiItem(
                            title: item['title']!,
                            jumlah: item['jumlah']!,
                            lama: item['lama']!,
                            waktu: item['waktu']!,
                            total:
                                itemTotalFormattedPenerimaan, // kirim total yg sudah dihitung sebagai string
                          ),
                        );
                      }).toList(),

                      const Divider(color: Color(0xFF181818), thickness: 1),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Total Gaji',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF181818),
                                ),
                              ),
                              const SizedBox(height: 6),

                              // Beri minWidth atau biarkan ukuran natural — tapi jangan pakai Flexible di dalamnya
                              Container(
                                width: 120,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(28),
                                  border: Border.all(
                                    color: Color(0xFFC4C4C4).withValues(
                                      alpha: 0.44,
                                    ), // WARNA GARIS TEPI
                                    width: 1, // ketebalan garis
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(20),
                                      blurRadius: 12,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                // gunakan Column (bukan Row + Flexible)
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // contoh teks jumlah — ganti sesuai kebutuhan
                                    Text(
                                      'Rp $totalFormattedPenerimaan',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF373643),
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Perhitungan Potongan Gaji Anda',
                            style: TextStyle(
                              color: Color(0xFF181818),
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Column(
                            children: [
                              ...potonganSlipList.asMap().entries.map((entry) {
                                final i = entry.key;
                                final item = entry.value;
                                final itemTotal =
                                    (potonganItemTotals.length > i)
                                    ? potonganItemTotals[i]
                                    : 0;
                                final itemTotalFormatted = formatRupiah(
                                  itemTotal,
                                );

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _PotonganGajiItem(
                                    title: item['title'] ?? '—',
                                    jumlah: item['jumlah'] ?? '0',
                                    total: itemTotalFormatted,
                                  ),
                                );
                              }).toList(),
                            ],
                          ),

                          const Divider(color: Color(0xFF181818), thickness: 1),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Column(
                                children: [
                                  const Text(
                                    'Total Potongan',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    width: 120,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(28),
                                      border: Border.all(
                                        color: const Color(
                                          0xFFC4C4C4,
                                        ).withOpacity(0.44),
                                        width: 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Rp $totalFormattedPotongan',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF373643),
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          Column(
                            children: [
                              Container(height: 1, color: Colors.black),
                              const SizedBox(height: 2), // jarak antar garis
                              Container(height: 1, color: Colors.black),
                            ],
                          ),

                          const SizedBox(height: 10),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Column(
                                children: [
                                  const Text(
                                    'Gaji Bruto',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    width: 120,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(28),
                                      border: Border.all(
                                        color: const Color(
                                          0xFFC4C4C4,
                                        ).withOpacity(0.44),
                                        width: 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Rp $totalGajiBrutoFormatted',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF373643),
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                potonganPajak['title'] ?? 'Pajak',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                width: 120,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(28),
                                  border: Border.all(
                                    color: const Color(
                                      0xFFC4C4C4,
                                    ).withOpacity(0.44),
                                    width: 1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'Rp $totalPajakFormatted',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF373643),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          Column(
                            children: [
                              Container(height: 1, color: Colors.black),
                              const SizedBox(height: 2), // jarak antar garis
                              Container(height: 1, color: Colors.black),
                            ],
                          ),

                          const SizedBox(height: 10),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Gaji Bersih',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                width: 120,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(28),
                                  border: Border.all(
                                    color: const Color(
                                      0xFFC4C4C4,
                                    ).withOpacity(0.44),
                                    width: 1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'Rp $totalGajiBersihFormatted',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF373643),
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ],
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

class _PenerimaanGajiItem extends StatelessWidget {
  final String title, jumlah, lama, waktu, total;
  const _PenerimaanGajiItem({
    required this.title,
    required this.jumlah,
    required this.lama,
    required this.waktu,
    required this.total,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // kiri: judul + kotak putih yang mengisi sisa ruang
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF181818),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: Color(0xFFC4C4C4).withValues(alpha: 0.44),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(20),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rp ${formatRupiah(jumlah)} x $lama $waktu',
                      style: const TextStyle(
                        color: Color(0xFF373643),
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                    // tambahkan elemen lain jika perlu
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        // kanan: kolom jumlah (tetap sesuai visual kamu)
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Jumlah',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF181818),
              ),
            ),
            const SizedBox(height: 6),

            // Beri minWidth atau biarkan ukuran natural — tapi jangan pakai Flexible di dalamnya
            Container(
              width: 120,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: Color(
                    0xFFC4C4C4,
                  ).withValues(alpha: 0.44), // WARNA GARIS TEPI
                  width: 1, // ketebalan garis
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(20),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              // gunakan Column (bukan Row + Flexible)
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // contoh teks jumlah — ganti sesuai kebutuhan
                  Text(
                    'Rp $total',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF373643),
                      fontWeight: FontWeight.w500,
                    ),
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

class _PotonganGajiItem extends StatelessWidget {
  final String title, jumlah, total;
  const _PotonganGajiItem({
    required this.title,
    required this.jumlah,
    required this.total,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // kiri: judul + kotak putih yang mengisi sisa ruang
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF181818),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: Color(
                      0xFFC4C4C4,
                    ).withValues(alpha: 0.44), // WARNA GARIS TEPI
                    width: 1, // ketebalan garis
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(20),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rp $jumlah',
                      style: const TextStyle(
                        color: Color(0xFF373643),
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                    // tambahkan elemen lain jika perlu
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        // kanan: kolom jumlah (tetap sesuai visual kamu)
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Jumlah',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF181818),
              ),
            ),
            const SizedBox(height: 6),

            // Beri minWidth atau biarkan ukuran natural — tapi jangan pakai Flexible di dalamnya
            Container(
              width: 120,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: Color(
                    0xFFC4C4C4,
                  ).withValues(alpha: 0.44), // WARNA GARIS TEPI
                  width: 1, // ketebalan garis
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(20),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              // gunakan Column (bukan Row + Flexible)
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // contoh teks jumlah — ganti sesuai kebutuhan
                  Text(
                    'Rp $total',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF373643),
                      fontWeight: FontWeight.w500,
                    ),
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

class MonthCard extends StatelessWidget {
  final String label;
  final String monthNum;
  final bool isSelected;
  final VoidCallback onTap;

  const MonthCard({
    super.key,
    required this.label,
    required this.monthNum,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color base = isSelected
        ? const Color(0xFFEFF4A8)
        : const Color(0xFFFFFFFF).withValues(alpha: 0.35);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 65,
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
                fontSize: 14,
                color: Color(0xFF373643),
              ),
            ),
            const Spacer(),
            Text(
              monthNum,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 14,
                color: Color(0xFF373643),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
