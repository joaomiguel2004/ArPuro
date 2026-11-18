import 'dart:io';

import 'package:camera/camera.dart' show XFile;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Exibe a foto capturada tanto no mobile (arquivo) quanto na web (blob URL).
class CapturedPhotoImage extends StatelessWidget {
  final XFile file;
  final BoxFit fit;

  const CapturedPhotoImage({
    super.key,
    required this.file,
    this.fit = BoxFit.cover,
  });

  Widget _fallback(BuildContext context, Object error, StackTrace? stackTrace) {
    return const Center(
      child: Icon(
        Icons.broken_image_outlined,
        size: 46,
        color: AppColors.textLight,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Image.network(file.path, fit: fit, errorBuilder: _fallback);
    }
    return Image.file(File(file.path), fit: fit, errorBuilder: _fallback);
  }
}
