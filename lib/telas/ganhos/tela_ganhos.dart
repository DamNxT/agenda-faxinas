import 'package:flutter/material.dart';

import '../../dados/banco/banco_dados.dart';
import '../../dados/repositorios/repositorio_ganhos.dart';
import '../../tema/tema_app.dart';
import '../../util/datas.dart';
import '../../util/dinheiro.dart';
import '../../widgets/estado_vazio.dart';

/// Tela GANHOS: escolher o mês e ver o total geral, totais por faxina/doces e
/// o detalhamento por dia.
class TelaGanhos extends StatefulWidget {
  const TelaGanhos({super.key, required this.banco, this.hoje});

  final BancoDados banco;
  final DateTime? hoje;

  @override
  State<TelaGanhos> createState() => _TelaGanhosState();
}

class _TelaGanhosState extends State<TelaGanhos> {
  late final RepositorioGanhos _repositorio = RepositorioGanhos(widget.banco);
  late final DateTime _hoje = soDia(widget.hoje ?? DateTime.now());
  late DateTime _referencia = DateTime(_hoje.year, _hoje.month, 1);
  late Stream<DadosGanhosMes> _streamGanhos;

  @override
  void initState() {
    super.initState();
    _streamGanhos = _repositorio.observarMes(_referencia);
  }

  @override
  void didUpdateWidget(covariant TelaGanhos oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _streamGanhos = _repositorio.observarMes(_referencia);
    });
  }

  void _mudarMes(int passo) {
    setState(() {
      _referencia = DateTime(_referencia.year, _referencia.month + passo, 1);
      _streamGanhos = _repositorio.observarMes(_referencia);
    });
  }

  Future<void> _atualizar() async {
    setState(() {
      _streamGanhos = _repositorio.observarMes(_referencia);
    });
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ganhos')),
      body: StreamBuilder<DadosGanhosMes>(
        stream: _streamGanhos,
        builder: (context, snapshot) {
          final dados = snapshot.data;
          if (dados == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final itens = dados.itens;

          return RefreshIndicator(
            onRefresh: _atualizar,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _NavegacaoMesGanhos(
                  titulo: formatarMesAno(_referencia),
                  aoVoltar: () => _mudarMes(-1),
                  aoAvancar: () => _mudarMes(1),
                ),
                const SizedBox(height: 16),
                _CartaoTotalGeral(totalGeral: dados.totalGeral),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _CartaoSubtotal(
                        icone: Icons.cleaning_services,
                        titulo: 'Faxinas',
                        valorCentavos: dados.totalGanhosFaxinas,
                        detalhe:
                            '${dados.quantidadeFaxinas} ${dados.quantidadeFaxinas == 1 ? 'realizada' : 'realizadas'}',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _CartaoSubtotal(
                        icone: Icons.cake,
                        titulo: 'Doces',
                        valorCentavos: dados.totalGanhosDoces,
                        detalhe: 'Doces vendidos',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Detalhamento dos dias',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                if (itens.isEmpty)
                  const EstadoVazio(
                    icone: Icons.payments_outlined,
                    titulo: 'Nenhum ganho neste mês',
                    explicacao:
                        'Os ganhos vão aparecer conforme você registrar as diárias de faxina ou as vendas de doces.',
                  )
                else
                  for (final item in itens)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _ItemGanhoCard(item: item),
                    ),
              ],
            ),
          ),
        );
        },
      ),
    );
  }
}

class _NavegacaoMesGanhos extends StatelessWidget {
  const _NavegacaoMesGanhos({
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

class _CartaoTotalGeral extends StatelessWidget {
  const _CartaoTotalGeral({required this.totalGeral});

  final int totalGeral;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CoresApp.sucessoClaro,
        borderRadius: BorderRadius.circular(MedidasApp.raioCartao),
        border: Border.all(color: CoresApp.sucesso, width: 2.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.payments, color: CoresApp.sucesso, size: 36),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Total geral do mês',
                  style: textos.titleLarge?.copyWith(
                    color: CoresApp.sucesso,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            formatarReais(totalGeral),
            style: TextosApp.valorRecebido.copyWith(fontSize: 32),
          ),
        ],
      ),
    );
  }
}

class _CartaoSubtotal extends StatelessWidget {
  const _CartaoSubtotal({
    required this.icone,
    required this.titulo,
    required this.valorCentavos,
    required this.detalhe,
  });

  final IconData icone;
  final String titulo;
  final int valorCentavos;
  final String detalhe;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CoresApp.superficie,
        borderRadius: BorderRadius.circular(MedidasApp.raioCartao),
        border: Border.all(color: CoresApp.bordaSuave, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icone, color: CoresApp.principal, size: 28),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  titulo,
                  style: textos.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(formatarReais(valorCentavos), style: TextosApp.valor),
          const SizedBox(height: 2),
          Text(
            detalhe,
            style: textos.bodyMedium?.copyWith(color: CoresApp.textoSecundario),
          ),
        ],
      ),
    );
  }
}

class _ItemGanhoCard extends StatelessWidget {
  const _ItemGanhoCard({required this.item});

  final ItemGanho item;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final isFaxina = item is GanhoFaxina;
    final titulo = isFaxina
        ? (item as GanhoFaxina).clienteNome
        : 'Venda de doces';
    final detalhe = isFaxina
        ? 'Faxina'
        : '${(item as GanhoDoces).quantidadeLevada} doces levados';
    final icone = isFaxina ? Icons.cleaning_services : Icons.cake;

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
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: CoresApp.principalClaro,
                shape: BoxShape.circle,
              ),
              child: Icon(icone, color: CoresApp.principal, size: 26),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titulo, style: textos.titleLarge),
                  Text(
                    formatarDiaCompleto(item.data),
                    style: textos.bodyMedium?.copyWith(
                      color: CoresApp.textoSecundario,
                    ),
                  ),
                  Text(
                    detalhe,
                    style: textos.bodyMedium?.copyWith(
                      color: CoresApp.principal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              formatarReais(item.valorCentavos),
              style: TextosApp.valorRecebido,
            ),
          ],
        ),
      ),
    );
  }
}
