import 'package:flutter/material.dart';

import '../tema/tema_app.dart';
import 'botao_principal.dart';

/// Tela ou lista sem nada ainda: explica o que fazer em seguida.
class EstadoVazio extends StatelessWidget {
  const EstadoVazio({
    super.key,
    required this.icone,
    required this.titulo,
    required this.explicacao,
    this.textoBotao,
    this.iconeBotao,
    this.aoTocarBotao,
  });

  final IconData icone;
  final String titulo;
  final String explicacao;
  final String? textoBotao;
  final IconData? iconeBotao;
  final VoidCallback? aoTocarBotao;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 112,
              height: 112,
              decoration: const BoxDecoration(
                color: CoresApp.principalClaro,
                shape: BoxShape.circle,
              ),
              child: Icon(icone, size: 60, color: CoresApp.principal),
            ),
            const SizedBox(height: MedidasApp.espacoG),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: textos.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(
              explicacao,
              textAlign: TextAlign.center,
              style: textos.bodyLarge?.copyWith(
                color: CoresApp.textoSecundario,
              ),
            ),
            if (textoBotao != null) ...[
              const SizedBox(height: MedidasApp.espacoG),
              BotaoPrincipal(
                texto: textoBotao!,
                icone: iconeBotao,
                aoTocar: aoTocarBotao,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
