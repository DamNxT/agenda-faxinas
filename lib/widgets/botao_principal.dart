import 'package:flutter/material.dart';

import '../tema/tema_app.dart';

enum TipoBotao {
  /// Fundo colorido: a ação mais importante da tela.
  principal,

  /// Só contorno: ações de apoio ("Fechar", "Não, voltar").
  secundario,
}

/// Botão grande, largura total e cantos arredondados.
/// [cor] troca a cor (ex.: [CoresApp.erro] para "Excluir").
class BotaoPrincipal extends StatelessWidget {
  const BotaoPrincipal({
    super.key,
    required this.texto,
    required this.aoTocar,
    this.icone,
    this.tipo = TipoBotao.principal,
    this.cor,
  });

  final String texto;
  final VoidCallback? aoTocar;
  final IconData? icone;
  final TipoBotao tipo;
  final Color? cor;

  @override
  Widget build(BuildContext context) {
    final corBotao = cor ?? CoresApp.principal;
    final rotulo = Text(texto, textAlign: TextAlign.center);
    final iconeWidget = icone == null ? null : Icon(icone);

    if (tipo == TipoBotao.secundario) {
      final estilo = OutlinedButton.styleFrom(
        foregroundColor: corBotao,
        side: BorderSide(color: corBotao, width: 2),
        minimumSize: const Size.fromHeight(MedidasApp.alturaBotaoPrincipal),
      );
      return iconeWidget == null
          ? OutlinedButton(onPressed: aoTocar, style: estilo, child: rotulo)
          : OutlinedButton.icon(
              onPressed: aoTocar,
              style: estilo,
              icon: iconeWidget,
              label: rotulo,
            );
    }

    final estilo = ElevatedButton.styleFrom(
      backgroundColor: corBotao,
      foregroundColor: Colors.white,
    );
    return iconeWidget == null
        ? ElevatedButton(onPressed: aoTocar, style: estilo, child: rotulo)
        : ElevatedButton.icon(
            onPressed: aoTocar,
            style: estilo,
            icon: iconeWidget,
            label: rotulo,
          );
  }
}

/// Área fixa no rodapé da tela para o botão principal.
class RodapeBotao extends StatelessWidget {
  const RodapeBotao({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: child,
      ),
    );
  }
}
