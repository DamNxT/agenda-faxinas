import 'package:flutter/material.dart';

import '../../dados/agenda/calculo_agenda.dart';
import '../../dados/banco/banco_dados.dart';
import '../../dados/repositorios/repositorio_agenda.dart';
import '../../tema/tema_app.dart';
import '../../util/datas.dart';
import '../../util/dinheiro.dart';
import '../../widgets/avatar_cliente.dart';
import '../../widgets/avisos.dart';
import '../../widgets/botao_principal.dart';
import '../../widgets/campo_valor.dart';

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
/// Se foi remarcada, inclui o aviso visual: " (remarcada de segunda)".
String descreverFaxina(FaxinaDoDia faxina) {
  final base = switch (faxina.tipo) {
    TipoFaxina.avulsa => 'Só desta vez',
    TipoFaxina.fixa => switch (faxina.regra?.intervaloSemanas) {
        1 => 'Fixa: toda semana',
        2 => 'Fixa: a cada 15 dias',
        final n => 'Fixa: a cada $n semanas',
      },
  };
  final original = faxina.dataOriginal;
  if (original != null) {
    final diaSemana = nomesDiasSemana[original.weekday]!.toLowerCase();
    return '$base (remarcada de $diaSemana)';
  }
  return base;
}

enum _OpcaoFaxina {
  registrarDiaria,
  removerDiaria,
  mudarDia,
  cancelar,
  encerrarFixa,
}

