import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hijri/hijri_calendar.dart';

class RundownScheduleScreen extends StatefulWidget {
  final DateTime day;
  const RundownScheduleScreen({super.key, required this.day});

  @override
  State<RundownScheduleScreen> createState() => _RundownScheduleScreenState();
}

class _RundownScheduleScreenState extends State<RundownScheduleScreen> {
  late DateTime selectedDay;
  final Map<DateTime, List<_Event>> _eventsByDay = {};

  @override
  void initState() {
    super.initState();
    selectedDay = widget.day;
    final key = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
    _eventsByDay[key] = [
      if (selectedDay.weekday == DateTime.monday)
        _Event('Morning Breifing\nDengan CEO', 8.0, 9.0, const Color(0xFFE74C3C)),
      if (selectedDay.weekday == DateTime.monday)
        _Event('Rapat Target\nMarketing April 2025', 13.0, 15.0, const Color(0xFF2ECC71)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final tanggalBulan = DateFormat('d MMMM', 'id_ID').format(selectedDay);
    final tahun = DateFormat('yyyy', 'id_ID').format(selectedDay);
    final hari = DateFormat('EEEE', 'id_ID').format(selectedDay);
    final hijri = HijriCalendar.fromDate(selectedDay);

    final events = _eventsFor(selectedDay);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFEFF4A8),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
                boxShadow: [BoxShadow(color: Color(0x22000000), blurRadius: 12, offset: Offset(0, 6))],
              ),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Text(DateFormat('HH.mm', 'id_ID').format(DateTime.now()) + ' WIB',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF373643))),
                      const SizedBox(height: 8),
                      GestureDetector(onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back, size: 24, color: Color(0xFF373643))),
                    ]),
                  ],
                ),
                const SizedBox(height: 8),
                Row(children: [
                  Expanded(
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(tanggalBulan, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A))),
                        Text(tahun, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A))),
                        const SizedBox(height: 16),
                        Text('Today, $hari', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A))),
                      ]),
                      const SizedBox(width: 8),
                      Container(width: 2, height: 56, decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(2))),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(mainAxisSize: MainAxisSize.min, children: [
                            Text('${hijri.hDay}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A))),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(hijri.longMonthName,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A))),
                            ),
                          ]),
                          Text('${hijri.hYear} H', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A))),
                        ]),
                      ),
                    ]),
                  ),
                ]),
                const SizedBox(height: 12),
                SizedBox(
                  height: 70,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(children: _buildDayChips()),
                  ),
                ),
              ]),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: _Timeline(
                  events: events,
                  onTapHour: (hour) => _addEventAt(hour),
                  onEditEvent: (e) => _editEvent(e),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDayChips() {
    final start = selectedDay.subtract(Duration(days: selectedDay.weekday - 1));
    final labels = const ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat'];
    return List.generate(5, (i) {
      final d = start.add(Duration(days: i));
      final active = d.day == selectedDay.day && d.month == selectedDay.month && d.year == selectedDay.year;
      return Padding(
        padding: EdgeInsets.only(right: i == 4 ? 0 : 10),
        child: GestureDetector(
          onTap: () => setState(() => selectedDay = d),
          child: _DayChip(label: labels[i], num: '${d.day}', active: active),
        ),
      );
    });
  }

  List<_Event> _eventsFor(DateTime d) {
    final key = DateTime(d.year, d.month, d.day);
    return _eventsByDay[key] ?? [];
  }

  void _addEventAt(double hour) async {
    final e = await _openEventDialog(initial: _Event('', hour, hour + 1, const Color(0xFF2ECC71)));
    if (e != null) {
      final key = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
      final list = List<_Event>.from(_eventsByDay[key] ?? []);
      list.add(e);
      _eventsByDay[key] = list;
      setState(() {});
    }
  }

  void _editEvent(_Event target) async {
    final edited = await _openEventDialog(initial: target);
    if (edited != null) {
      final key = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
      final list = List<_Event>.from(_eventsByDay[key] ?? []);
      final idx = list.indexWhere((x) => identical(x, target));
      if (idx >= 0) {
        list[idx] = edited;
        _eventsByDay[key] = list;
        setState(() {});
      }
    }
  }

  Future<_Event?> _openEventDialog({required _Event initial}) async {
    final titleCtl = TextEditingController(text: initial.title);
    double start = initial.startHour;
    double end = initial.endHour;
    Color accent = initial.accent;
    final res = await showDialog<_Event>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Edit Acara'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleCtl, decoration: const InputDecoration(labelText: 'Judul Acara')),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(child: _HourField(label: 'Mulai', value: start, onChanged: (v) => start = v)),
                const SizedBox(width: 8),
                Expanded(child: _HourField(label: 'Selesai', value: end, onChanged: (v) => end = v)),
              ]),
              const SizedBox(height: 8),
              Row(children: [
                const Text('Warna: '),
                _ColorDot(color: const Color(0xFFE74C3C), selected: accent == const Color(0xFFE74C3C), onTap: () => accent = const Color(0xFFE74C3C)),
                const SizedBox(width: 8),
                _ColorDot(color: const Color(0xFF2ECC71), selected: accent == const Color(0xFF2ECC71), onTap: () => accent = const Color(0xFF2ECC71)),
              ]),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
            TextButton(onPressed: () {
              if (titleCtl.text.trim().isEmpty) return;
              if (end <= start) return;
              Navigator.pop(ctx, _Event(titleCtl.text.trim(), start, end, accent));
            }, child: const Text('Simpan')),
          ],
        );
      },
    );
    return res;
  }
}

