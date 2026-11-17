import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../report/domain/report_models.dart';

class MapFilterChips extends StatelessWidget {
  final ReportCategory? selectedCategory;
  final ValueChanged<ReportCategory?> onSelected;

  const MapFilterChips({
    super.key,
    required this.selectedCategory,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        physics: const BouncingScrollPhysics(),
        children: [
          _FilterChipItem(
            label: 'Todos',
            isSelected: selectedCategory == null,
            onTap: () => onSelected(null),
          ),
          const SizedBox(width: 8),
          ...ReportCategory.values.map((category) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _FilterChipItem(
                label: '${category.emoji} ${category.filterLabel}',
                isSelected: selectedCategory == category,
                onTap: () => onSelected(
                  selectedCategory == category ? null : category,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _FilterChipItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChipItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.textMain : AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppColors.textMain : AppColors.surfaceBorder,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : AppColors.textMain,
            ),
          ),
        ),
      ),
    );
  }
}
