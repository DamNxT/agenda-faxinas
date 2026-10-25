import 'package:flutter/material.dart';

import '../../dados/banco/banco_dados.dart';
import '../../util/datas.dart';
import '../agenda/tela_agenda.dart';
import '../ganhos/tela_ganhos.dart';
import '../hoje/tela_hoje.dart';
import '../mais/tela_mais.dart';

/// Estrutura do app: as 4 abas com a barra de navegação embaixo.
class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key, required this.banco, this.hoje});

  final BancoDados banco;

  /// Só para os testes: finge que hoje é outro dia.
  final DateTime? hoje;

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  late final DateTime _hoje = soDia(widget.hoje ?? DateTime.now());
  int _aba = 0;

  void _irPara(int aba) => setState(() => _aba = aba);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _aba,
        children: [
          TelaHoje(
            banco: widget.banco,
            hoje: _hoje,
            aoAbrirAgenda: () => _irPara(1),
          ),
          TelaAgenda(banco: widget.banco, hoje: _hoje),
          const TelaGanhos(),
          TelaMais(banco: widget.banco),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _aba,
        onDestinationSelected: _irPara,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.wb_sunny_outlined),
            selectedIcon: Icon(Icons.wb_sunny),
            label: 'Hoje',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Agenda',
          ),
          NavigationDestination(
            icon: Icon(Icons.payments_outlined),
            selectedIcon: Icon(Icons.payments),
            label: 'Ganhos',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu),
            selectedIcon: Icon(Icons.menu_open),
            label: 'Mais',
          ),
        ],
      ),
    );
  }
}
