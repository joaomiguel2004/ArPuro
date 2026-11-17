import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

enum BreathingStatus { optimal, fatigue, cough }

class BreathingCheckinCard extends StatefulWidget {
  final BreathingStatus initialStatus;
  final ValueChanged<BreathingStatus>? onChanged;

  const BreathingCheckinCard({
    super.key,
    this.initialStatus = BreathingStatus.optimal,
    this.onChanged,
  });

  @override
  State<BreathingCheckinCard> createState() => _BreathingCheckinCardState();
}

class _BreathingCheckinCardState extends State<BreathingCheckinCard> {
  late BreathingStatus _selected;

  static const _options = [
    (status: BreathingStatus.optimal, emoji: '😊', label: 'Ótimo'),
    (status: BreathingStatus.fatigue, emoji: '😐', label: 'Fadiga'),
    (status: BreathingStatus.cough, emoji: '😷', label: 'Tosse'),
  ];

  @override
  void initState() {
    super.initState();
    _selected = widget.initialStatus;
  }

  void _select(BreathingStatus status) {
    if (_selected == status) return;
    setState(() => _selected = status);
    widget.onChanged?.call(status);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.surfaceBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Como você está respirando hoje?',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textMain,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              for (var i = 0; i < _options.length; i++) ...[
                if (i > 0) const SizedBox(width: 10),
                Expanded(
                  child: _CheckinOptionTile(
                    emoji: _options[i].emoji,
                    label: _options[i].label,
                    isSelected: _selected == _options[i].status,
                    onTap: () => _select(_options[i].status),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _CheckinOptionTile extends StatelessWidget {
  final String emoji;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CheckinOptionTile({
    required this.emoji,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF0F9FF) : AppColors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF3B82F6) : AppColors.surfaceBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 26)),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? const Color(0xFF2563EB) : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
