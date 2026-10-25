import 'package:flutter/material.dart';

import '../../dados/agenda/calculo_agenda.dart';
import '../../dados/banco/banco_dados.dart';
import '../../dados/repositorios/repositorio_agenda.dart';
import '../../dados/repositorios/repositorio_clientes.dart';
import '../../tema/tema_app.dart';
import '../../util/datas.dart';
import '../../widgets/botao_principal.dart';
import '../../widgets/estado_vazio.dart';
import 'componentes_agenda.dart';

/// O que a tela de nova faxina devolve: o aviso e como desfazer.
class FaxinaCriada {
  const FaxinaCriada(this.mensagem, this.desfazer);

  final String mensagem;
  final Future<void> Function() desfazer;
}

/// Primeira pergunta: faxina fixa ou só desta vez?
/// Devolve (via Navigator.pop) uma [FaxinaCriada].
class TelaNovaFaxina extends StatefulWidget {
  const TelaNovaFaxina({super.key, required this.banco, required this.hoje});

  final BancoDados banco;
  final DateTime hoje;

  @override
  State<TelaNovaFaxina> createState() => _TelaNovaFaxinaState();
}

class _TelaNovaFaxinaState extends State<TelaNovaFaxina> {
  late final Future<List<Cliente>> _clientes = RepositorioClientes(widget.banco)
      .listarTodos();
  late final RepositorioAgenda _agenda = RepositorioAgenda(widget.banco);

