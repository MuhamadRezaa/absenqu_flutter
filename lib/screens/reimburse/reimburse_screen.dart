import 'package:flutter/material.dart';
import 'package:absenqu_flutter/screens/reimburse/reimburse_form_screen.dart';
import 'package:absenqu_flutter/utils/date_time_labels.dart';
import 'package:hijri/hijri_calendar.dart';
import 'dart:async';

class ReimburseScreen extends StatelessWidget {
  const ReimburseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF95E9E4), Color(0xFF9FA9A7)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _Header(),
              const SizedBox(height: 12),
              const _DaySelector(),
              const SizedBox(height: 16),
              const Expanded(child: _ReimburseCard()),
            ],
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
    final hijri = HijriCalendar.fromDate(_now);
    final hijriLabel = '${hijri.hDay} ${hijri.longMonthName}\n${hijri.hYear} H';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _HeaderItem(label: '$tanggal'),
              const SizedBox(width: 12),
              Container(width: 1.5, height: 36, color: Colors.black.withOpacity(0.35)),
              const SizedBox(width: 12),
              _HeaderItem(label: hijriLabel),
              const Spacer(),
              _HeaderItem(label: jam),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'Today, $hari',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.arrow_back, size: 22),
                onPressed: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
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
    return Text(
      label,
      textAlign: TextAlign.left,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    );
  }
}

class _DaySelector extends StatelessWidget {
  const _DaySelector();

  @override
  Widget build(BuildContext context) {
    final days = const [
      ('Senin', '1'),
      ('Selasa', '2'),
      ('Rabu', '3'),
      ('Kamis', '4'),
      ('Jumat', '5'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (var i = 0; i < days.length; i++) ...[
              _DayChip(
                label: days[i].$1,
                number: days[i].$2,
                selected: i == 0,
              ),
              if (i != days.length - 1) const SizedBox(width: 12),
            ]
          ],
        ),
      ),
    );
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({
    required this.label,
    required this.number,
    this.selected = false,
  });

  final String label;
  final String number;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final bg = selected ? const Color(0xFFF5EFAF) : const Color(0xFFE0F7F5);
    final border = selected ? Colors.transparent : Colors.black12;
    return Container(
      width: 76,
      height: 96,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                )
              ]
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            number,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _ReimburseCard extends StatelessWidget {
  const _ReimburseCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFA5EEE9), Color(0xFF8FA7A5)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ReimburseFormScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Ajukan Tagihan Reimburs Anda',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ReimburseFormScreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 142, 255, 247),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      alignment: Alignment.center,
                      child: const Text(
                        'Klik Disini Untuk Mengajukan',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Syarat dan Ketentuan Reimburs',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                const _Bullets(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Bullets extends StatelessWidget {
  const _Bullets();

  @override
  Widget build(BuildContext context) {
    const items = [
      'Siapkan Bukti Pembayaran Yang Sah',
      'Reimburs hanya dapat dilakukan untuk kebutuhan-kebutuhan sesuai dengan Peraturan Perusahaan yang berlaku.',
      'Proses Pembayaran Reimburs dilakukan 2 x 24 Jam.',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < items.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              '(${i + 1}) ${items[i]}',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
            ),
          ),
      ],
    );
  }
}