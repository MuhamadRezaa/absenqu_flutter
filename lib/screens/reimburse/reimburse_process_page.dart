import 'package:flutter/material.dart';
import 'package:absenqu_flutter/screens/reimburse/reimburse_detail_page.dart';

class ReimburseProcessPage extends StatelessWidget {
  const ReimburseProcessPage({super.key, required this.category, required this.amount});

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
              Expanded(child: _ProcessCard(category: category, amount: amount)),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _HeaderItem(label: '31 Maret\n2025'),
              const SizedBox(width: 12),
              Container(width: 1.5, height: 36, color: Colors.black.withOpacity(0.35)),
              const SizedBox(width: 12),
              const _HeaderItem(label: '1 Syawal\n1446 H'),
              const Spacer(),
              const _HeaderItem(label: '07.35 WIB'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text('Today, Senin', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.arrow_back, size: 22),
                onPressed: () {
                  Navigator.of(context).pop();
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
        child: Row(
          children: [
            for (var i = 0; i < days.length; i++) ...[
              _DayChip(label: days[i].$1, number: days[i].$2, selected: i == 0),
              if (i != days.length - 1) const SizedBox(width: 12),
            ]
          ],
        ),
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

class _ProcessCard extends StatelessWidget {
  const _ProcessCard({required this.category, required this.amount});

  final String category;
  final int amount;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(28), topRight: Radius.circular(28)),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFFA5EEE9), Color(0xFF8FA7A5)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Center(
                child: Text('Proses Tagihan Reimburs Anda', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: 12),
              _StepTile(
                index: 1,
                title: 'Reimburse | Diajukan Tanggal 1 Maret 2025',
                subtitle: '${category}\n${_formatRupiah(amount)}',
                trailingDetail: true,
                onTapDetail: () {
                  Navigator.of(context).push(
                    _slideFadeRoute(ReimburseDetailPage(category: category, amount: amount)),
                  );
                },
              ),
              const SizedBox(height: 10),
              _StepTile(index: 2, title: 'Pengajuan', subtitle: 'Pengajuan anda sedang dalam proses Verifikasi'),
              const SizedBox(height: 10),
              _StepTile(index: 3, title: 'Verifikasi', subtitle: 'Izin anda Diterima'),
              const SizedBox(height: 10),
              _StepTile(index: 4, title: 'Proses Pembayaran', subtitle: 'Remburs Anda Sedang Dalam Proses Transfer'),
              const SizedBox(height: 10),
              const _StepTile(index: 5, title: 'Pembayaran Berhasil', subtitle: 'Remburs Anda Berhasil Dibayarkan', success: true),
            ]),
          ),
        ),
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  const _StepTile({
    required this.index,
    required this.title,
    required this.subtitle,
    this.trailingDetail = false,
    this.success = false,
    this.onTapDetail,
  });
  final int index; final String title; final String subtitle; final bool trailingDetail; final bool success; final VoidCallback? onTapDetail;
  @override
  Widget build(BuildContext context) {
    final bgColor = success ? const Color(0xFF79E5A7) : Colors.white.withOpacity(0.85);
    return Container(
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(22), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0,2))]),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _NumberCircle(index: index),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ])),
        if (trailingDetail)
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: onTapDetail,
              behavior: HitTestBehavior.opaque,
              child: Row(children: const [
                Text('Lihat Detail', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                SizedBox(width: 6),
                Icon(Icons.arrow_forward, size: 18),
              ]),
            ),
          ),
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

Route _slideFadeRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final offsetTween = Tween<Offset>(begin: const Offset(0.0, 0.06), end: Offset.zero)
          .chain(CurveTween(curve: Curves.easeOutCubic));
      final fadeTween = Tween<double>(begin: 0.0, end: 1.0)
          .chain(CurveTween(curve: Curves.easeOut));
      return FadeTransition(
        opacity: animation.drive(fadeTween),
        child: SlideTransition(position: animation.drive(offsetTween), child: child),
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
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