import 'package:flutter/material.dart';

import '../../dados/banco/banco_dados.dart';
import '../../dados/repositorios/repositorio_doces.dart';
import '../../tema/tema_app.dart';
import '../../util/datas.dart';
import '../../util/dinheiro.dart';
import '../../widgets/avisos.dart';
import '../../widgets/botao_principal.dart';
import '../../widgets/campo_valor.dart';
import '../../widgets/estado_vazio.dart';
import '../agenda/componentes_agenda.dart';

/// Tela DOCES: registrar vendas de doces e ver a lista de registros do mês.
class TelaDoces extends StatefulWidget {
  const TelaDoces({super.key, required this.banco, this.hoje});

  final BancoDados banco;
  final DateTime? hoje;

  @override
  State<TelaDoces> createState() => _TelaDocesState();
}

class _TelaDocesState extends State<TelaDoces> {
  late final RepositorioDoces _repositorio = RepositorioDoces(widget.banco);
  late final DateTime _hoje = soDia(widget.hoje ?? DateTime.now());
  late DateTime _referencia = DateTime(_hoje.year, _hoje.month, 1);
  late Stream<DadosDocesMes> _streamDoces;

  @override
  void initState() {
    super.initState();
    _streamDoces = _repositorio.observarMes(_referencia);
  }

  void _mudarMes(int passo) {
    setState(() {
      _referencia = DateTime(_referencia.year, _referencia.month + passo, 1);
      _streamDoces = _repositorio.observarMes(_referencia);
    });
  }

  Future<void> _novaVenda() async {
    final criada = await _mostrarDialogoNovaVenda(context, dataInicial: _hoje);
    if (criada == null || !mounted) return;

    await _repositorio.registrarVendaDoces(
      data: criada.data,
      quantidadeLevada: criada.quantidadeLevada,
      valorTotalCentavos: criada.valorTotalCentavos,
    );
    if (!mounted) return;

    mostrarAviso(
      context,
      'Venda de doces registrada (${formatarReais(criada.valorTotalCentavos)})!',
    );
  }

  Future<void> _excluirVenda(VendaDoces venda) async {
    final confirmou = await confirmarAcao(
      context,
      titulo: 'Excluir registro de doces?',
      mensagem:
          'A venda do dia ${formatarDiaCurto(venda.data)} (${formatarReais(venda.valorTotalCentavos)}) será apagada.',
      textoConfirmar: 'Sim, excluir',
    );
    if (!confirmou || !mounted) return;

    await _repositorio.excluirVendaDoces(venda.id);
    if (!mounted) return;

    mostrarAviso(context, 'Registro de venda excluído.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Doces')),
      body: StreamBuilder<DadosDocesMes>(
        stream: _streamDoces,
        builder: (context, snapshot) {
          final dados = snapshot.data;
          if (dados == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final vendas = dados.vendas;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _NavegacaoMes(
                  titulo: formatarMesAno(_referencia),
                  aoVoltar: () => _mudarMes(-1),
                  aoAvancar: () => _mudarMes(1),
                ),
                const SizedBox(height: 16),
                _CartaoResumoDoces(
                  totalDoces: dados.totalDocesLevados,
                  totalValorCentavos: dados.totalCentavos,
                ),
                const SizedBox(height: 20),
                if (vendas.isEmpty)
                  EstadoVazio(
                    icone: Icons.cake_outlined,
                    titulo: 'Nenhuma venda neste mês',
                    explicacao:
                        'Toque no botão abaixo para registrar os doces levados e o valor vendido.',
                    textoBotao: 'Registrar venda',
                    iconeBotao: Icons.add,
                    aoTocarBotao: _novaVenda,
                  )
                else
                  for (final v in vendas)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _ItemVendaDoces(
                        venda: v,
                        aoExcluir: () => _excluirVenda(v),
                      ),
                    ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: RodapeBotao(
        child: BotaoPrincipal(
          texto: 'Registrar venda de doces',
          icone: Icons.add_circle,
          aoTocar: _novaVenda,
        ),
      ),
    );
  }
}

class _NavegacaoMes extends StatelessWidget {
  const _NavegacaoMes({
    required this.titulo,
    required this.aoVoltar,
    required this.aoAvancar,
  });

