import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../home/domain/air_quality.dart';
import '../../home/presentation/home_providers.dart';
import '../widgets/breathing_checkin_card.dart';
import '../widgets/seasonal_alert_card.dart';
import '../widgets/seasonal_forecast_sheet.dart';

class HealthScreen extends ConsumerWidget {
  const HealthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final airQualityState = ref.watch(homeAirQualityProvider);
    final reading = airQualityState.asData?.value;
    final statusLabel = reading == null
        ? (airQualityState.hasError ? 'Dados indisponíveis' : 'Atualizando')
        : reading.isStale
        ? 'Desatualizado'
        : 'Atualizado às ${_formatTime(reading.observedAt)}';

    return Column(
      children: [
        _HealthStatusPill(
          label: statusLabel,
          isStale: reading?.isStale ?? false,
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 110),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Guia de Saúde',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textMain,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Orientações baseadas no índice atual e tendências sazonais.',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 20),
                _AirQualityBanner(state: airQualityState),
                const SizedBox(height: 16),
                const BreathingCheckinCard(),
                const SizedBox(height: 16),
                SeasonalAlertCard(
                  onTrendTap: () => SeasonalForecastSheet.show(context),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Recomendações do Dia',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textMain,
                  ),
                ),
                const SizedBox(height: 12),
                if (reading == null)
                  const _RecommendationCard(
                    icon: Icons.info_outline,
                    title: 'Recomendações indisponíveis',
                    description: 'Elas serão exibidas quando o backend retornar o índice de qualidade do ar.',
                  )
                else
                  for (var i = 0; i < reading.recommendations.length; i++) ...[
                    if (i > 0) const SizedBox(height: 12),
                    _RecommendationCard(
                      icon: _recommendationIcon(
                        reading.recommendations[i].category,
                      ),
                      title: reading.recommendations[i].title,
                      description: reading.recommendations[i].description,
                    ),
                  ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  static String _formatTime(DateTime value) {
    final local = value.toLocal();
    return '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }

  static IconData _recommendationIcon(String category) => switch (category) {
    'activity' => Icons.directions_run,
    'sensitive_groups' => Icons.health_and_safety_outlined,
    'pollutant' => Icons.air,
    _ => Icons.info_outline,
  };
}

class _HealthStatusPill extends StatelessWidget {
  final String label;
  final bool isStale;

  const _HealthStatusPill({required this.label, required this.isStale});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isStale ? Icons.warning_amber_rounded : Icons.check,
              size: 14,
              color: isStale
                  ? const Color(0xFFFBBF24)
                  : const Color(0xFF10B981),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AirQualityBanner extends StatelessWidget {
  final AsyncValue<HomeAirQuality> state;

  const _AirQualityBanner({required this.state});

  @override
  Widget build(BuildContext context) {
    return state.when(
      data: (reading) => _StatusBanner(
        color: Color(reading.risk.colorValue),
        backgroundColor: Color(reading.risk.backgroundColorValue),
        title: 'Qualidade do ar ${reading.band.label}',
        description:
            '${reading.qualityDescription} IQAr ${reading.index}; poluente de maior subíndice: ${reading.dominantPollutant}.${reading.isStale ? ' Dados desatualizados.' : ''}',
      ),
      loading: () => const _StatusBanner(
        color: AppColors.textMuted,
        backgroundColor: AppColors.subtleBg,
        title: 'Carregando qualidade do ar',
        description: 'As recomendações serão atualizadas com o IQAr atual.',
      ),
      error: (error, stackTrace) => const _StatusBanner(
        color: AppColors.textMuted,
        backgroundColor: AppColors.subtleBg,
        title: 'Qualidade do ar indisponível',
        description:
            'Não foi possível obter dados para orientar as atividades de hoje.',
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  final Color color;
  final Color backgroundColor;
  final String title;
  final String description;

  const _StatusBanner({
    required this.color,
    required this.backgroundColor,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.air, size: 24, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 13, color: color, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _RecommendationCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.surfaceBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.subtleBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 22, color: AppColors.textMain),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textMain,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
