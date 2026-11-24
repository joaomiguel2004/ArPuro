import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../domain/air_quality.dart';

class AqiWidget extends StatelessWidget {
  final int? aqiValue;
  final AirQualityBand? band;
  final String? classification;
  final String? description;
  final String? errorMessage;
  final bool isLoading;
  final bool isStale;
  final DateTime? updatedAt;
  final List<AirQualityForecastPoint> forecast;
  final VoidCallback? onInfoTap;
  final VoidCallback? onRetry;
  final VoidCallback? onOpenSettings;

  const AqiWidget({
    super.key,
    this.aqiValue,
    this.band,
    this.classification,
    this.description,
    this.errorMessage,
    this.isLoading = false,
    this.isStale = false,
    this.updatedAt,
    this.forecast = const [],
    this.onInfoTap,
    this.onRetry,
    this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    final color = band == null ? AppColors.primary : Color(band!.colorValue);
    final heading = isLoading
        ? 'Buscando qualidade do ar…'
        : errorMessage != null
        ? 'Qualidade do ar indisponível'
        : classification ?? band?.label ?? 'Sem índice';

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
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 30,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            children: [
              _AqiRing(value: aqiValue, color: color),
              const SizedBox(height: 16),
              Text(
                heading,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                errorMessage ??
                    description ??
                    'O índice será calculado quando houver dados suficientes.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                  height: 1.4,
                ),
              ),
              if (isStale) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7ED),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Desatualizado · exibindo último índice disponível',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF9A3412),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
              if (errorMessage != null && onRetry != null) ...[
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Tentar novamente'),
                ),
              ],
              if (errorMessage != null && onOpenSettings != null) ...[
                const SizedBox(height: 4),
                TextButton.icon(
                  onPressed: onOpenSettings,
                  icon: const Icon(Icons.settings_outlined, size: 16),
                  label: const Text('Abrir configurações'),
                ),
              ],
              _ForecastRow(forecast: forecast),
              if (updatedAt != null) ...[
                const SizedBox(height: 12),
                Text(
                  'Dados horários até ${_formatTime(updatedAt!)}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: onInfoTap,
              child: Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: AppColors.subtleBg,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x0D000000),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.info_outline,
                  size: 14,
                  color: AppColors.textMuted,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _formatTime(DateTime value) {
    final local = value.toLocal();
    return '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }
}

class _AqiRing extends StatelessWidget {
  final int? value;
  final Color color;

  const _AqiRing({required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final progress = value == null
        ? 0.0
        : (value! / 400).clamp(0.0, 1.0).toDouble();
    return SizedBox(
      width: 120,
      height: 120,
      child: CustomPaint(
        painter: _AqiRingPainter(progress: progress, color: color),
        child: Center(
          child: Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value?.toString() ?? '—',
                  style: const TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textMain,
                    height: 1,
                  ),
                ),
                const Text(
                  'IQAr',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textMuted,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
    const strokeWidth = 10.0;

    canvas.drawCircle(
      center,
      radius - strokeWidth / 2,
      Paint()
        ..color = AppColors.surfaceBorder
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _AqiRingPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}

class _ForecastRow extends StatelessWidget {
  final List<AirQualityForecastPoint> forecast;

  const _ForecastRow({required this.forecast});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.only(top: 16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFCBD5E1))),
      ),
      child: forecast.isEmpty
          ? const SizedBox(
              width: double.infinity,
              child: Text(
                'Previsão horária indisponível no momento.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: forecast
                  .map(
                    (point) => Column(
                      children: [
                        Text(
                          '${point.time.toLocal().hour.toString().padLeft(2, '0')}h',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Color(point.band.colorValue),
                            shape: BoxShape.circle,
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x1A000000),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
    );
  }
}
