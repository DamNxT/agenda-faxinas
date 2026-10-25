import 'package:flutter/material.dart';

import '../../dados/agenda/calculo_agenda.dart';
import '../../dados/banco/banco_dados.dart';
import '../../tema/tema_app.dart';
import '../../util/datas.dart';
import '../../widgets/avatar_cliente.dart';

export '../../widgets/titulo_campo.dart';

/// Botão grande que fica colorido com um "visto" quando está escolhido.
class BotaoEscolha extends StatelessWidget {
  const BotaoEscolha({
    super.key,
    required this.texto,
    required this.selecionado,
    required this.aoTocar,
  });

  final String texto;
  final bool selecionado;
  final VoidCallback aoTocar;

  static const _tamanho = Size(0, 68);
  static const _letra = TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
  static final _forma = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(14),
  );

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selecionado,
      child: selecionado
          ? ElevatedButton.icon(
              onPressed: aoTocar,
              icon: const Icon(Icons.check_circle, size: 30),
              label: Text(texto),
              style: ElevatedButton.styleFrom(
                backgroundColor: CoresApp.principal,
                foregroundColor: Colors.white,
                minimumSize: _tamanho,
                textStyle: _letra,
                shape: _forma,
              ),
            )
          : OutlinedButton(
              onPressed: aoTocar,
              style: OutlinedButton.styleFrom(
                foregroundColor: CoresApp.texto,
                minimumSize: _tamanho,
                textStyle: _letra,
                shape: _forma,
                side: const BorderSide(color: CoresApp.borda, width: 2),
              ),
              child: Text(texto),
            ),
    );
  }
}

/// Lista para escolher o cliente.
class SeletorCliente extends StatelessWidget {
  const SeletorCliente({
    super.key,
    required this.clientes,
    required this.clienteId,
    required this.aoMudar,
  });

  final List<Cliente> clientes;
  final int? clienteId;
  final ValueChanged<int?> aoMudar;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      initialValue: clienteId,
      isExpanded: true,
      itemHeight: 64,
      menuMaxHeight: 480,
      style: const TextStyle(fontSize: 22, color: CoresApp.texto),
      hint: const Text('Toque para escolher', style: TextStyle(fontSize: 22)),
      items: [
        for (final c in clientes)
          DropdownMenuItem(
            value: c.id,
            child: Row(
              children: [
                AvatarCliente(nome: c.nome, tamanho: 40),
                const SizedBox(width: 12),
                Expanded(child: Text(c.nome, overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
      ],
      onChanged: aoMudar,
      validator: (valor) => valor == null ? 'Escolha o cliente' : null,
    );
  }
}

/// Mostra a data escolhida; tocando, abre o calendário para trocar.
class BotaoData extends StatelessWidget {
  const BotaoData({super.key, required this.data, required this.aoMudar});

  final DateTime data;
  final ValueChanged<DateTime> aoMudar;

  Future<void> _escolher(BuildContext context) async {
    final escolhida = await showDatePicker(
      context: context,
      initialDate: data,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      helpText: 'Escolha o dia',
      cancelText: 'Cancelar',
      confirmText: 'OK',
    );
    if (escolhida != null) aoMudar(soDia(escolhida));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OutlinedButton.icon(
          onPressed: () => _escolher(context),
          icon: const Icon(Icons.calendar_month, size: 32),
          label: Text(formatarDiaCurto(data)),
          style: OutlinedButton.styleFrom(
            foregroundColor: CoresApp.texto,
            minimumSize: const Size.fromHeight(72),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            textStyle: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            side: const BorderSide(color: CoresApp.borda, width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Toque acima para trocar o dia',
          style: TextStyle(fontSize: 18, color: CoresApp.textoSecundario),
        ),
      ],
    );
  }
}

/// Ex.: "Fixa: toda semana", "Fixa: a cada 15 dias", "Só desta vez".
String descreverFaxina(FaxinaDoDia faxina) {
  if (faxina.tipo == TipoFaxina.avulsa) return 'Só desta vez';
  return switch (faxina.regra?.intervaloSemanas) {
    1 => 'Fixa: toda semana',
    2 => 'Fixa: a cada 15 dias',
    final n => 'Fixa: a cada $n semanas',
  };
}
