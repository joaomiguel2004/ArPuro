import 'package:flutter/material.dart';

enum ReportCategory {
  queimada,
  aguaEsgoto,
  lixoEntulho,
  industria,
}

extension ReportCategoryMeta on ReportCategory {
  String get label {
    switch (this) {
      case ReportCategory.queimada:
        return 'Queimada';
      case ReportCategory.aguaEsgoto:
        return 'Água / Esgoto';
      case ReportCategory.lixoEntulho:
        return 'Lixo / Entulho';
      case ReportCategory.industria:
        return 'Indústria';
    }
  }

  String get filterLabel {
    switch (this) {
      case ReportCategory.queimada:
        return 'Queimadas';
      case ReportCategory.aguaEsgoto:
        return 'Água/Esgoto';
      case ReportCategory.lixoEntulho:
        return 'Lixo/Entulho';
      case ReportCategory.industria:
        return 'Indústria';
    }
  }

  String get emoji {
    switch (this) {
      case ReportCategory.queimada:
        return '🔥';
      case ReportCategory.aguaEsgoto:
        return '💧';
      case ReportCategory.lixoEntulho:
        return '🗑️';
      case ReportCategory.industria:
        return '🏭';
    }
  }

  IconData get icon {
    switch (this) {
      case ReportCategory.queimada:
        return Icons.local_fire_department_outlined;
      case ReportCategory.aguaEsgoto:
        return Icons.water_drop_outlined;
      case ReportCategory.lixoEntulho:
        return Icons.delete_outline;
      case ReportCategory.industria:
        return Icons.factory_outlined;
    }
  }

  Color get markerColor {
    switch (this) {
      case ReportCategory.queimada:
        return const Color(0xFFEF4444);
      case ReportCategory.aguaEsgoto:
        return const Color(0xFF3B82F6);
      case ReportCategory.lixoEntulho:
        return const Color(0xFFF59E0B);
      case ReportCategory.industria:
        return const Color(0xFF6366F1);
    }
  }
}

class MapReport {
  final String id;
  final ReportCategory category;
  final String title;
  final String neighborhood;
  final String distanceText;
  final String timeLabel;
  final int reportCount;
  final double normalizedX;
  final double normalizedY;
  final bool isAnonymous;
  final bool hasPlume;

  const MapReport({
    required this.id,
    required this.category,
    required this.title,
    required this.neighborhood,
    required this.distanceText,
    required this.timeLabel,
    this.reportCount = 1,
    required this.normalizedX,
    required this.normalizedY,
    this.isAnonymous = true,
    this.hasPlume = false,
  });
}
