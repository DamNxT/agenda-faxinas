import 'package:flutter/material.dart';

import 'estado_vazio.dart';

/// Tela inteira que ainda será construída, com a explicação do que virá.
class TelaVazia extends StatelessWidget {
  const TelaVazia({
    super.key,
    required this.titulo,
    required this.icone,
    required this.tituloVazio,
    required this.mensagem,
  });

  final String titulo;
  final IconData icone;
  final String tituloVazio;
  final String mensagem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(titulo)),
      body: EstadoVazio(
        icone: icone,
        titulo: tituloVazio,
        explicacao: mensagem,
      ),
    );
  }
}
