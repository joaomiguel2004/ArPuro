import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class StatsGrid extends StatelessWidget {
  final int reports;
  final int totalXp;
  const StatsGrid({super.key, this.reports = 0, this.totalXp = 0});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatBox(
            value: '$reports',
            label: 'Denúncias',
            valueColor: AppColors.textMain,
            bgIcon: Icons.chat_bubble_outline,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatBox(
            value: '$totalXp',
            label: 'XP Total',
            valueColor: AppColors.warning,
            bgIcon: Icons.star_outline_rounded,
          ),
        ),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;
  final IconData bgIcon;
  const _StatBox({
    required this.value,
    required this.label,
    required this.valueColor,
    required this.bgIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            bottom: -15,
            child: Icon(bgIcon, size: 60, color: AppColors.subtleBg),
          ),
          Column(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: valueColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
