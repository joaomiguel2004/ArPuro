import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class HealthChips extends StatefulWidget {
  const HealthChips({super.key});
  @override
  State<HealthChips> createState() => _HealthChipsState();
}

class _HealthChipsState extends State<HealthChips> {
  final Set<int> _activeChips = {0};

  void _toggleChip(int index) {
    setState(() {
      if (_activeChips.contains(index)) { _activeChips.remove(index); } else { _activeChips.add(index); }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chips = [('Asmático', Icons.show_chart), ('Crianças', Icons.sentiment_satisfied_alt), ('Idosos', Icons.people_outline)];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('MEU PERFIL DE SAÚDE', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textMain, letterSpacing: 0.5)),
              Text('Para alertas precisos', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textMuted.withValues(alpha: 0.8))),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: List.generate(chips.length, (i) {
              final isActive = _activeChips.contains(i);
              return Padding(
                padding: EdgeInsets.only(right: i < chips.length - 1 ? 8 : 0),
                child: GestureDetector(
                  onTap: () => _toggleChip(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isActive ? const Color(0xFFEFF6FF) : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isActive ? const Color(0xFF93C5FD) : AppColors.surfaceBorder),
                      boxShadow: const [BoxShadow(color: Color(0x05000000), blurRadius: 4, offset: Offset(0, 2))],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(chips[i].$2, size: 16, color: isActive ? const Color(0xFF1D4ED8) : AppColors.textMuted),
                        const SizedBox(width: 6),
                        Text(chips[i].$1, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isActive ? const Color(0xFF1D4ED8) : AppColors.textMuted)),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
