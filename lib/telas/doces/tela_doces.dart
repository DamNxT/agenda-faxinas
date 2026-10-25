import 'package:flutter/material.dart';

import '../../widgets/tela_vazia.dart';

class TelaDoces extends StatelessWidget {
  const TelaDoces({super.key});

  @override
  Widget build(BuildContext context) {
    return const TelaVazia(
      titulo: 'Doces',
      icone: Icons.cake,
      tituloVazio: 'Vendas de doces',
      mensagem:
          'Em breve você vai anotar aqui os doces que vendeu. '
          'O valor vai somar nos ganhos do mês.',
    );
  }
}
