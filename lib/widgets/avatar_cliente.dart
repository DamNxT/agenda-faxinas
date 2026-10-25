import 'package:flutter/material.dart';

import '../tema/tema_app.dart';

/// "maria" -> "M". Nome vazio vira "?".
String inicialDoNome(String nome) {
  final limpo = nome.trim();
  return limpo.isEmpty ? '?' : limpo.characters.first.toUpperCase();
}

/// Cada nome sempre recebe a mesma cor.
Color corDoCliente(String nome) {
  final chave = nome.trim().toLowerCase();
  final soma = chave.codeUnits.fold<int>(0, (total, c) => total + c);
  return CoresApp.avatares[soma % CoresApp.avatares.length];
}

/// Círculo colorido com a inicial do cliente.
class AvatarCliente extends StatelessWidget {
  const AvatarCliente({super.key, required this.nome, this.tamanho = 56});

  final String nome;
  final double tamanho;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Container(
        width: tamanho,
        height: tamanho,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: corDoCliente(nome),
          shape: BoxShape.circle,
        ),
        child: Text(
          inicialDoNome(nome),
          style: TextStyle(
            color: Colors.white,
            fontSize: tamanho * 0.45,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
