import 'package:flutter/material.dart';

import '../tema/tema_app.dart';
import 'botao_principal.dart';

/// Pergunta antes de uma ação que não dá para desfazer (ex.: excluir).
/// Devolve true só se a pessoa tocar no botão de confirmar.
Future<bool> confirmarAcao(
  BuildContext context, {
  required String titulo,
  required String mensagem,
  required String textoConfirmar,
  String textoCancelar = 'Não, voltar',
  bool perigosa = true,
}) async {
  final confirmou = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(titulo),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(mensagem),
          const SizedBox(height: 28),
          BotaoPrincipal(
            texto: textoCancelar,
            tipo: TipoBotao.secundario,
            cor: CoresApp.texto,
            aoTocar: () => Navigator.of(context).pop(false),
          ),
          const SizedBox(height: MedidasApp.espaco),
          BotaoPrincipal(
            texto: textoConfirmar,
            cor: perigosa ? CoresApp.erro : CoresApp.principal,
            aoTocar: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    ),
  );
  return confirmou ?? false;
}

/// Explica algo e espera a pessoa tocar em "Entendi".
Future<void> explicar(
  BuildContext context, {
  required String titulo,
  required String mensagem,
}) {
  return showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(titulo),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(mensagem),
          const SizedBox(height: 28),
          BotaoPrincipal(
            texto: 'Entendi',
            aoTocar: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    ),
  );
}

/// Aviso rápido na parte de baixo da tela. Com [aoDesfazer], mostra o botão
/// "Desfazer" (use para ações que dá para voltar atrás).
void mostrarAviso(
  BuildContext context,
  String mensagem, {
  VoidCallback? aoDesfazer,
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(mensagem),
        duration: Duration(seconds: aoDesfazer == null ? 4 : 8),
        persist: false,
        action: aoDesfazer == null
            ? null
            : SnackBarAction(label: 'Desfazer', onPressed: aoDesfazer),
      ),
    );
}
