import 'package:flutter/material.dart';

import '../../widgets/tela_vazia.dart';

class TelaGanhos extends StatelessWidget {
  const TelaGanhos({super.key});

  @override
  Widget build(BuildContext context) {
    return const TelaVazia(
      titulo: 'Ganhos',
      icone: Icons.payments,
      tituloVazio: 'Seus ganhos vão aparecer aqui',
      mensagem:
          'Em breve você vai anotar quanto recebeu em cada faxina '
          'e ver o total do dia e do mês.',
    );
  }
}
