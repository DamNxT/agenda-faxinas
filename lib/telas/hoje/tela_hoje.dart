import 'package:flutter/material.dart';

import '../../dados/banco/banco_dados.dart';
import '../../dados/repositorios/repositorio_agenda.dart';
import '../../tema/tema_app.dart';
import '../../util/datas.dart';
import '../../widgets/cartao_faxina.dart';
import '../../widgets/estado_vazio.dart';
import '../agenda/componentes_agenda.dart';
import '../clientes/tela_clientes.dart';

/// Tela inicial: a data de hoje e as faxinas do dia.
class TelaHoje extends StatefulWidget {
  const TelaHoje({
    super.key,
    required this.banco,
    required this.hoje,
    required this.aoAbrirAgenda,
  });

  final BancoDados banco;
  final DateTime hoje;
  final VoidCallback aoAbrirAgenda;

  @override
  State<TelaHoje> createState() => _TelaHojeState();
}

class _TelaHojeState extends State<TelaHoje> {
  late final Stream<DadosAgenda> _dados = RepositorioAgenda(widget.banco)
      .observar();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hoje')),
      body: StreamBuilder<DadosAgenda>(
        stream: _dados,
        builder: (context, snapshot) {
          final dados = snapshot.data;
          if (dados == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final faxinas = dados.faxinasDoDia(widget.hoje);

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              _CabecalhoData(hoje: widget.hoje, quantidade: faxinas.length),
              const SizedBox(height: MedidasApp.espacoG),
              if (faxinas.isEmpty)
                _SemFaxinas(
                  semClientes: dados.clientes.isEmpty,
                  aoAbrirAgenda: widget.aoAbrirAgenda,
                  aoAbrirClientes: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => TelaClientes(banco: widget.banco),
                    ),
                  ),
                )
              else
                for (final faxina in faxinas)
                  Padding(
                    padding: const EdgeInsets.only(bottom: MedidasApp.espaco),
                    child: Builder(
                      builder: (_) {
                        final reg = dados.registroDe(faxina);
                        final valor = reg?.valorRecebidoCentavos ??
                            dados.valorDe(faxina);
                        final situacao = reg != null
                            ? SituacaoFaxina.recebida
                            : SituacaoFaxina.marcada;
                        return CartaoFaxina(
                          nome: dados.clientes[faxina.clienteId]!.nome,
                          endereco: dados.clientes[faxina.clienteId]!.endereco,
                          valorCentavos: valor,
                          situacao: situacao,
                          detalhe: descreverFaxina(faxina),
                          aoTocar: () => mostrarOpcoesFaxina(
                            context: context,
                            faxina: faxina,
                            dados: dados,
                            repositorio: RepositorioAgenda(widget.banco),
                            hoje: widget.hoje,
                          ),
                        );
                      },
                    ),
                  ),
            ],
          );
        },
      ),
    );
  }
}

class _CabecalhoData extends StatelessWidget {
  const _CabecalhoData({required this.hoje, required this.quantidade});

  final DateTime hoje;
  final int quantidade;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final resumo = switch (quantidade) {
      0 => 'Nenhuma faxina marcada',
      1 => 'Você tem 1 faxina hoje',
      final n => 'Você tem $n faxinas hoje',
    };
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: BoxDecoration(
        color: CoresApp.hojeClaro,
        borderRadius: BorderRadius.circular(MedidasApp.raioCartao),
        border: const Border(left: BorderSide(color: CoresApp.hoje, width: 8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(formatarDataPorExtenso(hoje), style: textos.headlineMedium),
          const SizedBox(height: 4),
          Text(resumo, style: textos.titleMedium),
        ],
      ),
    );
  }
}

class _SemFaxinas extends StatelessWidget {
  const _SemFaxinas({
    required this.semClientes,
    required this.aoAbrirAgenda,
    required this.aoAbrirClientes,
  });

  final bool semClientes;
  final VoidCallback aoAbrirAgenda;
  final VoidCallback aoAbrirClientes;

  @override
  Widget build(BuildContext context) {
    if (semClientes) {
      return EstadoVazio(
        icone: Icons.people_outline,
        titulo: 'Vamos começar?',
        explicacao:
            'Primeiro cadastre seus clientes. '
            'Depois marque as faxinas na Agenda.',
        textoBotao: 'Cadastrar clientes',
        iconeBotao: Icons.person_add,
        aoTocarBotao: aoAbrirClientes,
      );
    }
    return EstadoVazio(
      icone: Icons.wb_sunny_outlined,
      titulo: 'Dia livre!',
      explicacao:
          'Hoje não tem faxina marcada. '
          'Para marcar uma, abra a Agenda e toque em "Nova faxina".',
      textoBotao: 'Abrir agenda',
      iconeBotao: Icons.calendar_month,
      aoTocarBotao: aoAbrirAgenda,
    );
  }
}
