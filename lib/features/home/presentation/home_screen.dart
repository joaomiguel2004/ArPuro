import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/dynamic_island_bar.dart';
import '../widgets/home_header.dart';
import '../widgets/aqi_widget.dart';
import '../widgets/health_card.dart';
import '../widgets/bottom_nav_bar.dart';
import '../../profile/presentation/profile_screen.dart';
import '../../index_info/presentation/index_info_screen.dart';
import '../../health/presentation/health_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;
  final bool _isSynced = true;

  void _onNavTap(int index) {
    if (index == 2) {
      _showComingSoon('Câmera / Formulário');
      return;
    }
    if (index == 1) {
      _showComingSoon('Mapa');
      return;
    }
    if (index == _currentNavIndex) return;

    if (index == 0 || index == 3) {
      setState(() => _currentNavIndex = index);
    }
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature — em breve!'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.darkSlate,
      ),
    );
  }

  void _openProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ProfileScreen()),
    );
  }

  void _openIndexInfo() {
    IndexInfoSheet.show(context);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            IndexedStack(
              index: _currentNavIndex == 3 ? 1 : 0,
              children: [
                Column(
                  children: [
                    DynamicIslandBar(isSynced: _isSynced),
                    HomeHeader(onProfileTap: _openProfile),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 110),
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            AqiWidget(
                              aqiValue: 25,
                              classification: 'Qualidade Boa',
                              description:
                                  'Ar limpo hoje. Seguro para todos os grupos sensíveis.',
                              onInfoTap: _openIndexInfo,
                            ),
                            const HealthCard(
                              title: 'Risco Respiratório Baixo',
                              description:
                                  'Sem restrições para asmáticos nas próximas 6 horas.',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const HealthScreen(),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: HomeBottomNavBar(
                currentIndex: _currentNavIndex,
                onTap: _onNavTap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
