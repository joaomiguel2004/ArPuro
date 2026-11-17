import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/user_card.dart';
import '../widgets/stats_grid.dart';
import '../widgets/health_chips.dart';
import '../widgets/settings_card.dart';
import '../widgets/export_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(24)),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.person_outline, size: 14, color: Color(0xFF10B981)),
                    SizedBox(width: 6),
                    Text('Sua Conta', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.surface, borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.surfaceBorder),
                        boxShadow: const [BoxShadow(color: Color(0x05000000), blurRadius: 4, offset: Offset(0, 2))],
                      ),
                      child: const Icon(Icons.arrow_back, size: 20, color: AppColors.textMain),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text('Seu Perfil', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textMain, letterSpacing: -0.5)),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                physics: const BouncingScrollPhysics(),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserCard(),
                    SizedBox(height: 20),
                    StatsGrid(),
                    SizedBox(height: 24),
                    HealthChips(),
                    SizedBox(height: 24),
                    SettingsCard(),
                    SizedBox(height: 24),
                    ExportButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
