import 'package:flutter/material.dart';

import '../../dados/agenda/calculo_agenda.dart';
import '../../dados/banco/banco_dados.dart';
import '../../tema/tema_app.dart';
import '../../util/datas.dart';
import '../../widgets/avatar_cliente.dart';

/// Chave usada para achar o dia nos testes. Ex.: "dia-2026-10-26".
ValueKey<String> chaveDia(DateTime dia) =>
    ValueKey('dia-${dia.year}-${dia.month}-${dia.day}');

/// Semana em lista: um dia por linha, com o nome dos clientes.
class VisaoSemana extends StatelessWidget {
  const VisaoSemana({
    super.key,
    required this.segunda,
    required this.hoje,
    required this.faxinas,
    required this.clientes,
    required this.aoTocarDia,
  });

  final DateTime segunda;
  final DateTime hoje;
  final Map<DateTime, List<FaxinaDoDia>> faxinas;
  final Map<int, Cliente> clientes;
  final ValueChanged<DateTime> aoTocarDia;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < 7; i++)
          _LinhaDia(
            dia: somarDias(segunda, i),
            ehHoje: mesmoDia(somarDias(segunda, i), hoje),
            nomes: [
              for (final f in faxinas[somarDias(segunda, i)] ?? const [])
                clientes[f.clienteId]!.nome,
            ],
            aoTocar: () => aoTocarDia(somarDias(segunda, i)),
          ),
      ],
    );
  }
}

class _LinhaDia extends StatelessWidget {
  const _LinhaDia({
    required this.dia,
    required this.ehHoje,
    required this.nomes,
    required this.aoTocar,
  });

  final DateTime dia;
  final bool ehHoje;
  final List<String> nomes;
  final VoidCallback aoTocar;

  @override
  Widget build(BuildContext context) {
    final temFaxina = nomes.isNotEmpty;
    final forma = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(
        color: ehHoje
            ? CoresApp.hoje
            : (temFaxina ? CoresApp.principal : CoresApp.bordaSuave),
        width: ehHoje ? 4 : 2,
      ),
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: temFaxina ? CoresApp.principalClaro : CoresApp.superficie,
        shape: forma,
        child: InkWell(
          key: chaveDia(dia),
          customBorder: forma,
          onTap: aoTocar,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                SizedBox(
                  width: 72,
                  child: Column(
                    children: [
                      Text(
                        abreviaturasDiasSemana[dia.weekday]!,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${dia.day}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (ehHoje)
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                            color: CoresApp.hoje,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'HOJE',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: CoresApp.texto,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: temFaxina
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (final nome in nomes)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                ),
                                child: Row(
                                  children: [
                                    AvatarCliente(nome: nome, tamanho: 32),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        nome,
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        )
                      : const Text(
                          'Sem faxina',
                          style: TextStyle(
                            fontSize: 20,
                            color: CoresApp.textoSecundario,
                          ),
                        ),
                ),
                if (temFaxina)
                  const Icon(
                    Icons.check_circle,
                    color: CoresApp.principal,
                    size: 32,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Mês em grade (calendário). Dias com faxina ficam coloridos.
class VisaoMes extends StatelessWidget {
  const VisaoMes({
    super.key,
    required this.mes,
    required this.hoje,
    required this.faxinas,
    required this.aoTocarDia,
  });

  /// Qualquer dia do mês a mostrar.
  final DateTime mes;
  final DateTime hoje;
  final Map<DateTime, List<FaxinaDoDia>> faxinas;
  final ValueChanged<DateTime> aoTocarDia;

  @override
  Widget build(BuildContext context) {
    final primeiro = DateTime(mes.year, mes.month, 1);
    final ultimo = DateTime(mes.year, mes.month + 1, 0);
    final inicioGrade = segundaDaSemana(primeiro);
    final semanas = diasEntre(inicioGrade, ultimo) ~/ 7 + 1;

    return Column(
      children: [
        Row(
          children: [
            for (var d = DateTime.monday; d <= DateTime.sunday; d++)
              Expanded(
                child: Center(
                  child: Text(
                    abreviaturasDiasSemana[d]!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        for (var s = 0; s < semanas; s++)
          Row(
            children: [
              for (var i = 0; i < 7; i++)
                Expanded(
                  child: _CelulaDia(
                    dia: somarDias(inicioGrade, s * 7 + i),
                    doMes: somarDias(inicioGrade, s * 7 + i).month == mes.month,
                    ehHoje: mesmoDia(somarDias(inicioGrade, s * 7 + i), hoje),
                    temFaxina: faxinas.containsKey(
                      somarDias(inicioGrade, s * 7 + i),
                    ),
                    aoTocar: aoTocarDia,
                  ),
                ),
            ],
          ),
        const SizedBox(height: 12),
        const _Legenda(),
      ],
    );
  }
}

class _CelulaDia extends StatelessWidget {
  const _CelulaDia({
    required this.dia,
    required this.doMes,
    required this.ehHoje,
    required this.temFaxina,
    required this.aoTocar,
  });

  final DateTime dia;
  final bool doMes;
  final bool ehHoje;
  final bool temFaxina;
  final ValueChanged<DateTime> aoTocar;

  @override
  Widget build(BuildContext context) {
    if (!doMes) return const SizedBox(height: 60);
    final forma = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: BorderSide(
        color: ehHoje ? CoresApp.hoje : CoresApp.bordaSuave,
        width: ehHoje ? 4 : 1,
      ),
    );
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Material(
        color: temFaxina ? CoresApp.principal : CoresApp.superficie,
        shape: forma,
        child: InkWell(
          key: chaveDia(dia),
          customBorder: forma,
          onTap: () => aoTocar(dia),
          child: SizedBox(
            height: 56,
            child: Center(
              child: Text(
                '${dia.day}',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: temFaxina ? CoresApp.sobrePrincipal : CoresApp.texto,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Legenda extends StatelessWidget {
  const _Legenda();

  @override
  Widget build(BuildContext context) {
    Widget quadrado(Color cor, Color borda, double largura) => Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: cor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: borda, width: largura),
      ),
    );
    const estilo = TextStyle(fontSize: 20);
    return Column(
      children: [
        Row(
          children: [
            quadrado(CoresApp.principal, CoresApp.principal, 1),
            const SizedBox(width: 10),
            const Expanded(child: Text('Dia com faxina', style: estilo)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            quadrado(CoresApp.superficie, CoresApp.hoje, 4),
            const SizedBox(width: 10),
            const Expanded(child: Text('Hoje', style: estilo)),
          ],
        ),
        const SizedBox(height: 6),
        const Text('Toque num dia para ver os clientes.', style: estilo),
      ],
    );
  }
}
