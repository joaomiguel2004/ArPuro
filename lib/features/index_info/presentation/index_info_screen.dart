import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class IndexInfoSheet extends StatelessWidget {
  const IndexInfoSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const IndexInfoSheet(),
    );
  }

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
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFD1D5DB), borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(color: AppColors.subtleBg, borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.info_outline, size: 20, color: AppColors.textMain),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Entendendo o Índice', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textMain)),
                      SizedBox(height: 2),
                      Text('O que significa a sigla AQI?', style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 14, color: AppColors.textMuted, height: 1.5),
                  children: [
                    TextSpan(text: 'O '),
                    TextSpan(text: 'AQI (Air Quality Index)', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w600)),
                    TextSpan(text: ' é a escala mundial que mede a concentração de poeira, fumaça e gases no ar. Quanto menor, melhor.'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildLegendItem(AppColors.primary, 'Boa', '0 - 50'),
              const SizedBox(height: 12),
              _buildLegendItem(AppColors.warning, 'Moderada', '51 - 100'),
              const SizedBox(height: 12),
              _buildLegendItem(const Color(0xFFFF6B35), 'Risco Sensíveis', '101 - 150'),
              const SizedBox(height: 12),
              _buildLegendItem(AppColors.danger, 'Insalubre', '150+'),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  height: 10,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [Color(0xFF059669), Color(0xFFF59E0B), Color(0xFFFF6B35), Color(0xFFEF4444)]),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity, height: 52,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.darkSlate, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 0),
                  child: const Text('Entendi, voltar', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildLegendItem(Color color, String label, String range) {
    return Row(
      children: [
        Container(width: 14, height: 14, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textMain))),
        Text(range, style: const TextStyle(fontSize: 13, color: AppColors.textMuted, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
