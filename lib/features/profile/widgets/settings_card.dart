import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class SettingsCard extends StatefulWidget {
  const SettingsCard({super.key});
  @override
  State<SettingsCard> createState() => _SettingsCardState();
}

class _SettingsCardState extends State<SettingsCard> {
  bool _notificationsEnabled = true;
  bool _anonymousMode = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(padding: EdgeInsets.only(left: 4, bottom: 12), child: Text('PRIVACIDADE E ALERTAS', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textMain, letterSpacing: 0.5))),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(24), border: Border.all(color: AppColors.surfaceBorder)),
          child: Column(
            children: [
              _SettingRow(title: 'Notificações de Risco', subtitle: 'Alertas em picos de poluição', value: _notificationsEnabled, onChanged: (v) => setState(() => _notificationsEnabled = v), showDivider: true),
              _SettingRow(title: 'Modo Anônimo Padrão', subtitle: 'Ocultar ID ao abrir a câmera', value: _anonymousMode, onChanged: (v) => setState(() => _anonymousMode = v), showDivider: false),
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool showDivider;
  const _SettingRow({required this.title, required this.subtitle, required this.value, required this.onChanged, required this.showDivider});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(border: showDivider ? const Border(bottom: BorderSide(color: AppColors.subtleBg, width: 1)) : null),
      child: Row(
        children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textMain)),
            const SizedBox(height: 2),
            Text(subtitle, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textMuted)),
          ])),
          Switch(value: value, onChanged: onChanged, activeTrackColor: AppColors.primary, inactiveTrackColor: AppColors.surfaceBorder, thumbColor: WidgetStateProperty.all(Colors.white), materialTapTargetSize: MaterialTapTargetSize.shrinkWrap),
        ],
      ),
    );
  }
}
