import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/theme/app_colors.dart';
import '../../camera/domain/captured_photo.dart';
import '../../camera/presentation/camera_screen.dart';
import '../../health/presentation/health_screen.dart';
import '../../index_info/presentation/index_info_screen.dart';
import '../../map/presentation/map_screen.dart';
import '../../profile/presentation/profile_providers.dart';
import '../../profile/presentation/profile_screen.dart';
import '../../report/domain/report_models.dart';
import '../../report/presentation/new_report_screen.dart';
import '../data/home_location_service.dart';
import '../domain/air_quality.dart';
import '../presentation/home_providers.dart';
import '../widgets/aqi_widget.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/dynamic_island_bar.dart';
import '../widgets/health_card.dart';
import '../widgets/home_header.dart';

class HomeScreen extends ConsumerStatefulWidget {
  /// Opens the camera and returns its captured photo. Replaceable in tests.
  final Future<CapturedPhoto?> Function(BuildContext context) openCamera;

  const HomeScreen({super.key, this.openCamera = CameraScreen.open});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentNavIndex = 0;
  final List<MapReport> _mapReports = List.of(MapScreen.defaultMapReports);
  CapturedPhoto? _capturedPhoto;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _refreshTimer = Timer.periodic(const Duration(minutes: 15), (_) {
      if (mounted) unawaited(_refreshAirQuality());
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

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
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const ProfileScreen()));
  }

  void _openIndexInfo() {
    IndexInfoSheet.show(context);
  }

  Future<void> _refreshAirQuality() async {
    ref.invalidate(homeLocationProvider);
    try {
      await ref.refresh(homeAirQualityProvider.future).then<void>((_) {});
    } catch (_) {
      // The provider renders the backend or location error state.
    }
  }

  Widget _buildAqiWidget(AsyncValue<HomeAirQuality> state) {
    return state.when(
      data: (reading) => AqiWidget(
        aqiValue: reading.index,
        band: reading.band,
        classification: 'Qualidade ${reading.band.label}',
        description:
            '${reading.qualityDescription} Poluente de maior índice: ${reading.dominantPollutant}.',
        isStale: reading.isStale,
        updatedAt: reading.observedAt,
        forecast: reading.forecast,
        onInfoTap: _openIndexInfo,
      ),
      loading: () => AqiWidget(isLoading: true, onInfoTap: _openIndexInfo),
      error: (error, stackTrace) {
        final permissionPermanentlyDenied =
            error is LocationPermissionPermanentlyDeniedException;
        final message = permissionPermanentlyDenied
            ? 'A permissão de localização está bloqueada nas configurações do Android.'
            : error is LocationPermissionDeniedException
            ? 'Permita o acesso à localização para consultar a qualidade do ar da sua região.'
            : error is NoHomeLocationException
            ? 'Sem localização conhecida. Ative o GPS ou permita o acesso à localização para consultar o ar da sua região.'
            : error.toString().contains('Backend não configurado')
            ? 'O serviço de qualidade do ar ainda não foi configurado.'
            : kDebugMode
            ? 'Falha ao consultar a qualidade do ar: $error'
            : 'Não foi possível obter o índice agora. Verifique sua conexão e tente novamente.';
        return AqiWidget(
          errorMessage: message,
          onRetry: permissionPermanentlyDenied
              ? null
              : () => unawaited(_refreshAirQuality()),
          onOpenSettings: permissionPermanentlyDenied
              ? () => unawaited(Geolocator.openAppSettings())
              : null,
          onInfoTap: _openIndexInfo,
        );
      },
    );
  }

  Widget _buildRiskCard(AsyncValue<HomeAirQuality> state) {
    return state.when(
      data: (reading) => HealthCard(
        title: reading.risk.title,
        description: reading.riskGuidance,
        accentColor: Color(reading.risk.colorValue),
        iconBackgroundColor: Color(reading.risk.backgroundColorValue),
      ),
      loading: () => const HealthCard(
        title: 'Calculando risco respiratório',
        description: 'Aguarde o carregamento do índice e das recomendações.',
        accentColor: AppColors.textMuted,
        iconBackgroundColor: AppColors.subtleBg,
      ),
      error: (error, stackTrace) => const HealthCard(
        title: 'Risco respiratório indisponível',
        description: 'Tente atualizar o índice de qualidade do ar.',
        accentColor: AppColors.textMuted,
        iconBackgroundColor: AppColors.subtleBg,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    final airQualityState = ref.watch(homeAirQualityProvider);
    final reading = airQualityState.asData?.value;
    final locationState = ref.watch(homeLocationProvider);
    final locationLabel = locationState.when(
      data: (location) => location.label,
      loading: () => 'Buscando localização',
      error: (_, _) => 'Localização indisponível',
    );
    final locationPermissionNeedsSettings =
        locationState.asData?.value.permissionPermanentlyDenied == true;
    final statusText = reading == null
        ? (airQualityState.hasError ? 'Sem dados' : 'Atualizando')
        : reading.isStale
        ? 'Desatualizado'
        : 'Sincronizado';

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
                    DynamicIslandBar(
                      isSynced:
                          !airQualityState.hasError && reading?.isStale != true,
                      statusText: statusText,
                    ),
                    HomeHeader(
                      onProfileTap: _openProfile,
                      locationLabel: locationLabel,
                      updatedAt: reading?.observedAt,
                      profileInitial:
                          ref.watch(userProfileProvider).asData?.value.initial ??
                          'U',
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _refreshAirQuality,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 110),
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          child: Column(
                            children: [
                              if (locationPermissionNeedsSettings) ...[
                                Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFF7ED),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.location_off_outlined,
                                        color: Color(0xFF9A3412),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 10),
                                      const Expanded(
                                        child: Text(
                                          'A localização está bloqueada. O app continua usando a última posição salva.',
                                          style: TextStyle(
                                            color: Color(0xFF7C2D12),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () => unawaited(
                                          Geolocator.openAppSettings(),
                                        ),
                                        child: const Text('Ativar'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              _buildAqiWidget(airQualityState),
                              const SizedBox(height: 0),
                              _buildRiskCard(airQualityState),
                            ],
                          ),
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
