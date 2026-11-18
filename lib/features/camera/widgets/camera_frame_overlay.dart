import 'package:flutter/material.dart';

/// Moldura de enquadramento com quatro cantos (cantoneiras) arredondados.
class CameraFrameOverlay extends StatelessWidget {
  final double size;

  const CameraFrameOverlay({super.key, this.size = 260});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: const CustomPaint(painter: _CornersPainter()),
    );
  }
}

class _CornersPainter extends CustomPainter {
  static const double _length = 30;
  static const double _radius = 10;
  static const double _stroke = 3;

  const _CornersPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = _stroke;

    const i = _stroke / 2;
    final w = size.width - i;
    final h = size.height - i;
    const r = Radius.circular(_radius);

    final path = Path()
      // Superior esquerdo
      ..moveTo(i, i + _length)
      ..lineTo(i, i + _radius)
      ..arcToPoint(const Offset(i + _radius, i), radius: r)
      ..lineTo(i + _length, i)
      // Superior direito
      ..moveTo(w - _length, i)
      ..lineTo(w - _radius, i)
      ..arcToPoint(Offset(w, i + _radius), radius: r)
      ..lineTo(w, i + _length)
      // Inferior direito
      ..moveTo(w, h - _length)
      ..lineTo(w, h - _radius)
      ..arcToPoint(Offset(w - _radius, h), radius: r)
      ..lineTo(w - _length, h)
      // Inferior esquerdo
      ..moveTo(i + _length, h)
      ..lineTo(i + _radius, h)
      ..arcToPoint(Offset(i, h - _radius), radius: r)
      ..lineTo(i, h - _length);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
