import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class ExportButton extends StatelessWidget {
  final VoidCallback? onTap;
  const ExportButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Exportação — em breve!'), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), duration: const Duration(seconds: 2), backgroundColor: AppColors.darkSlate));
      },
      child: CustomPaint(
        painter: _DashedBorderPainter(color: const Color(0xFFCBD5E1), strokeWidth: 2, dashWidth: 8, dashSpace: 5, borderRadius: 16),
        child: Container(
          width: double.infinity, padding: const EdgeInsets.all(16),
          child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.download_outlined, size: 18, color: AppColors.textMuted),
            SizedBox(width: 8),
            Text('Exportar Dados Regionais (.CSV)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textMuted)),
          ]),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double borderRadius;
  _DashedBorderPainter({required this.color, required this.strokeWidth, required this.dashWidth, required this.dashSpace, required this.borderRadius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..strokeWidth = strokeWidth..style = PaintingStyle.stroke;
    final path = Path()..addRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height), Radius.circular(borderRadius)));
    final dashedPath = Path();
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final end = (distance + dashWidth).clamp(0.0, metric.length);
        dashedPath.addPath(metric.extractPath(distance, end), Offset.zero);
        distance += dashWidth + dashSpace;
      }
    }
    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter old) => old.color != color || old.strokeWidth != strokeWidth;
}
