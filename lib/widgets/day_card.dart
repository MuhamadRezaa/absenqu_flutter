import 'package:flutter/material.dart';

class DayCard extends StatelessWidget {
  final String label;
  final String dayNum;
  final bool isSelected;
  final VoidCallback onTap;

  const DayCard({
    super.key,
    required this.label,
    required this.dayNum,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color base = isSelected
        ? const Color(0xFFEFF4A8)
        : const Color(0xFFCDEFF1);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: base,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
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