  Future<void> _abrir(Widget tela) async {
    final criada = await Navigator.of(context)
        .push<FaxinaCriada>(MaterialPageRoute(builder: (_) => tela));
    if (criada != null && mounted) Navigator.of(context).pop(criada);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova faxina')),
      body: FutureBuilder<List<Cliente>>(
        future: _clientes,
        builder: (context, snapshot) {
          final clientes = snapshot.data;
          if (clientes == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (clientes.isEmpty) return const _SemClientes();

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                'Que tipo de faxina?',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              _BotaoTipo(
                icone: Icons.repeat,
                titulo: 'Faxina FIXA',
                explicacao: 'Repete toda semana ou a cada 15 dias',
                destaque: true,
                aoTocar: () => _abrir(
                  TelaFaxinaFixa(
                    repositorio: _agenda,
                    clientes: clientes,
                    hoje: widget.hoje,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _BotaoTipo(
                icone: Icons.event,
                titulo: 'Faxina SÓ DESTA VEZ',
                explicacao: 'Um dia só, não repete',
                destaque: false,
                aoTocar: () => _abrir(
                  TelaFaxinaAvulsa(
                    repositorio: _agenda,
                    clientes: clientes,
                    hoje: widget.hoje,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SemClientes extends StatelessWidget {
  const _SemClientes();

  @override
  Widget build(BuildContext context) {
    return const EstadoVazio(
      icone: Icons.people_outline,
      titulo: 'Você ainda não cadastrou nenhum cliente.',
      explicacao:
          'Primeiro cadastre o cliente: toque em "Mais" e depois em '
          '"Clientes".',
    );
  }
}

class _BotaoTipo extends StatelessWidget {
  const _BotaoTipo({
    required this.icone,
    required this.titulo,
    required this.explicacao,
    required this.destaque,
    required this.aoTocar,
  });

  final IconData icone;
  final String titulo;
  final String explicacao;
  final bool destaque;
  final VoidCallback aoTocar;

  @override
  Widget build(BuildContext context) {
    final cor = destaque ? CoresApp.sobrePrincipal : CoresApp.principal;
    return ElevatedButton(
      onPressed: aoTocar,
      style: ElevatedButton.styleFrom(
        backgroundColor: destaque ? CoresApp.principal : CoresApp.superficie,
        foregroundColor: cor,
        minimumSize: const Size.fromHeight(130),
        padding: const EdgeInsets.all(20),
        alignment: Alignment.centerLeft,
        side: const BorderSide(color: CoresApp.principal, width: 2),
      ),
      child: Row(
        children: [
          Icon(icone, size: 48),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(titulo, style: const TextStyle(fontSize: 28)),
                const SizedBox(height: 4),
                Text(
                  explicacao,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Botão "Salvar" fixo no rodapé dos formulários.
class _RodapeSalvar extends StatelessWidget {
  const _RodapeSalvar({required this.aoTocar});

  final VoidCallback? aoTocar;

  @override
  Widget build(BuildContext context) {
    return RodapeBotao(
      child: BotaoPrincipal(
        texto: 'Salvar',
        icone: Icons.check,
        aoTocar: aoTocar,
      ),
    );
  }
}

/// Faxina FIXA: cliente, dias da semana, frequência e data de início.
class TelaFaxinaFixa extends StatefulWidget {
  const TelaFaxinaFixa({
    super.key,
    required this.repositorio,
    required this.clientes,
    required this.hoje,
  });

  final RepositorioAgenda repositorio;
  final List<Cliente> clientes;
  final DateTime hoje;

  @override
  State<TelaFaxinaFixa> createState() => _TelaFaxinaFixaState();
}

class _TelaFaxinaFixaState extends State<TelaFaxinaFixa> {
  final _formulario = GlobalKey<FormState>();
  late int? _clienteId = widget.clientes.length == 1
      ? widget.clientes.single.id
      : null;
  final Set<int> _dias = {};
  int _intervalo = 1;
  late DateTime _inicio = widget.hoje;
  bool _mostrarErroDias = false;
  bool _salvando = false;

  List<DateTime> get _proximasDatas {
    final regra = RegraRecorrencia(
      id: 0,
      clienteId: 0,
      diasSemana: _dias.toList()..sort(),
      intervaloSemanas: _intervalo,
      dataInicio: _inicio,
    );
    return datasDaRegra(
      regra,
      _inicio,
      somarDias(_inicio, 70),
    ).take(4).toList();
  }

  void _alternarDia(int dia) {
    setState(() {
      if (!_dias.remove(dia)) _dias.add(dia);
    });
  }

  Future<void> _salvar() async {
    final valido = _formulario.currentState!.validate();
    setState(() => _mostrarErroDias = _dias.isEmpty);
    if (!valido || _dias.isEmpty) return;

    setState(() => _salvando = true);
    try {
      final repositorio = widget.repositorio;
      final id = await repositorio.criarFaxinaFixa(
        clienteId: _clienteId!,
        diasSemana: _dias.toList()..sort(),
        intervaloSemanas: _intervalo,
        dataInicio: _inicio,
      );
      if (mounted) {
        Navigator.of(context).pop(
          FaxinaCriada(
            'Faxina fixa salva!',
            () => repositorio.excluirRegra(id),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Faxina fixa')),
      body: Form(
        key: _formulario,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const TituloCampo('Cliente'),
            SeletorCliente(
              clientes: widget.clientes,
              clienteId: _clienteId,
              aoMudar: (id) => setState(() => _clienteId = id),
            ),
            const SizedBox(height: 28),
            const TituloCampo('Quais dias da semana?'),
            LayoutBuilder(
              builder: (context, limites) => Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (var d = DateTime.monday; d <= DateTime.sunday; d++)
                    SizedBox(
                      width: (limites.maxWidth - 12) / 2,
                      child: BotaoEscolha(
                        texto: nomesDiasSemana[d]!,
                        selecionado: _dias.contains(d),
                        aoTocar: () => _alternarDia(d),
                      ),
                    ),
                ],
              ),
            ),
            if (_mostrarErroDias && _dias.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Escolha pelo menos um dia da semana',
                  style: TextStyle(fontSize: 18, color: CoresApp.erro),
                ),
              ),
            const SizedBox(height: 28),
            const TituloCampo('Com que frequência?'),
            BotaoEscolha(
              texto: 'Toda semana',
              selecionado: _intervalo == 1,
              aoTocar: () => setState(() => _intervalo = 1),
            ),
            const SizedBox(height: 12),
            BotaoEscolha(
              texto: 'A cada 15 dias',
              selecionado: _intervalo == 2,
              aoTocar: () => setState(() => _intervalo = 2),
            ),
            const SizedBox(height: 28),
            const TituloCampo('A partir de qual dia?'),
            BotaoData(
              data: _inicio,
              aoMudar: (data) => setState(() => _inicio = data),
            ),
            if (_dias.isNotEmpty) ...[
              const SizedBox(height: 28),
              _ProximasDatas(datas: _proximasDatas),
            ],
          ],
        ),
      ),
      bottomNavigationBar: _RodapeSalvar(aoTocar: _salvando ? null : _salvar),
    );
  }
}

/// Mostra as próximas datas para conferir antes de salvar.
class _ProximasDatas extends StatelessWidget {
  const _ProximasDatas({required this.datas});

  final List<DateTime> datas;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CoresApp.principalClaro,
        borderRadius: BorderRadius.circular(MedidasApp.raioCampo),
        border: Border.all(color: CoresApp.principal, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Confira as próximas faxinas:',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          for (final data in datas)
            Text(
              '• ${formatarDiaCurto(data)}',
              style: const TextStyle(fontSize: 22),
            ),
        ],
      ),
    );
  }
}

/// Faxina SÓ DESTA VEZ: cliente e data. O valor é a diária do cliente.
class TelaFaxinaAvulsa extends StatefulWidget {
  const TelaFaxinaAvulsa({
    super.key,
    required this.repositorio,
    required this.clientes,
    required this.hoje,
  });

  final RepositorioAgenda repositorio;
  final List<Cliente> clientes;
  final DateTime hoje;

  @override
  State<TelaFaxinaAvulsa> createState() => _TelaFaxinaAvulsaState();
}

class _TelaFaxinaAvulsaState extends State<TelaFaxinaAvulsa> {
  final _formulario = GlobalKey<FormState>();
  late int? _clienteId = widget.clientes.length == 1
      ? widget.clientes.single.id
      : null;
  late DateTime _data = widget.hoje;
  bool _salvando = false;

  Future<void> _salvar() async {
    if (!_formulario.currentState!.validate()) return;
    setState(() => _salvando = true);
    try {
      final repositorio = widget.repositorio;
      final id = await repositorio.criarFaxinaAvulsa(
        clienteId: _clienteId!,
        data: _data,
      );
      if (mounted) {
        Navigator.of(context).pop(
          FaxinaCriada('Faxina salva!', () => repositorio.excluirAvulso(id)),
        );
      }
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Faxina só desta vez')),
      body: Form(
        key: _formulario,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const TituloCampo('Cliente'),
            SeletorCliente(
              clientes: widget.clientes,
              clienteId: _clienteId,
              aoMudar: (id) => setState(() => _clienteId = id),
            ),
            const SizedBox(height: 28),
            const TituloCampo('Qual dia?'),
            BotaoData(
              data: _data,
              aoMudar: (data) => setState(() => _data = data),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _RodapeSalvar(aoTocar: _salvando ? null : _salvar),
    );
  }
}
