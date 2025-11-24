import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';

class CutiScreen extends StatefulWidget {
  const CutiScreen({super.key});

  @override
  State<CutiScreen> createState() => _CutiScreenState();
}

class _CutiScreenState extends State<CutiScreen> {
  late DateTime today;
  DateTime? startDate;
  DateTime? endDate;
  String? uploadedPath;
  bool showForm = false;
  bool submitted = false;

  @override
  void initState() {
    super.initState();
    today = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final tanggalBulan = DateFormat('d MMMM', 'id_ID').format(today);
    final tahun = DateFormat('yyyy', 'id_ID').format(today);
    final hijri = HijriCalendar.fromDate(today);
    final hari = DateFormat('EEEE', 'id_ID').format(today);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFEFF4A8),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tanggalBulan,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF373643),
                            ),
                          ),
                          Text(
                            tahun,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF373643),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            DateFormat(
                                  'HH.mm',
                                  'id_ID',
                                ).format(DateTime.now()) +
                                ' WIB',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF373643),
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(
                              Icons.arrow_back,
                              size: 24,
                              color: Color(0xFF373643),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
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
                                    color: Color(0xFF1A1A1A),
                                  ),
                                ),
                                Text(
                                  tahun,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1A1A1A),
                                  ),
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
                              ],
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 2,
                              height: 56,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1A1A1A),
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
                                        '${hijri.hDay}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF1A1A1A),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Flexible(
                                        child: Text(
                                          hijri.longMonthName,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF1A1A1A),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${hijri.hYear} H',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1A1A1A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 70,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(children: _buildDayChips()),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _buildContent(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDayChips() {
    final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
    final labels = const ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat'];
    return List.generate(5, (i) {
      final d = startOfWeek.add(Duration(days: i));
      final active =
          d.day == today.day && d.month == today.month && d.year == today.year;
      final inCuti =
          submitted &&
          startDate != null &&
          endDate != null &&
          !d.isBefore(startDate!) &&
          !d.isAfter(endDate!);
      return Padding(
        padding: EdgeInsets.only(right: i == 4 ? 0 : 10),
        child: _DayChip(
          label: labels[i],
          num: '${d.day}',
          active: active,
          danger: inCuti,
        ),
      );
    });
  }

  Widget _buildContent() {
    if (!showForm && !submitted) {
      return Column(
        key: const ValueKey('cuti-initial'),
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () => setState(() => showForm = true),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF4A8),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'Ajukan Cuti Tahunan Anda',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Kuota Cuti Anda 12 Hari',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Riwayat Cuti Tahunan Anda',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                _HistoryTile(
                  title: 'Cuti | Diajukan Tanggal 1 Maret 2025',
                  desc: 'Waktu 1 Maret - 3 Maret 2025\nLama izin 3 Hari',
                  status: 'Diterima',
                ),
                const SizedBox(height: 8),
                _HistoryTile(
                  title: 'Cuti | Diajukan Tanggal 1 Maret 2025',
                  desc: 'Waktu 1 Maret - 3 Maret 2025\nLama izin 3 Hari',
                  status: 'Diterima',
                ),
              ],
            ),
          ),
        ],
      );
    }

    if (showForm && !submitted) {
      final days = (startDate != null && endDate != null)
          ? endDate!.difference(startDate!).inDays + 1
          : 0;
      return SingleChildScrollView(
        key: const ValueKey('cuti-form'),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            DottedBorder(
              options: RoundedRectDottedBorderOptions(
                dashPattern: const [8, 8],
                strokeWidth: 2,
                radius: const Radius.circular(18),
                color: const Color(0xFF1A1A1A),
                padding: const EdgeInsets.all(0),
              ),
              child: SizedBox(
                height: 96,
                child: Center(
                  child: GestureDetector(
                    onTap: _pickFile,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.upload_file),
                        const SizedBox(width: 8),
                        Text(
                          uploadedPath == null
                              ? 'Upload Surat Cuti'
                              : _short(uploadedPath!),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _DateField(
                    label: 'Mulai',
                    value: _fmtDate(startDate),
                    onTap: () async {
                      final d = await _pickDate(initial: startDate ?? today);
                      if (d != null) setState(() => startDate = d);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DateField(
                    label: 'Akhir',
                    value: _fmtDate(endDate),
                    onTap: () async {
                      final d = await _pickDate(
                        initial: endDate ?? (startDate ?? today),
                      );
                      if (d != null) setState(() => endDate = d);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F7F7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text(days > 0 ? '$days Hari' : '-')],
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              minLines: 3,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Isikan Deskripsi\nTujuan Cuti Anda',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 44,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    startDate ??= today;
                    endDate ??= (startDate ?? today).add(
                      const Duration(days: 2),
                    );
                    submitted = true;
                    showForm = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEFF4A8),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text('Ajukan Cuti Tahunan Anda'),
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      key: const ValueKey('cuti-process'),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Proses Pengajuan Cuti Anda',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                _ProcessTile(
                  index: 1,
                  title: 'Cuti | Diajukan',
                  desc: _rangeText(),
                  trailing: 'Lihat Detail',
                ),
                const SizedBox(height: 8),
                _ProcessTile(
                  index: 2,
                  title: 'Pengajuan',
                  desc: 'Pengajuan izin anda sedang dalam proses Verifikasi',
                ),
                const SizedBox(height: 8),
                _ProcessTile(
                  index: 3,
                  title: 'Verifikasi',
                  desc: 'Cuti anda Diterima',
                  highlight: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _rangeText() {
    if (startDate == null || endDate == null) return '';
    final s = DateFormat('d MMMM', 'id_ID').format(startDate!);
    final e = DateFormat('d MMMM', 'id_ID').format(endDate!);
    return 'Waktu $s - $e';
  }

  String _fmtDate(DateTime? d) {
    if (d == null) return '';
    return DateFormat('EEEE, d MMMM', 'id_ID').format(d);
  }

  String _short(String p) {
    final f = p.split(Platform.pathSeparator).last;
    return f.length > 20 ? f.substring(0, 20) + '…' : f;
  }

  Future<void> _pickFile() async {
    final picker = ImagePicker();
    final res = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (res != null) setState(() => uploadedPath = res.path);
  }

  Future<DateTime?> _pickDate({required DateTime initial}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year - 1, 1, 1),
      lastDate: DateTime(now.year + 2, 12, 31),
      locale: const Locale('id', 'ID'),
    );
    return picked;
  }
}

class _DayChip extends StatelessWidget {
  final String label;
  final String num;
  final bool active;
  final bool danger;
  const _DayChip({
    required this.label,
    required this.num,
    this.active = false,
    this.danger = false,
  });
  @override
  Widget build(BuildContext context) {
    final bg = danger
        ? const Color(0xFFE57373)
        : active
        ? const Color(0xFFFFF9AA)
        : const Color(0xFFEAF5F8);
    return Container(
      width: 72,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: Color(0xFF373643),
            ),
          ),
          const Spacer(),
          Text(
            num,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: Color(0xFF373643),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;
  const _DateField({
    required this.label,
    required this.value,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            Flexible(child: Text(value, overflow: TextOverflow.ellipsis)),
          ],
        ),
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final String title;
  final String desc;
  final String status;
  const _HistoryTile({
    required this.title,
    required this.desc,
    required this.status,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(desc),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Row(
            children: [
              Text(status),
              const SizedBox(width: 6),
              const Icon(Icons.arrow_forward),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProcessTile extends StatelessWidget {
  final int index;
  final String title;
  final String desc;
  final String? trailing;
  final bool highlight;
  const _ProcessTile({
    required this.index,
    required this.title,
    required this.desc,
    this.trailing,
    this.highlight = false,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: highlight ? const Color(0xFFE0FFF8) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: Colors.black12,
            child: Text('$index'),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(desc),
              ],
            ),
          ),
          if (trailing != null)
            Row(
              children: [
                Text(trailing!),
                const SizedBox(width: 6),
                const Icon(Icons.arrow_forward),
              ],
            ),
        ],
      ),
    );
  }
}
