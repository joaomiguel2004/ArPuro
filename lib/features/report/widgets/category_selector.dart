import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/report_models.dart';

class CategorySelector extends StatelessWidget {
  final ReportCategory selectedCategory;
  final ValueChanged<ReportCategory> onSelected;

  const CategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'O que você fotografou?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.textMain,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _CategoryButton(
                category: ReportCategory.queimada,
                isSelected: selectedCategory == ReportCategory.queimada,
                onTap: () => onSelected(ReportCategory.queimada),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _CategoryButton(
                category: ReportCategory.aguaEsgoto,
                isSelected: selectedCategory == ReportCategory.aguaEsgoto,
                onTap: () => onSelected(ReportCategory.aguaEsgoto),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _CategoryButton(
                category: ReportCategory.lixoEntulho,
                isSelected: selectedCategory == ReportCategory.lixoEntulho,
                onTap: () => onSelected(ReportCategory.lixoEntulho),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _CategoryButton(
                category: ReportCategory.industria,
                isSelected: selectedCategory == ReportCategory.industria,
                onTap: () => onSelected(ReportCategory.industria),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CategoryButton extends StatelessWidget {
  final ReportCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryButton({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.surfaceBorder,
          ),
          boxShadow: isSelected
              ? const [
                  BoxShadow(
                    color: AppColors.primaryGlow,
                    blurRadius: 14,
                    offset: Offset(0, 6),
                  ),
                ]
              : const [
                  BoxShadow(
                    color: Color(0x05000000),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            Icon(
              category.icon,
              size: 20,
              color: isSelected ? Colors.white : AppColors.textMuted,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                category.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : AppColors.textMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
