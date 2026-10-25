import 'package:flutter/material.dart';

/// Título grande acima de cada campo ou pergunta de um formulário.
class TituloCampo extends StatelessWidget {
  const TituloCampo(this.texto, {super.key});

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(texto, style: Theme.of(context).textTheme.titleLarge),
    );
  }
}
