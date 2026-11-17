import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class HomeBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const HomeBottomNavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final barHeight = 70.0 + bottomPadding;
    const fabOverhang = 24.0;

    return SizedBox(
      height: barHeight + fabOverhang,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0, right: 0, bottom: 0, height: barHeight,
            child: ClipRect(
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.95),
                    border: const Border(top: BorderSide(color: Color(0x99E2E8F0), width: 1)),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0, right: 0, bottom: 0, height: barHeight + fabOverhang,
            child: Padding(
              padding: EdgeInsets.only(bottom: bottomPadding),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(child: Padding(padding: const EdgeInsets.only(bottom: 12), child: _NavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Início', isActive: currentIndex == 0, onTap: () => onTap(0)))),
                  Expanded(child: Padding(padding: const EdgeInsets.only(bottom: 12), child: _NavItem(icon: Icons.map_outlined, activeIcon: Icons.map, label: 'Mapa', isActive: currentIndex == 1, onTap: () => onTap(1)))),
                  Padding(padding: const EdgeInsets.only(bottom: 8), child: _CameraFab(onTap: () => onTap(2))),
                  Expanded(child: Padding(padding: const EdgeInsets.only(bottom: 12), child: _NavItem(icon: Icons.shield_outlined, activeIcon: Icons.shield, label: 'Saúde', isActive: currentIndex == 3, onTap: () => onTap(3)))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({required this.icon, required this.activeIcon, required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isActive ? activeIcon : icon, size: 22, color: isActive ? AppColors.textMain : AppColors.textLight),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: isActive ? AppColors.textMain : AppColors.textLight)),
        ],
      ),
    );
  }
}

class _CameraFab extends StatelessWidget {
  final VoidCallback onTap;
  const _CameraFab({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Transform.rotate(
          angle: 0.785398,
          child: Container(
            width: 58, height: 58,
            decoration: BoxDecoration(
              color: AppColors.textMain,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [BoxShadow(color: AppColors.darkSlate.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10))],
            ),
            child: Transform.rotate(
              angle: -0.785398,
              child: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 24),
            ),
          ),
        ),
      ),
    );
  }
}
