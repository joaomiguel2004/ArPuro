import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../camera/domain/captured_photo.dart';
import '../domain/report_models.dart';
import '../widgets/anonymous_toggle_card.dart';
import '../widgets/category_selector.dart';
import '../widgets/photo_preview_card.dart';

class NewReportScreen extends StatefulWidget {
  final CapturedPhoto? photo;
  final VoidCallback? onRetake;
  final ValueChanged<MapReport>? onReportSubmitted;

  const NewReportScreen({
    super.key,
    this.photo,
    this.onRetake,
    this.onReportSubmitted,
  });

  @override
  State<NewReportScreen> createState() => _NewReportScreenState();
}

class _NewReportScreenState extends State<NewReportScreen> {
  ReportCategory _selectedCategory = ReportCategory.queimada;
  bool _isAnonymous = true;

  void _handleSubmit() {
    final report = MapReport(
      id: 'user-${DateTime.now().millisecondsSinceEpoch}',
      category: _selectedCategory,
      title: 'Nova denúncia: ${_selectedCategory.label}',
      neighborhood: 'Sua região atual',
      distanceText: '100m',
      timeLabel: 'Agora',
      reportCount: 1,
      normalizedX: 0.60,
      normalizedY: 0.50,
      isAnonymous: _isAnonymous,
      hasPlume: _selectedCategory == ReportCategory.queimada,
    );

    widget.onReportSubmitted?.call(report);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Denúncia de ${_selectedCategory.label} enviada para a comunidade!',
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppColors.primaryDark,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _LocationAttachedPill(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nova Denúncia',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textMain,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Revise a foto e envie para a rede.',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 20),
                PhotoPreviewCard(
                  photo: widget.photo,
                  onRetake: () => widget.onRetake?.call(),
                ),
                const SizedBox(height: 22),
                CategorySelector(
                  selectedCategory: _selectedCategory,
                  onSelected: (category) =>
                      setState(() => _selectedCategory = category),
                ),
                const SizedBox(height: 20),
                AnonymousToggleCard(
                  isAnonymous: _isAnonymous,
                  onChanged: (value) => setState(() => _isAnonymous = value),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: _handleSubmit,
                    icon: const Icon(Icons.send_outlined, size: 18),
                    label: const Text(
                      'Enviar para a Comunidade',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.textMain,
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shadowColor: const Color(0x330F172A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _LocationAttachedPill extends StatelessWidget {
  const _LocationAttachedPill();

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
            Icon(
              Icons.location_on_outlined,
              size: 14,
              color: Color(0xFF10B981),
            ),
            SizedBox(width: 6),
            Text(
              'Localização Anexada',
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
