import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

class HeaderDateTime extends StatefulWidget {
  const HeaderDateTime({super.key});

  @override
  State<HeaderDateTime> createState() => _HeaderDateTimeState();
}

class _HeaderDateTimeState extends State<HeaderDateTime> {
  String _timeString = DateFormat('HH.mm', 'id_ID').format(DateTime.now());
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _timeString = DateFormat('HH.mm', 'id_ID').format(DateTime.now());
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
    final now = DateTime.now();
    final tanggalBulan = DateFormat('d MMMM', 'id_ID').format(now);
    final tahun = DateFormat('yyyy', 'id_ID').format(now);
    final hari = DateFormat('EEEE', 'id_ID').format(now);

    final hijri = HijriCalendar.now();
    final tanggalHijriah = '${hijri.hDay}';
    final bulanHijriah = hijri.longMonthName;
    final tahunHijriah = '${hijri.hYear} H';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tanggalBulan,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF373643),
                    ),
                  ),
                  Text(
                    tahun,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF373643),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Today, $hari',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF373643),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Container(
                width: 2,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFF373643),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          tanggalHijriah,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF373643),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            bulanHijriah,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF373643),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      tahunHijriah,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF373643),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _timeString,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF373643),
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
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back,
                size: 40,
                color: Color(0xFF373643),
              ),
              tooltip: 'Kembali',
            ),
          ],
        ),
      ],
    );
  }
}
