import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../profile/presentation/profile_providers.dart';

/// Modal exibido após o envio de uma denúncia, com o ganho de XP do usuário.
class ReportSuccessDialog extends StatelessWidget {
  final int level;
  final String levelTitle;
  final int previousXp;
  final int xpGained;
  final int maxXp;
  final bool leveledUp;

  const ReportSuccessDialog({
    super.key,
    required this.level,
    required this.levelTitle,
    required this.previousXp,
    required this.xpGained,
    required this.maxXp,
    this.leveledUp = false,
  });

  /// Monta o modal a partir do XP real ganho, dentro do nível atual.
  factory ReportSuccessDialog.fromGain(XpGain gain) {
    final after = gain.after;
    final level = after.level;
    final currentInLevel = after.xpInLevel.clamp(0, after.xpForLevel);
    final previousInLevel = gain.leveledUp
        ? 0
        : (currentInLevel - gain.gained).clamp(0, after.xpForLevel);
    return ReportSuccessDialog(
      level: level.number,
      levelTitle: level.title,
      previousXp: previousInLevel,
      xpGained: gain.gained,
      maxXp: after.xpForLevel,
      leveledUp: gain.leveledUp,
    );
  }

  static Future<void> show(BuildContext context, {required XpGain gain}) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: const Color(0x990F172A),
      builder: (_) => ReportSuccessDialog.fromGain(gain),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 40, 28, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppColors.greenBg,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFD1FAE5), width: 6),
              ),
              child: const Icon(
                Icons.check_circle_outline_rounded,
                size: 44,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Alerta Registrado!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: AppColors.textMain,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Sua denúncia já está visível para a comunidade de Aracaju no mapa colaborativo.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                height: 1.45,
                fontWeight: FontWeight.w500,
                color: AppColors.textMuted,
              ),
            ),
            if (leveledUp) ...[
              const SizedBox(height: 12),
              Text(
                'Você subiu para o nível $level!',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFB45309),
                ),
              ),
            ],
            const SizedBox(height: 28),
            _XpProgressCard(
              level: level,
              levelTitle: levelTitle,
              previousXp: previousXp,
              xpGained: xpGained,
              maxXp: maxXp,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.textMain,
                  foregroundColor: Colors.white,
                  elevation: 6,
                  shadowColor: const Color(0x400F172A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Voltar ao Início',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _XpProgressCard extends StatelessWidget {
  final int level;
  final String levelTitle;
  final int previousXp;
  final int xpGained;
  final int maxXp;

  const _XpProgressCard({
    required this.level,
    required this.levelTitle,
    required this.previousXp,
    required this.xpGained,
    required this.maxXp,
  });

  static const _amber = Color(0xFFF59E0B);
  static const _amberText = Color(0xFFB45309);

  @override
  Widget build(BuildContext context) {
    final currentXp = (previousXp + xpGained).clamp(0, maxXp);
    final safeMax = maxXp <= 0 ? 1 : maxXp;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFDE68A)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26F59E0B),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'NÍVEL $level: ${levelTitle.toUpperCase()}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: _amberText,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
              const Icon(Icons.star_rounded, size: 22, color: _amber),
              const SizedBox(width: 6),
              Text(
                '+$xpGained XP',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: _amber,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: previousXp / safeMax, end: currentXp / safeMax),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) => _XpBar(fill: value),
          ),
          const SizedBox(height: 8),
          Text(
            '$currentXp / $maxXp XP',
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: _amberText,
            ),
          ),
        ],
      ),
    );
  }
}

class _XpBar extends StatelessWidget {
  final double fill;

  const _XpBar({required this.fill});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: SizedBox(
        height: 12,
        child: Stack(
          children: [
            Container(color: const Color(0xFFFDE68A)),
            FractionallySizedBox(
              widthFactor: fill.clamp(0.0, 1.0),
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFF59E0B),
                      Color(0xFFF59E0B),
                      Color(0xFFFDE7C2),
                      Color(0xFFF59E0B),
                    ],
                    stops: [0.0, 0.88, 0.94, 1.0],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
