import 'package:flutter/material.dart';

import '../../dados/agenda/calculo_agenda.dart';
import '../../dados/banco/banco_dados.dart';
import '../../dados/repositorios/repositorio_agenda.dart';
import '../../tema/tema_app.dart';
import '../../util/datas.dart';
import '../../widgets/avatar_cliente.dart';
import '../../widgets/avisos.dart';
import '../../widgets/botao_principal.dart';
import '../../widgets/cartao_faxina.dart';
import 'calendario.dart';
import 'componentes_agenda.dart';
import 'tela_nova_faxina.dart';

/// Agenda: o dia de hoje no topo, depois a semana ou o mês.
class TelaAgenda extends StatefulWidget {
  const TelaAgenda({super.key, required this.banco, this.hoje});

  final BancoDados banco;

  /// Só para os testes: finge que hoje é outro dia.
  final DateTime? hoje;

  @override
  State<TelaAgenda> createState() => _TelaAgendaState();
}

class _TelaAgendaState extends State<TelaAgenda> {
  late final RepositorioAgenda _repositorio = RepositorioAgenda(widget.banco);
  late final Stream<DadosAgenda> _dados = _repositorio.observar();
  late final DateTime _hoje = soDia(widget.hoje ?? DateTime.now());

  /// Um dia qualquer da semana (ou do mês) que está aparecendo.
  late DateTime _referencia = _hoje;
  bool _verMes = false;

  DateTime get _segunda => segundaDaSemana(_referencia);

  bool get _mostrandoHoje => _verMes
      ? _referencia.year == _hoje.year && _referencia.month == _hoje.month
      : mesmoDia(_segunda, segundaDaSemana(_hoje));

  void _avancar(int passo) {
    setState(() {
      _referencia = _verMes
          ? DateTime(_referencia.year, _referencia.month + passo, 1)
          : somarDias(_referencia, 7 * passo);
    });
  }

  Future<void> _novaFaxina() async {
    final criada = await Navigator.of(context).push<FaxinaCriada>(
      MaterialPageRoute(
        builder: (_) => TelaNovaFaxina(banco: widget.banco, hoje: _hoje),
      ),
    );
    if (criada == null || !mounted) return;
    mostrarAviso(
      context,
      criada.mensagem,
      aoDesfazer: () async {
        await criada.desfazer();
        if (mounted) mostrarAviso(context, 'Pronto, a faxina foi apagada.');
      },
    );
  }

  void _mostrarDia(DateTime dia, DadosAgenda dados) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _ListaDoDia(
        dia: dia,
        dados: dados,
        ehHoje: mesmoDia(dia, _hoje),
        banco: widget.banco,
      ),
    );
  }

  Future<void> _atualizar() async {
    setState(() {});
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agenda')),
      body: StreamBuilder<DadosAgenda>(
        stream: _dados,
        builder: (context, snapshot) {
          final dados = snapshot.data;
          if (dados == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final DateTime de;
          final DateTime ate;
          if (_verMes) {
            de = segundaDaSemana(DateTime(_referencia.year, _referencia.month));
            ate = DateTime(_referencia.year, _referencia.month + 1, 0);
          } else {
            de = _segunda;
            ate = somarDias(_segunda, 6);
          }
          final faxinas = dados.faxinasEntre(de, ate);

          return RefreshIndicator(
            onRefresh: _atualizar,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _CartaoHoje(
                  hoje: _hoje,
                  faxinas: dados.faxinasDoDia(_hoje),
                  clientes: dados.clientes,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: BotaoEscolha(
                        texto: 'Semana',
                        selecionado: !_verMes,
                        aoTocar: () => setState(() => _verMes = false),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: BotaoEscolha(
                        texto: 'Mês',
                        selecionado: _verMes,
                        aoTocar: () => setState(() => _verMes = true),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _Navegacao(
                  titulo: _verMes
                      ? formatarMesAno(_referencia)
                      : formatarSemana(_segunda),
                  verMes: _verMes,
                  aoVoltar: () => _avancar(-1),
                  aoAvancar: () => _avancar(1),
                  aoIrParaHoje: _mostrandoHoje
                      ? null
                      : () => setState(() => _referencia = _hoje),
                ),
                const SizedBox(height: 12),
                if (_verMes)
                  VisaoMes(
                    mes: _referencia,
                    hoje: _hoje,
                    faxinas: faxinas,
                    aoTocarDia: (dia) => _mostrarDia(dia, dados),
                  )
                else
                  VisaoSemana(
                    segunda: _segunda,
                    hoje: _hoje,
                    faxinas: faxinas,
                    clientes: dados.clientes,
                    aoTocarDia: (dia) => _mostrarDia(dia, dados),
                  ),
              ],
            ),
          ),
        );
        },
      ),
      bottomNavigationBar: RodapeBotao(
        child: BotaoPrincipal(
          texto: 'Nova faxina',
          icone: Icons.add_circle,
          aoTocar: _novaFaxina,
        ),
      ),
    );
  }
}

