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
import '../../map/presentation/map_screen.dart';
import '../../camera/domain/captured_photo.dart';
import '../../camera/presentation/camera_screen.dart';
import '../../report/domain/report_models.dart';
import '../../report/presentation/new_report_screen.dart';

class HomeScreen extends StatefulWidget {
  /// Abre a câmera e devolve a foto capturada. Substituível nos testes.
  final Future<CapturedPhoto?> Function(BuildContext context) openCamera;

  const HomeScreen({super.key, this.openCamera = CameraScreen.open});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;
  final bool _isSynced = true;
  final List<MapReport> _mapReports = List.of(MapScreen.defaultMapReports);
  CapturedPhoto? _capturedPhoto;

  void _onNavTap(int index) {
    if (index == 2) {
      _openCamera();
      return;
    }
    if (index == _currentNavIndex) return;
    setState(() => _currentNavIndex = index);
  }

  Future<void> _openCamera() async {
    final photo = await widget.openCamera(context);
    if (photo == null || !mounted) return;
    setState(() {
      _capturedPhoto = photo;
      _currentNavIndex = 2;
    });
  }

  void _handleReportSubmitted(MapReport report) {
    setState(() {
      _mapReports.add(report);
      _capturedPhoto = null;
      _currentNavIndex = 0;
    });
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
              index: _currentNavIndex,
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
                MapScreen(reports: _mapReports),
                NewReportScreen(
                  photo: _capturedPhoto,
                  onRetake: _openCamera,
                  onReportSubmitted: _handleReportSubmitted,
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
