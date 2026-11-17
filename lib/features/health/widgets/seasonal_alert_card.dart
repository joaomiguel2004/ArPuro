import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class SeasonalAlertCard extends StatelessWidget {
  final VoidCallback onTrendTap;

  const SeasonalAlertCard({super.key, required this.onTrendTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.textMain,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x260F172A),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Setembro:\nTemporada Seca',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.25,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Alerta: Risco alto de\nqueimadas.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF94A3B8),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Material(
            color: AppColors.darkSlate,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              onTap: onTrendTap,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.calendar_today_outlined, size: 15, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Tendência',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