class _CartaoHoje extends StatelessWidget {
  const _CartaoHoje({
    required this.hoje,
    required this.faxinas,
    required this.clientes,
  });

  final DateTime hoje;
  final List<FaxinaDoDia> faxinas;
  final Map<int, Cliente> clientes;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CoresApp.hojeClaro,
        borderRadius: BorderRadius.circular(MedidasApp.raioCartao),
        border: Border.all(color: CoresApp.hoje, width: 3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(formatarDiaCompleto(hoje), style: textos.bodyLarge),
          const SizedBox(height: 4),
          Text('Hoje você tem:', style: textos.headlineMedium),
          const SizedBox(height: 8),
          if (faxinas.isEmpty)
            Text('Nenhuma faxina. Dia livre!', style: textos.titleLarge)
          else
            for (final faxina in faxinas)
              _ItemHoje(cliente: clientes[faxina.clienteId]!),
        ],
      ),
    );
  }
}

class _ItemHoje extends StatelessWidget {
  const _ItemHoje({required this.cliente});

  final Cliente cliente;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final endereco = cliente.endereco;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AvatarCliente(nome: cliente.nome, tamanho: 44),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cliente.nome, style: textos.titleLarge),
                if (endereco != null) Text(endereco, style: textos.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Navegacao extends StatelessWidget {
  const _Navegacao({
    required this.titulo,
    required this.verMes,
    required this.aoVoltar,
    required this.aoAvancar,
    required this.aoIrParaHoje,
  });

  final String titulo;
  final bool verMes;
  final VoidCallback aoVoltar;
  final VoidCallback aoAvancar;
  final VoidCallback? aoIrParaHoje;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton.outlined(
              onPressed: aoVoltar,
              iconSize: 40,
              tooltip: verMes ? 'Mês anterior' : 'Semana anterior',
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
              tooltip: verMes ? 'Próximo mês' : 'Próxima semana',
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
        if (aoIrParaHoje != null)
          TextButton.icon(
            onPressed: aoIrParaHoje,
            icon: const Icon(Icons.today, size: 28),
            label: const Text('Voltar para hoje'),
          ),
      ],
    );
  }
}

/// Janela que sobe de baixo com os clientes de um dia.
class _ListaDoDia extends StatelessWidget {
  const _ListaDoDia({
    required this.dia,
    required this.dados,
    required this.ehHoje,
    required this.banco,
  });

  final DateTime dia;
  final DadosAgenda dados;
  final bool ehHoje;
  final BancoDados banco;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final faxinas = dados.faxinasDoDia(dia);
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.8,
        ),
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          children: [
            Text(formatarDiaCompleto(dia), style: textos.headlineMedium),
            const SizedBox(height: 16),
            if (faxinas.isEmpty)
              Text('Nenhuma faxina neste dia.', style: textos.bodyLarge)
            else
              for (final faxina in faxinas)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Builder(
                    builder: (_) {
                      final reg = dados.registroDe(faxina);
                      final valor =
                          reg?.valorRecebidoCentavos ?? dados.valorDe(faxina);
                      final situacao = reg != null
                          ? SituacaoFaxina.recebida
                          : SituacaoFaxina.marcada;
                      return CartaoFaxina(
                        nome: dados.clientes[faxina.clienteId]!.nome,
                        endereco: dados.clientes[faxina.clienteId]!.endereco,
                        valorCentavos: valor,
                        situacao: situacao,
                        detalhe: descreverFaxina(faxina),
                        destacarHoje: ehHoje,
                        aoTocar: () => mostrarOpcoesFaxina(
                          context: context,
                          faxina: faxina,
                          dados: dados,
                          repositorio: RepositorioAgenda(banco),
                          hoje: dia,
                        ),
                      );
                    },
                  ),
                ),
            const SizedBox(height: 16),
            BotaoPrincipal(
              texto: 'Fechar',
              tipo: TipoBotao.secundario,
              aoTocar: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
