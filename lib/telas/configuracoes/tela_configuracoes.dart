import 'package:flutter/material.dart';

import '../../widgets/tela_vazia.dart';

class TelaConfiguracoes extends StatelessWidget {
  const TelaConfiguracoes({super.key});

  @override
  Widget build(BuildContext context) {
    return const TelaVazia(
      titulo: 'Configurações',
      icone: Icons.settings,
      tituloVazio: 'Em breve',
      mensagem:
          'Aqui você vai escolher o horário do lembrete diário '
          'e outros ajustes do aplicativo.',
    );
  }
}
