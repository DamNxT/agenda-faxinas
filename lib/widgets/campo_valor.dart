import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../tema/tema_app.dart';
import '../util/dinheiro.dart';
import 'titulo_campo.dart';

/// Confere o valor digitado. Devolve a mensagem de erro, ou null se estiver ok.
String? validarValor(
  String? texto, {
  bool obrigatorio = true,
  String mensagemVazio = 'Digite o valor',
}) {
  final limpo = (texto ?? '').trim();
  if (limpo.isEmpty) return obrigatorio ? mensagemVazio : null;
  if (converterParaCentavos(limpo) == null) {
    return 'Valor errado. Escreva, por exemplo, 150,00';
  }
  return null;
}

/// Campo de dinheiro: mostra "R$" na frente, abre o teclado de números e
/// aceita "150", "150,00" ou "1.500,00".
class CampoValor extends StatelessWidget {
  const CampoValor({
    super.key,
    required this.controlador,
    this.rotulo = 'Valor',
    this.obrigatorio = true,
    this.mensagemVazio = 'Digite o valor',
  });

  final TextEditingController controlador;
  final String rotulo;
  final bool obrigatorio;
  final String mensagemVazio;

  static const _estilo = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: CoresApp.texto,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TituloCampo(rotulo),
        TextFormField(
          controller: controlador,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
          ],
          style: _estilo,
          decoration: const InputDecoration(
            prefixText: 'R\$ ',
            prefixStyle: _estilo,
            hintText: '0,00',
          ),
          validator: (texto) => validarValor(
            texto,
            obrigatorio: obrigatorio,
            mensagemVazio: mensagemVazio,
          ),
        ),
      ],
    );
  }
}
