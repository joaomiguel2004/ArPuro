import 'package:flutter/material.dart';

/// Aviso exibido na Nova Denúncia quando o dispositivo está sem conexão.
class OfflineWarningBanner extends StatelessWidget {
  const OfflineWarningBanner({super.key});

  static const _text = Color(0xFFB45309);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, size: 22, color: _text),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Sem conexão de internet no momento. Sua denúncia será salva no '
              'celular e enviada automaticamente quando o sinal voltar.',
              style: TextStyle(
                fontSize: 13,
                height: 1.45,
                fontWeight: FontWeight.w600,
                color: _text,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
