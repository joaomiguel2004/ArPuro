import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class PhotoPreviewCard extends StatelessWidget {
  final bool hasCapturedPhoto;
  final String coordinates;
  final String timeText;
  final VoidCallback onRetake;

  const PhotoPreviewCard({
    super.key,
    required this.hasCapturedPhoto,
    this.coordinates = '10.9472° S, 37.0731° W',
    this.timeText = '09:32 (Agora)',
    required this.onRetake,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 214,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFE7EDF4),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.surfaceBorder),
        gradient: hasCapturedPhoto
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFDDE7F0),
                  Color(0xFFC5D5E4),
                ],
              )
            : null,
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  hasCapturedPhoto
                      ? Icons.photo_camera_back_outlined
                      : Icons.image_outlined,
                  size: 46,
                  color: hasCapturedPhoto
                      ? AppColors.primary
                      : AppColors.textLight,
                ),
                if (hasCapturedPhoto) ...[
                  const SizedBox(height: 6),
                  const Text(
                    'Foto capturada',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ],
                const SizedBox(height: 36),
              ],
            ),
          ),
          Positioned(
            top: 14,
            right: 14,
            child: GestureDetector(
              onTap: onRetake,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x140F172A),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.refresh_rounded,
                      size: 16,
                      color: AppColors.textMain,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Refazer',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textMain,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 14,
            right: 14,
            bottom: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xEB2A3546),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'COORDENADAS',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFCBD5E1),
                          letterSpacing: 0.6,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        coordinates,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'HORÁRIO',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFCBD5E1),
                          letterSpacing: 0.6,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        timeText,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
