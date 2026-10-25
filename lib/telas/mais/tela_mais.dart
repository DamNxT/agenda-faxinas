import 'package:flutter/material.dart';

import '../../dados/banco/banco_dados.dart';
import '../../tema/tema_app.dart';
import '../backup/tela_backup.dart';
import '../clientes/tela_clientes.dart';
import '../configuracoes/tela_configuracoes.dart';
import '../doces/tela_doces.dart';

/// Aba "Mais": Clientes, Doces, Backup e Configurações.
class TelaMais extends StatelessWidget {
  const TelaMais({super.key, required this.banco});

  final BancoDados banco;

  void _abrir(BuildContext context, Widget tela) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => tela));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mais')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ItemMais(
            icone: Icons.people,
            titulo: 'Clientes',
            explicacao: 'Cadastrar e mudar clientes',
            aoTocar: () => _abrir(context, TelaClientes(banco: banco)),
          ),
          _ItemMais(
            icone: Icons.cake,
            titulo: 'Doces',
            explicacao: 'Anotar as vendas de doces',
            aoTocar: () => _abrir(context, const TelaDoces()),
          ),
          _ItemMais(
            icone: Icons.save,
            titulo: 'Backup',
            explicacao: 'Guardar uma cópia dos dados',
            aoTocar: () => _abrir(context, const TelaBackup()),
          ),
          _ItemMais(
            icone: Icons.settings,
            titulo: 'Configurações',
            explicacao: 'Ajustes do aplicativo',
            aoTocar: () => _abrir(context, const TelaConfiguracoes()),
          ),
        ],
      ),
    );
  }
}

class _ItemMais extends StatelessWidget {
  const _ItemMais({
    required this.icone,
    required this.titulo,
    required this.explicacao,
    required this.aoTocar,
  });

  final IconData icone;
  final String titulo;
  final String explicacao;
  final VoidCallback aoTocar;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: aoTocar,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: CoresApp.principalClaro,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icone, size: 32, color: CoresApp.principal),
                ),
                const SizedBox(width: MedidasApp.espaco),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(titulo, style: textos.titleLarge),
                      Text(
                        explicacao,
                        style: textos.bodyMedium?.copyWith(
                          color: CoresApp.textoSecundario,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  size: 36,
                  color: CoresApp.textoSecundario,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
