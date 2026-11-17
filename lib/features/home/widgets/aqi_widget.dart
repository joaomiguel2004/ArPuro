import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class AqiWidget extends StatelessWidget {
  final int aqiValue;
  final String classification;
  final String description;
  final VoidCallback? onInfoTap;

  const AqiWidget({
    super.key,
    this.aqiValue = 25,
    this.classification = 'Qualidade Boa',
    this.description = 'Ar limpo hoje. Seguro para todos os grupos sensíveis.',
    this.onInfoTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment(-0.6, -0.8),
          end: Alignment(0.6, 0.8),
          colors: [Color(0xFFFFFFFF), Color(0xFFF0F3F5)],
        ),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.surfaceBorder),
        boxShadow: const [
          BoxShadow(color: Color(0x0A000000), blurRadius: 30, offset: Offset(0, 10)),
        ],
      ),
      child: Stack(
        children: [
          Column(
            children: [
              _AqiRing(value: aqiValue),
              const SizedBox(height: 16),
              Text(classification, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primaryDark)),
              const SizedBox(height: 4),
              Text(description, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: AppColors.textMuted, height: 1.4)),
              const _ForecastRow(),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: onInfoTap,
              child: Container(
                width: 28, height: 28,
                decoration: const BoxDecoration(color: AppColors.subtleBg, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Color(0x0D000000), blurRadius: 4, offset: Offset(0, 2))]),
                child: const Icon(Icons.info_outline, size: 14, color: AppColors.textMuted),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AqiRing extends StatelessWidget {
  final int value;
  const _AqiRing({required this.value});

  @override
  Widget build(BuildContext context) {
    final double displayPercent = value <= 50 ? 0.7 : (value / 500).clamp(0.0, 1.0);
    return SizedBox(
      width: 120, height: 120,
      child: CustomPaint(
        painter: _AqiRingPainter(progress: displayPercent, color: _getColor(value)),
        child: Center(
          child: Container(
            width: 100, height: 100,
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$value', style: const TextStyle(fontSize: 38, fontWeight: FontWeight.w800, color: AppColors.textMain, height: 1)),
                const Text('AQI', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 1)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getColor(int aqi) {
    if (aqi <= 50) return AppColors.primary;
    if (aqi <= 100) return AppColors.warning;
    if (aqi <= 150) return const Color(0xFFFF6B35);
    return AppColors.danger;
  }
}

class _AqiRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  _AqiRingPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const sw = 10.0;
    canvas.drawCircle(center, radius - sw / 2, Paint()..color = AppColors.surfaceBorder..style = PaintingStyle.stroke..strokeWidth = sw..strokeCap = StrokeCap.round);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius - sw / 2), -math.pi / 2, 2 * math.pi * progress, false, Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = sw..strokeCap = StrokeCap.round);
  }

  @override
  bool shouldRepaint(covariant _AqiRingPainter old) => old.progress != progress || old.color != color;
}

class _ForecastRow extends StatelessWidget {
  const _ForecastRow();

  @override
  Widget build(BuildContext context) {
    final items = [('12h', AppColors.primary), ('15h', AppColors.warning), ('18h', AppColors.primary), ('21h', AppColors.primary)];
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.only(top: 16),
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xFFCBD5E1)))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items.map((item) => Column(
          children: [
            Text(item.$1, style: const TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Container(width: 12, height: 12, decoration: BoxDecoration(color: item.$2, shape: BoxShape.circle, boxShadow: const [BoxShadow(color: Color(0x1A000000), blurRadius: 4, offset: Offset(0, 2))])),
          ],
        )).toList(),
      ),
    );
  }
}
