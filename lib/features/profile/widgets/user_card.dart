import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class UserCard extends StatelessWidget {
  final String name;
  final String initial;
  final String badge;
  final int currentXp;
  final int maxXp;
  final int level;
  final String levelTitle;

  const UserCard({super.key, this.name = 'William Estevam', this.initial = 'W', this.badge = 'Ativista Verificado', this.currentXp = 750, this.maxXp = 1000, this.level = 3, this.levelTitle = 'Guardião do Bairro'});

  @override
  Widget build(BuildContext context) {
    final progress = (currentXp / maxXp).clamp(0.0, 1.0);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(24), border: Border.all(color: AppColors.surfaceBorder), boxShadow: const [BoxShadow(color: Color(0x05000000), blurRadius: 30, offset: Offset(0, 10))]),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60, height: 60,
                decoration: BoxDecoration(gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF059669), Color(0xFF10B981)]), borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: AppColors.primaryGlow, blurRadius: 16, offset: Offset(0, 8))]),
                child: Center(child: Text(initial, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800))),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textMain, letterSpacing: -0.3)),
                    const SizedBox(height: 2),
                    Row(children: [const Icon(Icons.verified, size: 16, color: AppColors.primary), const SizedBox(width: 4), Text(badge, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary))]),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Nível $level: $levelTitle', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 0.5)),
              Text('$currentXp / $maxXp XP', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary, letterSpacing: 0.5)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: progress, minHeight: 8, backgroundColor: AppColors.surfaceBorder, valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary))),
        ],
      ),
    );
  }
}