class _DayChip extends StatelessWidget {
  final String label;
  final String num;
  final bool active;
  const _DayChip({required this.label, required this.num, this.active = false});
  @override
  Widget build(BuildContext context) {
    final bg = active ? const Color(0xFFFFF9AA) : const Color(0xFFEAF5F8);
    return Container(
      width: 72,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(18), boxShadow: const [
        BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 3)),
      ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: Color(0xFF373643))),
          const Spacer(),
          Text(num, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Color(0xFF373643))),
        ],
      ),
    );
  }
}

class _Timeline extends StatelessWidget {
  final List<_Event> events;
  final ValueChanged<double> onTapHour;
  final ValueChanged<_Event> onEditEvent;
  const _Timeline({required this.events, required this.onTapHour, required this.onEditEvent});
  @override
  Widget build(BuildContext context) {
    const double hourHeight = 64; // tinggi per jam
    final totalHeight = hourHeight * 10; // 07.00 - 16.00
    return SingleChildScrollView(
      child: SizedBox(
        height: totalHeight,
        child: Stack(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(children: List.generate(10, (i) {
              final hour = 7 + i;
              return SizedBox(
                height: hourHeight,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTapHour(hour.toDouble()),
                  child: Row(children: [
                    SizedBox(width: 60, child: Text('${hour.toString().padLeft(2, '0')}.00', style: const TextStyle(color: Color(0xFF8A8A8A)))) ,
                    const Expanded(child: Divider(color: Color(0xFFDDDDDD), thickness: 1)),
                  ]),
                ),
              );
            })),
          ),
          ...events.map((e) {
            final top = (e.startHour - 7) * hourHeight;
            return Positioned(
              top: top,
              left: 76,
              right: 24,
              child: _EventCard(title: e.title, timeRange: '${_fmt(e.startHour)} - ${_fmt(e.endHour)}', accent: e.accent, onEdit: () => onEditEvent(e)),
            );
          }),
        ]),
      ),
    );
  }

  String _fmt(double h) {
    final hour = h.floor();
    final min = ((h - hour) * 60).round();
    return '${hour.toString().padLeft(2, '0')}.${min.toString().padLeft(2, '0')}';
  }
}

class _EventCard extends StatelessWidget {
  final String title;
  final String timeRange;
  final Color accent;
  final VoidCallback onEdit;
  const _EventCard({required this.title, required this.timeRange, required this.accent, required this.onEdit});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 6))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 3, height: 36, decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 8),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  Expanded(
                    child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A))),
                  ),
                  GestureDetector(onTap: onEdit, child: const Icon(Icons.edit, size: 16, color: Color(0xFF1A1A1A))),
                ],
              ),
              const SizedBox(height: 6),
              Text(timeRange, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF8A8A8A))),
            ]),
          ),
        ],
      ),
    );
  }
}

class _Event {
  final String title;
  final double startHour;
  final double endHour;
  final Color accent;
  const _Event(this.title, this.startHour, this.endHour, this.accent);
}

class _HourField extends StatelessWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;
  const _HourField({required this.label, required this.value, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: _fmt(value));
    return TextField(
      controller: controller,
      keyboardType: TextInputType.datetime,
      decoration: InputDecoration(labelText: label, hintText: 'HH.mm'),
      onSubmitted: (val) {
        final parsed = _parseHour(val);
        if (parsed != null) onChanged(parsed);
      },
    );
  }

  String _fmt(double h) {
    final hour = h.floor();
    final min = ((h - hour) * 60).round();
    return '${hour.toString().padLeft(2, '0')}.${min.toString().padLeft(2, '0')}';
  }

  double? _parseHour(String s) {
    final parts = s.split('.');
    if (parts.length != 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    if (h < 0 || h > 23 || m < 0 || m > 59) return null;
    return h + (m / 60.0);
  }
}

class _ColorDot extends StatelessWidget {
  final Color color;
  final bool selected;
  final VoidCallback onTap;
  const _ColorDot({required this.color, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: selected ? Colors.black : Colors.transparent, width: 2),
        ),
      ),
    );
  }
}