/// Janela de opções ao tocar em uma faxina: Registrar diária, Mudar de dia, Cancelar ou Encerrar.
Future<void> mostrarOpcoesFaxina({
  required BuildContext context,
  required FaxinaDoDia faxina,
  required DadosAgenda dados,
  required RepositorioAgenda repositorio,
  DateTime? hoje,
  VoidCallback? aoAtualizar,
}) async {
  final cliente = dados.clientes[faxina.clienteId];
  if (cliente == null) return;

  final dataAtual = faxina.data;
  final dataOriginal = faxina.dataOriginal ?? dataAtual;
  final diaHoje = soDia(hoje ?? DateTime.now());
  final jaPassouOuHoje = !dataAtual.isAfter(diaHoje);
  final registroExistente = dados.registroDe(faxina);

  final opcao = await showModalBottomSheet<_OpcaoFaxina>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (ctx) => SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(cliente.nome, style: Theme.of(ctx).textTheme.headlineMedium),
            const SizedBox(height: 4),
            Text(
              'Faxina de ${formatarDiaCompleto(dataAtual)}',
              style: Theme.of(ctx).textTheme.bodyLarge?.copyWith(
                    color: CoresApp.textoSecundario,
                  ),
            ),
            const SizedBox(height: 20),
            if (jaPassouOuHoje) ...[
              ElevatedButton.icon(
                onPressed: () =>
                    Navigator.of(ctx).pop(_OpcaoFaxina.registrarDiaria),
                icon: const Icon(Icons.payments, size: 28),
                label: Text(
                  registroExistente != null
                      ? 'Editar diária recebida'
                      : 'Registrar diária',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: CoresApp.sucesso,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(60),
                  alignment: Alignment.centerLeft,
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (registroExistente != null) ...[
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () =>
                      Navigator.of(ctx).pop(_OpcaoFaxina.removerDiaria),
                  icon: const Icon(Icons.money_off,
                      size: 28, color: CoresApp.erro),
                  label: const Text(
                    'Remover registro de diária',
                    style: TextStyle(color: CoresApp.erro),
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(60),
                    alignment: Alignment.centerLeft,
                    foregroundColor: CoresApp.erro,
                    side: const BorderSide(color: CoresApp.erro, width: 2),
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 12),
            ],
            OutlinedButton.icon(
              onPressed: () => Navigator.of(ctx).pop(_OpcaoFaxina.mudarDia),
              icon: const Icon(Icons.calendar_today, size: 28),
              label: const Text('Mudar de dia'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(60),
                alignment: Alignment.centerLeft,
                foregroundColor: CoresApp.texto,
                textStyle:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => Navigator.of(ctx).pop(_OpcaoFaxina.cancelar),
              icon: const Icon(Icons.cancel_outlined,
                  size: 28, color: CoresApp.erro),
              label: const Text('Cancelar esta faxina',
                  style: TextStyle(color: CoresApp.erro)),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(60),
                alignment: Alignment.centerLeft,
                foregroundColor: CoresApp.erro,
                side: const BorderSide(color: CoresApp.erro, width: 2),
                textStyle:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            if (faxina.tipo == TipoFaxina.fixa && faxina.regra != null) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () =>
                    Navigator.of(ctx).pop(_OpcaoFaxina.encerrarFixa),
                icon: const Icon(Icons.event_busy_outlined,
                    size: 28, color: CoresApp.erro),
                label: const Text('Encerrar faxina fixa para sempre',
                    style: TextStyle(color: CoresApp.erro)),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(60),
                  alignment: Alignment.centerLeft,
                  foregroundColor: CoresApp.erro,
                  side: const BorderSide(color: CoresApp.erro, width: 2),
                  textStyle: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
            const SizedBox(height: 16),
            BotaoPrincipal(
              texto: 'Voltar',
              tipo: TipoBotao.secundario,
              aoTocar: () => Navigator.of(ctx).pop(),
            ),
          ],
        ),
      ),
    ),
  );

  if (opcao == null || !context.mounted) return;

  switch (opcao) {
    case _OpcaoFaxina.registrarDiaria:
      final valorInicial = registroExistente?.valorRecebidoCentavos ??
          cliente.valorPadraoCentavos;
      final novoValor = await _mostrarDialogoRegistrarDiaria(
        context: context,
        clienteNome: cliente.nome,
        data: dataAtual,
        valorInicialCentavos: valorInicial,
      );
      if (novoValor == null || !context.mounted) return;

      await repositorio.salvarRegistroDiaria(
        clienteId: faxina.clienteId,
        data: dataAtual,
        valorRecebidoCentavos: novoValor,
      );
      if (!context.mounted) return;

      aoAtualizar?.call();
      mostrarAviso(
        context,
        'Diária de ${formatarReais(novoValor)} registrada!',
      );

    case _OpcaoFaxina.removerDiaria:
      if (registroExistente == null) return;
      final confirmou = await confirmarAcao(
        context,
        titulo: 'Remover diária?',
        mensagem:
            'O registro de valor recebido no dia ${formatarDiaCurto(dataAtual)} será removido.',
        textoConfirmar: 'Sim, remover',
      );
      if (!confirmou || !context.mounted) return;

      await repositorio.excluirRegistroDiaria(registroExistente.id);
      if (!context.mounted) return;

      aoAtualizar?.call();
      mostrarAviso(context, 'Registro de diária removido.');

    case _OpcaoFaxina.mudarDia:
      final novaData = await showDatePicker(
        context: context,
        initialDate: dataAtual,
        firstDate: DateTime(2020),
        lastDate: DateTime(2100),
        helpText: 'Escolha a nova data para a faxina',
        cancelText: 'Cancelar',
        confirmText: 'OK',
      );
      if (novaData == null || !context.mounted) return;
      final destino = soDia(novaData);
      if (mesmoDia(destino, dataAtual)) return;

      await repositorio.moverFaxina(faxina: faxina, novaData: destino);
      if (!context.mounted) return;

      aoAtualizar?.call();
      mostrarAviso(
        context,
        'Faxina movida para ${formatarDiaCurto(destino)}.',
        aoDesfazer: () async {
          if (faxina.tipo == TipoFaxina.fixa && faxina.regra != null) {
            await repositorio.removerExcecao(
              regraId: faxina.regra!.id,
              dataOriginal: dataOriginal,
            );
          } else {
            await repositorio.moverFaxina(faxina: faxina, novaData: dataAtual);
          }
          aoAtualizar?.call();
        },
      );

    case _OpcaoFaxina.cancelar:
      final confirmou = await confirmarAcao(
        context,
        titulo: 'Cancelar esta faxina?',
        mensagem:
            'A faxina de ${cliente.nome} do dia ${formatarDiaCurto(dataAtual)} será cancelada. As próximas continuarão normais.',
        textoConfirmar: 'Sim, cancelar',
      );
      if (!confirmou || !context.mounted) return;

      await repositorio.cancelarFaxina(faxina);
      if (!context.mounted) return;

      aoAtualizar?.call();
      mostrarAviso(
        context,
        'Faxina do dia ${formatarDiaCurto(dataAtual)} cancelada.',
        aoDesfazer: () async {
          if (faxina.tipo == TipoFaxina.fixa && faxina.regra != null) {
            await repositorio.removerExcecao(
              regraId: faxina.regra!.id,
              dataOriginal: dataOriginal,
            );
          }
          aoAtualizar?.call();
        },
      );

    case _OpcaoFaxina.encerrarFixa:
      final confirmou = await confirmarAcao(
        context,
        titulo: 'Encerrar faxina fixa?',
        mensagem:
            'As faxinas de ${cliente.nome} a partir do dia ${formatarDiaCurto(dataAtual)} deixarão de acontecer.',
        textoConfirmar: 'Sim, encerrar',
      );
      if (!confirmou || !context.mounted) return;

      final diaAnterior = somarDias(dataOriginal, -1);
      await repositorio.encerrarRegraFixa(
        regraId: faxina.regra!.id,
        dataFim: diaAnterior,
      );
      if (!context.mounted) return;

      aoAtualizar?.call();
      mostrarAviso(context, 'Faxina fixa encerrada.');
  }
}

Future<int?> _mostrarDialogoRegistrarDiaria({
  required BuildContext context,
  required String clienteNome,
  required DateTime data,
  required int valorInicialCentavos,
}) {
  final controlador = TextEditingController(
    text: formatarValorParaCampo(valorInicialCentavos),
  );
  final formKey = GlobalKey<FormState>();

  return showModalBottomSheet<int>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Registrar diária',
                style: Theme.of(ctx).textTheme.headlineMedium,
              ),
              const SizedBox(height: 4),
              Text(
                '$clienteNome • ${formatarDiaCompleto(data)}',
                style: Theme.of(ctx).textTheme.bodyLarge?.copyWith(
                      color: CoresApp.textoSecundario,
                    ),
              ),
              const SizedBox(height: 20),
              CampoValor(
                controlador: controlador,
                rotulo: r'Valor recebido (R$)',
              ),
              const SizedBox(height: 20),
              BotaoPrincipal(
                texto: 'Salvar diária',
                aoTocar: () {
                  if (formKey.currentState?.validate() ?? false) {
                    final valor = converterParaCentavos(controlador.text);
                    if (valor != null) {
                      Navigator.of(ctx).pop(valor);
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