  final String titulo;
  final VoidCallback aoVoltar;
  final VoidCallback aoAvancar;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton.outlined(
          onPressed: aoVoltar,
          iconSize: 40,
          tooltip: 'Mês anterior',
          icon: const Icon(Icons.chevron_left),
        ),
        Expanded(
          child: Text(
            titulo,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        IconButton.outlined(
          onPressed: aoAvancar,
          iconSize: 40,
          tooltip: 'Próximo mês',
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}

class _CartaoResumoDoces extends StatelessWidget {
  const _CartaoResumoDoces({
    required this.totalDoces,
    required this.totalValorCentavos,
  });

  final int totalDoces;
  final int totalValorCentavos;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CoresApp.principalClaro,
        borderRadius: BorderRadius.circular(MedidasApp.raioCartao),
        border: Border.all(color: CoresApp.principal, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.cake, color: CoresApp.principal, size: 32),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Total vendido no mês',
                  style: textos.titleLarge?.copyWith(color: CoresApp.principal),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(formatarReais(totalValorCentavos), style: TextosApp.valor),
          const SizedBox(height: 4),
          Text(
            '$totalDoces doces levados ao açougue',
            style: textos.bodyLarge?.copyWith(color: CoresApp.textoSecundario),
          ),
        ],
      ),
    );
  }
}

class _ItemVendaDoces extends StatelessWidget {
  const _ItemVendaDoces({required this.venda, required this.aoExcluir});

  final VendaDoces venda;
  final VoidCallback aoExcluir;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return Material(
      color: CoresApp.superficie,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MedidasApp.raioCartao),
        side: const BorderSide(color: CoresApp.bordaSuave, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formatarDiaCompleto(venda.data),
                    style: textos.titleLarge,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${venda.quantidadeLevada} doces levados',
                    style: textos.bodyMedium?.copyWith(
                      color: CoresApp.textoSecundario,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    formatarReais(venda.valorTotalCentavos),
                    style: TextosApp.valorRecebido,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: aoExcluir,
              icon: const Icon(Icons.delete_outline,
                  color: CoresApp.erro, size: 32),
              tooltip: 'Excluir venda',
            ),
          ],
        ),
      ),
    );
  }
}

class _DadosNovaVenda {
  const _DadosNovaVenda({
    required this.data,
    required this.quantidadeLevada,
    required this.valorTotalCentavos,
  });

  final DateTime data;
  final int quantidadeLevada;
  final int valorTotalCentavos;
}

Future<_DadosNovaVenda?> _mostrarDialogoNovaVenda(
  BuildContext context, {
  required DateTime dataInicial,
}) {
  DateTime dataEscolhida = dataInicial;
  final ctrlQtd = TextEditingController();
  final ctrlValor = TextEditingController();
  final formKey = GlobalKey<FormState>();

  return showModalBottomSheet<_DadosNovaVenda>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setStateSheet) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Registrar venda de doces',
                    style: Theme.of(ctx).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  BotaoData(
                    data: dataEscolhida,
                    aoMudar: (d) => setStateSheet(() => dataEscolhida = d),
                  ),
                  const SizedBox(height: 16),
                  const TituloCampo('Quantidade de doces levados'),
                  TextFormField(
                    controller: ctrlQtd,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: CoresApp.texto,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Ex.: 10',
                    ),
                    validator: (texto) {
                      final val = int.tryParse(texto ?? '');
                      if (val == null || val <= 0) {
                        return 'Digite a quantidade de doces';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CampoValor(
                    controlador: ctrlValor,
                    rotulo: r'Valor total vendido (R$)',
                  ),
                  const SizedBox(height: 24),
                  BotaoPrincipal(
                    texto: 'Salvar venda',
                    aoTocar: () {
                      if (formKey.currentState?.validate() ?? false) {
                        final qtd = int.parse(ctrlQtd.text.trim());
                        final val = converterParaCentavos(ctrlValor.text)!;
                        Navigator.of(ctx).pop(
                          _DadosNovaVenda(
                            data: dataEscolhida,
                            quantidadeLevada: qtd,
                            valorTotalCentavos: val,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
