import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class SeasonalForecastSheet extends StatelessWidget {
  const SeasonalForecastSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const SeasonalForecastSheet(),
    );
  }

  static const _months = [
    (label: 'SET', fill: 0.42, color: AppColors.warning, highlightLabel: false),
    (label: 'OUT', fill: 0.78, color: AppColors.danger, highlightLabel: true),
    (label: 'NOV', fill: 1.00, color: Color(0xFF991B1B), highlightLabel: true),
    (label: 'DEZ', fill: 0.42, color: AppColors.warning, highlightLabel: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1D5DB),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.subtleBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.calendar_today_outlined,
                      size: 20,
                      color: AppColors.textMain,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Previsão Sazonal',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textMain,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Aracaju, SE • Próximos 4 meses',
                        style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.surfaceBorder),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    for (final item in _months)
                      _MonthBar(
                        label: item.label,
                        fill: item.fill,
                        color: item.color,
                        highlightLabel: item.highlightLabel,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFEF2F2),
                    border: Border(
                      left: BorderSide(color: AppColors.danger, width: 4),
                    ),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ALERTA CRÍTICO SE APROXIMA',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFDC2626),
                          letterSpacing: 0.3,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'O histórico de dados mostra que 68% dos focos de queimada na capital ocorrem entre Outubro e Novembro, devido aos ventos fortes de Primavera e falta de chuvas.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF991B1B),
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.textMain,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Entendi, preparar inalador',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MonthBar extends StatelessWidget {
  final String label;
  final double fill;
  final Color color;
  final bool highlightLabel;

  const _MonthBar({
    required this.label,
    required this.fill,
    required this.color,
    required this.highlightLabel,
  });

  @override
  Widget build(BuildContext context) {
    const double barHeight = 92;
    const double barWidth = 24;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: barWidth,
          height: barHeight,
          decoration: BoxDecoration(
            color: AppColors.subtleBg,
            borderRadius: BorderRadius.circular(6),
          ),
          alignment: Alignment.bottomCenter,
          child: FractionallySizedBox(
            heightFactor: fill.clamp(0.0, 1.0),
            widthFactor: 1.0,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: highlightLabel ? FontWeight.w700 : FontWeight.w600,
            color: highlightLabel ? color : AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}
