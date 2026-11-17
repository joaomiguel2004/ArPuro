import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../report/domain/report_models.dart';
import '../widgets/map_canvas.dart';
import '../widgets/map_filter_chips.dart';
import '../widgets/region_alert_card.dart';
import '../widgets/report_detail_sheet.dart';
import '../widgets/wind_badge_card.dart';

class MapScreen extends StatefulWidget {
  final List<MapReport> reports;

  const MapScreen({
    super.key,
    this.reports = defaultMapReports,
  });

  static const List<MapReport> defaultMapReports = [
    MapReport(
      id: 'fire-1',
      category: ReportCategory.queimada,
      title: 'Foco de fumaça intensa',
      neighborhood: 'Jardins / Zona Sul',
      distanceText: '800m à frente',
      timeLabel: 'Há 12 min',
      reportCount: 12,
      normalizedX: 0.48,
      normalizedY: 0.36,
      hasPlume: true,
    ),
    MapReport(
      id: 'water-1',
      category: ReportCategory.aguaEsgoto,
      title: 'Descarte irregular em canal',
      neighborhood: 'Treze de Julho',
      distanceText: '1.2 km',
      timeLabel: 'Há 35 min',
      reportCount: 1,
      normalizedX: 0.33,
      normalizedY: 0.68,
    ),
  ];

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final TextEditingController _searchController = TextEditingController();
  ReportCategory? _selectedCategory;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MapReport> get _filteredReports {
    return widget.reports.where((report) {
      final matchesCategory =
          _selectedCategory == null || report.category == _selectedCategory;
      final query = _searchQuery.trim().toLowerCase();
      final matchesSearch = query.isEmpty ||
          report.neighborhood.toLowerCase().contains(query) ||
          report.title.toLowerCase().contains(query) ||
          report.category.label.toLowerCase().contains(query);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final visibleReports = _filteredReports;
    final primaryFireAlert = visibleReports.where((r) => r.hasPlume).firstOrNull;

    return Stack(
      children: [
        Positioned.fill(
          child: MapCanvas(
            reports: visibleReports,
            onMarkerTap: (report) => ReportDetailSheet.show(context, report),
          ),
        ),
        Positioned(
          top: 12,
          left: 0,
          right: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _MapSearchBar(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _searchQuery = value),
                  onClear: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                ),
              ),
              const SizedBox(height: 12),
              MapFilterChips(
                selectedCategory: _selectedCategory,
                onSelected: (category) =>
                    setState(() => _selectedCategory = category),
              ),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.only(right: 20),
                child: WindBadgeCard(
                  speedKmh: 12,
                  directionLabel: 'VENTO NE',
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 20,
          right: 20,
          bottom: 108,
          child: RegionAlertCard(
            title: 'Atenção na Região',
            description: primaryFireAlert != null
                ? 'Foco de fumaça a ${primaryFireAlert.distanceText}.'
                : visibleReports.isEmpty
                    ? 'Nenhuma ocorrência encontrada para este filtro.'
                    : '${visibleReports.length} ocorrência(s) ativa(s) na região.',
            onTap: primaryFireAlert != null
                ? () => ReportDetailSheet.show(context, primaryFireAlert)
                : null,
          ),
        ),
      ],
    );
  }
}

class _MapSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _MapSearchBar({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.surfaceBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D0F172A),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textMain,
        ),
        decoration: InputDecoration(
          hintText: 'Buscar região ou bairro...',
          hintStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textLight,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.textLight,
            size: 20,
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  onPressed: onClear,
                  icon: const Icon(
                    Icons.close,
                    size: 18,
                    color: AppColors.textMuted,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 15,
          ),
        ),
      ),
    );
  }
}
