import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/breathing_checkin_card.dart';
import '../widgets/seasonal_alert_card.dart';
import '../widgets/seasonal_forecast_sheet.dart';

class HealthScreen extends StatelessWidget {
  const HealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _HealthStatusPill(),
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
                  'Orientações baseadas no ar de hoje.',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 20),
                const _CleanAirBanner(),
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
                const _RecommendationCard(
                  icon: Icons.wb_sunny_outlined,
                  title: 'Atividades Externas',
                  description:
                      'Excelente momento para caminhadas e esportes ao ar livre. Temperatura amena.',
                ),
                const SizedBox(height: 12),
                const _RecommendationCard(
                  icon: Icons.water_drop_outlined,
                  title: 'Atenção à Hidratação',
                  description:
                      'A umidade está em 42% (tempo seco). Beba água com frequência ao longo do dia.',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HealthStatusPill extends StatelessWidget {
  const _HealthStatusPill();

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
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check, size: 14, color: Color(0xFF10B981)),
            SizedBox(width: 6),
            Text(
              'Atualizado agora',
              style: TextStyle(
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

class _CleanAirBanner extends StatelessWidget {
  const _CleanAirBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.greenBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFD1FAE5)),
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
            child: const Icon(
              Icons.show_chart,
              size: 24,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ar Limpo & Seguro',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Nenhuma restrição para asmáticos e idosos nas próximas 6 horas.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.primaryDark,
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
