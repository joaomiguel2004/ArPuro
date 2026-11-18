import 'package:flutter/material.dart';

/// Botão circular escuro usado no topo da câmera (fechar / flash).
class CameraRoundButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  const CameraRoundButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onPressed,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.35),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Icon(
            icon,
            size: 22,
            color: onPressed == null
                ? Colors.white.withValues(alpha: 0.4)
                : Colors.white,
          ),
        ),
      ),
    );
  }
}
