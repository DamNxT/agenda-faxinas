import 'package:flutter/material.dart';

import '../../widgets/tela_vazia.dart';

class TelaBackup extends StatelessWidget {
  const TelaBackup({super.key});

  @override
  Widget build(BuildContext context) {
    return const TelaVazia(
      titulo: 'Backup',
      icone: Icons.save,
      tituloVazio: 'Em breve',
      mensagem:
          'Aqui você vai poder guardar uma cópia dos seus dados, '
          'para não perder nada se trocar de celular.',
    );
  }
}
