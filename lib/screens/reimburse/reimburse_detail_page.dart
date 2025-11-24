import 'package:flutter/material.dart';
import 'package:absenqu_flutter/screens/reimburse/reimburse_form_screen.dart';

class ReimburseDetailPage extends StatelessWidget {
  const ReimburseDetailPage({super.key, required this.category, required this.amount});

  final String category;
  final int amount;

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
              const _Header(),
              const SizedBox(height: 12),
              const _DaySelector(),
              const SizedBox(height: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(28), topRight: Radius.circular(28)),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(colors: [Color(0xFFA5EEE9), Color(0xFF8FA7A5)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                        child: SingleChildScrollView(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'Ajukan Tagihan Reimburs Anda',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 10),
                                  const _PillButton(
                                    text: 'Klik Disini Untuk Mengajukan',
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Ringkasan kartu sesuai contoh
                            _SummaryTile(
                              title: 'Reimburse | Tanggal 1 Maret 2025 | Tahap Proses',
                              subtitle1: category,
                              subtitle2: _formatRupiah(amount),
                            ),
                            // Lampiran dihapus sesuai permintaan
                          ]),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _formatRupiah(int value) {
  final s = value.abs().toString();
  final parts = <String>[];
  for (int i = s.length; i > 0; i -= 3) {
    final start = (i - 3) < 0 ? 0 : i - 3;
    parts.insert(0, s.substring(start, i));
  }
  final sign = value < 0 ? '-' : '';
  return 'Rp $sign${parts.join('.')},-';
}

class _Header extends StatelessWidget {
  const _Header();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const _HeaderItem(label: '31 Maret\n2025'),
          const SizedBox(width: 12),
          Container(width: 1.5, height: 36, color: Colors.black.withOpacity(0.35)),
          const SizedBox(width: 12),
          const _HeaderItem(label: '1 Syawal\n1446 H'),
          const Spacer(),
          const _HeaderItem(label: '07.35 WIB'),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          const Text('Today, Senin', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.arrow_back, size: 22),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ]),
      ]),
    );
  }
}

class _HeaderItem extends StatelessWidget {
  const _HeaderItem({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) {
    return Text(label, textAlign: TextAlign.left, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600));
  }
}

class _DaySelector extends StatelessWidget {
  const _DaySelector();
  @override
  Widget build(BuildContext context) {
    final days = const [
      ('Senin', '1'), ('Selasa', '2'), ('Rabu', '3'), ('Kamis', '4'), ('Jumat', '5'),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: [
          for (var i = 0; i < days.length; i++) ...[
            _DayChip(label: days[i].$1, number: days[i].$2, selected: i == 0),
            if (i != days.length - 1) const SizedBox(width: 12),
          ]
        ]),
      ),
    );
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({required this.label, required this.number, this.selected = false});
  final String label; final String number; final bool selected;
  @override
  Widget build(BuildContext context) {
    final bg = selected ? const Color(0xFFF5EFAF) : const Color(0xFFE0F7F5);
    final border = selected ? Colors.transparent : Colors.black12;
    return Container(
      width: 76, height: 96, padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20), border: Border.all(color: border), boxShadow: selected ? [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 6, offset: const Offset(0,3))] : null),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Text(number, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      ]),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({required this.title, required this.subtitle1, required this.subtitle2});
  final String title; final String subtitle1; final String subtitle2;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.85), borderRadius: BorderRadius.circular(22), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0,2))]),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _NumberCircle(index: 1),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(subtitle1, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          const SizedBox(height: 2),
          Text(subtitle2, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ])),
      ]),
    );
  }
}

class _NumberCircle extends StatelessWidget {
  const _NumberCircle({required this.index});
  final int index;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26, height: 26,
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.8), borderRadius: BorderRadius.circular(13)),
      alignment: Alignment.center,
      child: Text('$index', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
    );
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFBDEFF0),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 6, offset: const Offset(0, 3)),
        ],
      ),
      child: Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label; final String value;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        SizedBox(width: 120, child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
        const Text(': ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 12))),
      ]),
    );
  }
}

class _DetailBox extends StatelessWidget {
  const _DetailBox({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))]),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(text, style: const TextStyle(fontSize: 12)),
    );
  }
}

class _AttachmentPlaceholder extends StatelessWidget {
  const _AttachmentPlaceholder();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120, height: 90,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2))]),
      child: const Icon(Icons.image, color: Color(0xFF3D6E63)),
    );
  }
}