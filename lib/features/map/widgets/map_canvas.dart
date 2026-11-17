import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../report/domain/report_models.dart';

class MapCanvas extends StatelessWidget {
  final List<MapReport> reports;
  final ValueChanged<MapReport> onMarkerTap;

  const MapCanvas({
    super.key,
    required this.reports,
    required this.onMarkerTap,
  });

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      minScale: 0.9,
      maxScale: 2.5,
      boundaryMargin: const EdgeInsets.all(80),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          return Stack(
            children: [
              CustomPaint(
                size: Size(width, height),
                painter: _MapBackgroundPainter(
                  plumeOrigins: reports
                      .where((r) => r.hasPlume)
                      .map((r) => Offset(r.normalizedX * width, r.normalizedY * height))
                      .toList(),
                ),
              ),
              Positioned(
                left: width * 0.56 - 20,
                top: height * 0.44 - 20,
                child: const _UserLocationDot(),
              ),
              ...reports.map((report) {
                final markerX = report.normalizedX * width;
                final markerY = report.normalizedY * height;
                return Positioned(
                  left: markerX - 24,
                  top: markerY - 52,
                  child: _MapPinMarker(
                    report: report,
                    onTap: () => onMarkerTap(report),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

class _MapBackgroundPainter extends CustomPainter {
  final List<Offset> plumeOrigins;

  _MapBackgroundPainter({required this.plumeOrigins});

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFFF6F8FA);
    canvas.drawRect(Offset.zero & size, bgPaint);

    // Soft green park areas
    final parkPaint = Paint()..color = const Color(0xFFE7F6EC);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.08, size.height * 0.31, size.width * 0.22, size.height * 0.14),
        const Radius.circular(24),
      ),
      parkPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.62, size.height * 0.66, size.width * 0.26, size.height * 0.14),
        const Radius.circular(22),
      ),
      parkPaint,
    );

    // Curved river / waterway
    final riverPaint = Paint()
      ..color = const Color(0xFFDCEEFB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.13
      ..strokeCap = StrokeCap.round;

    final riverPath = Path()
      ..moveTo(-size.width * 0.05, size.height * 0.58)
      ..quadraticBezierTo(
        size.width * 0.38,
        size.height * 0.52,
        size.width * 0.54,
        size.height * 0.41,
      )
      ..quadraticBezierTo(
        size.width * 0.72,
        size.height * 0.30,
        size.width * 1.08,
        size.height * 0.35,
      );
    canvas.drawPath(riverPath, riverPaint);

    // Subtle white road network
    final majorRoadPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    final minorRoadPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    // Vertical-ish avenues
    canvas.drawLine(
      Offset(size.width * 0.18, 0),
      Offset(size.width * 0.08, size.height),
      majorRoadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.42, 0),
      Offset(size.width * 0.33, size.height),
      minorRoadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.68, 0),
      Offset(size.width * 0.59, size.height),
      majorRoadPaint,
    );

    // Horizontal-ish streets
    canvas.drawLine(
      Offset(0, size.height * 0.28),
      Offset(size.width, size.height * 0.33),
      minorRoadPaint,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.56),
      Offset(size.width, size.height * 0.63),
      majorRoadPaint,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.76),
      Offset(size.width, size.height * 0.72),
      minorRoadPaint,
    );

    // Smoke dispersion plume(s) blowing SW from NE wind
    for (final origin in plumeOrigins) {
      final plumeOrigin = Offset(origin.dx - 16, origin.dy - 14);
      final plumeEndLeft = Offset(plumeOrigin.dx - size.width * 0.58, plumeOrigin.dy + size.height * 0.26);
      final plumeEndRight = Offset(plumeOrigin.dx - size.width * 0.10, plumeOrigin.dy + size.height * 0.44);

      final plumePath = Path()
        ..moveTo(plumeOrigin.dx, plumeOrigin.dy)
        ..lineTo(plumeEndLeft.dx, plumeEndLeft.dy)
        ..quadraticBezierTo(
          plumeOrigin.dx - size.width * 0.35,
          plumeOrigin.dy + size.height * 0.44,
          plumeEndRight.dx,
          plumeEndRight.dy,
        )
        ..close();

      final plumePaint = Paint()
        ..shader = ui.Gradient.linear(
          plumeOrigin,
          Offset(plumeOrigin.dx - size.width * 0.36, plumeOrigin.dy + size.height * 0.36),
          [
            const Color(0x99EF4444),
            const Color(0x66F97316),
            const Color(0x2EFBBF24),
            const Color(0x00FDE68A),
          ],
          [0.0, 0.32, 0.7, 1.0],
        );

      canvas.drawPath(plumePath, plumePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _MapBackgroundPainter oldDelegate) {
    return oldDelegate.plumeOrigins != plumeOrigins;
  }
}

class _UserLocationDot extends StatelessWidget {
  const _UserLocationDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFF3B82F6).withValues(alpha: 0.22),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: const Color(0xFF2563EB),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: const [
              BoxShadow(
                color: Color(0x332563EB),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapPinMarker extends StatelessWidget {
  final MapReport report;
  final VoidCallback onTap;

  const _MapPinMarker({required this.report, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final pinColor = report.category.markerColor;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 56,
        height: 58,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            CustomPaint(
              size: const Size(44, 52),
              painter: _TeardropPinPainter(color: pinColor),
            ),
            Positioned(
              top: 6,
              child: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  report.category.icon,
                  size: 18,
                  color: pinColor,
                ),
              ),
            ),
            if (report.reportCount > 1)
              Positioned(
                top: -2,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.textMain,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: Text(
                    '${report.reportCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TeardropPinPainter extends CustomPainter {
  final Color color;

  _TeardropPinPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.width / 2);
    final radius = size.width / 2 - 2;

    final path = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius))
      ..moveTo(center.dx - radius * 0.65, center.dy + radius * 0.65)
      ..lineTo(center.dx, size.height)
      ..lineTo(center.dx + radius * 0.65, center.dy + radius * 0.65)
      ..close();

    canvas.drawShadow(path, const Color(0x400F172A), 6, true);
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _TeardropPinPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
