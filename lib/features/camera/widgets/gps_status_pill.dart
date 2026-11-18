import 'package:flutter/material.dart';

enum GpsStatus { searching, active, unavailable }

class GpsStatusPill extends StatelessWidget {
  final GpsStatus status;

  const GpsStatusPill({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (IconData icon, Color iconColor, String label) = switch (status) {
      GpsStatus.searching => (
          Icons.location_searching_rounded,
          const Color(0xFFF59E0B),
          'Buscando GPS...',
        ),
      GpsStatus.active => (
          Icons.location_on_outlined,
          const Color(0xFF10B981),
          'GPS Ativo',
        ),
      GpsStatus.unavailable => (
          Icons.location_off_outlined,
          const Color(0xFFEF4444),
          'GPS Indisponível',
        ),
    };

    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xE6262626),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: iconColor),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
