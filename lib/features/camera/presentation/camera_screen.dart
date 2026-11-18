import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../data/location_service.dart';
import '../domain/captured_photo.dart';
import '../widgets/camera_frame_overlay.dart';
import '../widgets/camera_round_button.dart';
import '../widgets/gps_status_pill.dart';
import '../widgets/shutter_button.dart';

enum _CameraStatus { loading, ready, denied, unavailable }

class CameraScreen extends StatefulWidget {
  final LocationService locationService;

  const CameraScreen({
    super.key,
    this.locationService = const LocationService(),
  });

  /// Abre a câmera em tela cheia e devolve a foto capturada
  /// (ou `null` se o usuário fechar sem fotografar).
  static Future<CapturedPhoto?> open(BuildContext context) {
    return Navigator.of(context).push<CapturedPhoto>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => const CameraScreen(),
      ),
    );
  }

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  static const double _frameSize = 260;

  List<CameraDescription> _cameras = const [];
  int _cameraIndex = 0;
  CameraController? _controller;
  _CameraStatus _status = _CameraStatus.loading;
  bool _flashOn = false;
  bool _isCapturing = false;

  GpsStatus _gpsStatus = GpsStatus.searching;
  late final Future<GeoPoint?> _locationFuture;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _locationFuture = widget.locationService.getCurrentLocation();
    _locationFuture.then((location) {
      if (!mounted) return;
      setState(() {
        _gpsStatus = location != null ? GpsStatus.active : GpsStatus.unavailable;
      });
    });
    _initCameras();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // A câmera precisa ser liberada quando o app vai para segundo plano.
    if (state == AppLifecycleState.inactive) {
      final controller = _controller;
      if (controller == null) return;
      setState(() {
        _controller = null;
        _status = _CameraStatus.loading;
      });
      controller.dispose();
    } else if (state == AppLifecycleState.resumed &&
        _controller == null &&
        _cameras.isNotEmpty) {
      _startController(_cameraIndex);
    }
  }

  Future<void> _initCameras() async {
    try {
      _cameras = await availableCameras();
    } catch (_) {
      _cameras = const [];
    }
    if (!mounted) return;
    if (_cameras.isEmpty) {
      setState(() => _status = _CameraStatus.unavailable);
      return;
    }
    final backIndex = _cameras.indexWhere(
      (c) => c.lensDirection == CameraLensDirection.back,
    );
    await _startController(backIndex >= 0 ? backIndex : 0);
  }

  Future<void> _startController(int index) async {
    final previous = _controller;
    setState(() {
      _controller = null;
      _status = _CameraStatus.loading;
      _cameraIndex = index;
    });
    await previous?.dispose();

    final controller = CameraController(
      _cameras[index],
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await controller.initialize();
      await _applyFlash(controller);
    } on CameraException catch (e) {
      await controller.dispose();
      if (!mounted) return;
      const deniedCodes = {
        'CameraAccessDenied',
        'CameraAccessDeniedWithoutPrompt',
        'CameraAccessRestricted',
      };
      setState(() {
        _status = deniedCodes.contains(e.code)
            ? _CameraStatus.denied
            : _CameraStatus.unavailable;
      });
      return;
    }

    if (!mounted) {
      await controller.dispose();
      return;
    }
    setState(() {
      _controller = controller;
      _status = _CameraStatus.ready;
    });
  }

  Future<void> _applyFlash(CameraController controller) async {
    try {
      await controller.setFlashMode(_flashOn ? FlashMode.always : FlashMode.off);
    } catch (_) {
      // Câmera frontal e navegadores geralmente não suportam flash.
    }
  }

  Future<void> _toggleFlash() async {
    setState(() => _flashOn = !_flashOn);
    final controller = _controller;
    if (controller != null) await _applyFlash(controller);
  }

  void _switchCamera() {
    if (_cameras.length < 2 || _isCapturing) return;
    _startController((_cameraIndex + 1) % _cameras.length);
  }

  Future<void> _capture() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized || _isCapturing) {
      return;
    }
    setState(() => _isCapturing = true);
    try {
      final file = await controller.takePicture();
      await _finish(file);
    } on CameraException {
      _showError('Não foi possível tirar a foto. Tente novamente.');
    } finally {
      if (mounted) setState(() => _isCapturing = false);
    }
  }

  Future<void> _pickFromGallery() async {
    if (_isCapturing) return;
    try {
      final file = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (file != null) await _finish(file);
    } catch (_) {
      _showError('Não foi possível abrir a galeria.');
    }
  }

  Future<void> _finish(XFile file) async {
    final capturedAt = DateTime.now();
    // Se o GPS ainda estiver buscando, espera um pouco antes de desistir.
    final location = await _locationFuture.timeout(
      const Duration(seconds: 5),
      onTimeout: () => null,
    );
    if (!mounted) return;
    Navigator.of(context).pop(
      CapturedPhoto(
        file: file,
        capturedAt: capturedAt,
        latitude: location?.latitude,
        longitude: location?.longitude,
      ),
    );
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  String get _hintText {
    switch (_status) {
      case _CameraStatus.loading:
      case _CameraStatus.ready:
        return 'Enquadre o foco de poluição';
      case _CameraStatus.denied:
        return 'Permita o acesso à câmera nas configurações';
      case _CameraStatus.unavailable:
        return 'Câmera indisponível. Escolha uma foto da galeria.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = _status == _CameraStatus.ready ? _controller : null;
    final isReady = controller != null;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Positioned.fill(
              child: controller != null
                  ? _CameraPreviewCover(controller: controller)
                  : const _ViewfinderPlaceholder(),
            ),
            if (isReady) const Positioned.fill(child: _PreviewVignette()),
            Positioned.fill(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final hintTop = constraints.maxHeight / 2 + _frameSize / 2 + 24;
                  return Stack(
                    children: [
                      const Center(child: CameraFrameOverlay(size: _frameSize)),
                      Positioned(
                        top: hintTop,
                        left: 32,
                        right: 32,
                        child: Text(
                          _hintText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SafeArea(
              child: Stack(
                children: [
                  GpsStatusPill(status: _gpsStatus),
                  Positioned(
                    top: 50,
                    left: 24,
                    child: CameraRoundButton(
                      icon: Icons.close_rounded,
                      tooltip: 'Fechar câmera',
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    right: 24,
                    child: CameraRoundButton(
                      icon: _flashOn
                          ? Icons.flash_on_rounded
                          : Icons.flash_off_rounded,
                      tooltip: _flashOn ? 'Desligar flash' : 'Ligar flash',
                      onPressed: kIsWeb ? null : _toggleFlash,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: bottomInset + 32,
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: IconButton(
                        tooltip: 'Escolher da galeria',
                        onPressed: _pickFromGallery,
                        icon: const Icon(
                          Icons.image_outlined,
                          size: 28,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  ShutterButton(
                    onPressed: isReady ? _capture : null,
                    isBusy: _isCapturing,
                  ),
                  Expanded(
                    child: Center(
                      child: IconButton(
                        tooltip: 'Trocar câmera',
                        onPressed: _cameras.length > 1 ? _switchCamera : null,
                        icon: Icon(
                          Icons.cameraswitch_outlined,
                          size: 28,
                          color: _cameras.length > 1
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Preenche a tela inteira com o preview, cortando as bordas (como um BoxFit.cover).
class _CameraPreviewCover extends StatelessWidget {
  final CameraController controller;

  const _CameraPreviewCover({required this.controller});

  @override
  Widget build(BuildContext context) {
    // aspectRatio vem em paisagem (largura/altura do sensor); em retrato invertemos.
    final aspectRatio = controller.value.aspectRatio;
    return ClipRect(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: 100,
          height: 100 * aspectRatio,
          child: CameraPreview(controller),
        ),
      ),
    );
  }
}

/// Fundo escuro com brilho central, exibido enquanto a câmera não está pronta.
class _ViewfinderPlaceholder extends StatelessWidget {
  const _ViewfinderPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, -0.05),
          radius: 0.9,
          colors: [Color(0xFF1E293B), Color(0xFF0B0F17)],
        ),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.7, 1.0],
            colors: [Color(0x00000000), Color(0x00000000), Color(0xFF000000)],
          ),
        ),
      ),
    );
  }
}

/// Escurece topo e base do preview para manter os controles legíveis.
class _PreviewVignette extends StatelessWidget {
  const _PreviewVignette();

  @override
  Widget build(BuildContext context) {
    return const IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.18, 0.75, 1.0],
            colors: [
              Color(0x99000000),
              Color(0x00000000),
              Color(0x00000000),
              Color(0xB3000000),
            ],
          ),
        ),
      ),
    );
  }
}
