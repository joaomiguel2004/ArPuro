import 'package:flutter/material.dart';

/// Botão de disparo: anel branco externo + círculo branco interno.
class ShutterButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final bool isBusy;

  const ShutterButton({super.key, required this.onPressed, this.isBusy = false});

  @override
  State<ShutterButton> createState() => _ShutterButtonState();
}

class _ShutterButtonState extends State<ShutterButton> {
  bool _pressed = false;

  bool get _enabled => widget.onPressed != null && !widget.isBusy;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final shrink = _pressed || widget.isBusy;

    return Semantics(
      button: true,
      label: 'Tirar foto',
      enabled: _enabled,
      child: GestureDetector(
        onTapDown: _enabled ? (_) => _setPressed(true) : null,
        onTapUp: _enabled ? (_) => _setPressed(false) : null,
        onTapCancel: () => _setPressed(false),
        onTap: _enabled ? widget.onPressed : null,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 150),
          opacity: widget.onPressed == null ? 0.5 : 1,
          child: Container(
            width: 76,
            height: 76,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
            ),
            child: AnimatedScale(
              duration: const Duration(milliseconds: 120),
              scale: shrink ? 0.85 : 1,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: widget.isBusy
                    ? const Padding(
                        padding: EdgeInsets.all(18),
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Color(0xFF0F172A),
                        ),
                      )
                    : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
