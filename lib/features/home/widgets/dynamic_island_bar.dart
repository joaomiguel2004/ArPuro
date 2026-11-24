import 'package:flutter/material.dart';

class DynamicIslandBar extends StatelessWidget {
  final bool isSynced;
  final String? statusText;

  const DynamicIslandBar({super.key, this.isSynced = true, this.statusText});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSynced ? Icons.wifi : Icons.wifi_off,
              size: 14,
              color: Colors.white,
            ),
            const SizedBox(width: 6),
            Text(
              statusText ?? (isSynced ? 'Sincronizado' : 'Modo Offline'),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
