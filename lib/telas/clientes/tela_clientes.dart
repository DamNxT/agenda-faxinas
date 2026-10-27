import 'package:flutter/material.dart';

import '../../dados/banco/banco_dados.dart';
import '../../dados/repositorios/repositorio_clientes.dart';
import '../../tema/tema_app.dart';
import '../../util/dinheiro.dart';
import '../../widgets/avatar_cliente.dart';
import '../../widgets/avisos.dart';
import '../../widgets/botao_principal.dart';
import '../../widgets/estado_vazio.dart';
import 'tela_formulario_cliente.dart';

class TelaClientes extends StatefulWidget {
  const TelaClientes({super.key, required this.banco});

  final BancoDados banco;

  @override
  State<TelaClientes> createState() => _TelaClientesState();
}

class _TelaClientesState extends State<TelaClientes> {
  late final RepositorioClientes _repositorio = RepositorioClientes(
    widget.banco,
  );
  late final Stream<List<Cliente>> _clientes = _repositorio.observarTodos();

  Future<void> _abrirFormulario([Cliente? cliente]) async {
    final mensagem = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) =>
            TelaFormularioCliente(repositorio: _repositorio, cliente: cliente),
      ),
    );
    if (mensagem != null && mounted) mostrarAviso(context, mensagem);
  }

  Future<void> _atualizar() async {
    setState(() {});
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clientes')),
      body: StreamBuilder<List<Cliente>>(
        stream: _clientes,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final clientes = snapshot.data!;
          return RefreshIndicator(
            onRefresh: _atualizar,
            child: clientes.isEmpty
                ? const SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: 500,
                      child: _ListaVazia(),
                    ),
                  )
                : ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: clientes.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, i) => _CartaoCliente(
                      cliente: clientes[i],
                      aoTocar: () => _abrirFormulario(clientes[i]),
                    ),
                  ),
          );
        },
      ),
      bottomNavigationBar: RodapeBotao(
        child: BotaoPrincipal(
          texto: 'Novo cliente',
          icone: Icons.person_add,
          aoTocar: () => _abrirFormulario(),
        ),
      ),
    );
  }
}

class _ListaVazia extends StatelessWidget {
  const _ListaVazia();

  @override
  Widget build(BuildContext context) {
    return const EstadoVazio(
      icone: Icons.people_outline,
      titulo: 'Nenhum cliente cadastrado ainda.',
      explicacao:
          'Toque em "Novo cliente", lá embaixo, para cadastrar o primeiro.',
    );
  }
}

class _CartaoCliente extends StatelessWidget {
  const _CartaoCliente({required this.cliente, required this.aoTocar});

  final Cliente cliente;
  final VoidCallback aoTocar;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final endereco = cliente.endereco;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: aoTocar,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AvatarCliente(nome: cliente.nome),
              const SizedBox(width: MedidasApp.espaco),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(cliente.nome, style: textos.headlineSmall),
                    if (endereco != null) ...[
                      const SizedBox(height: 2),
                      Text(endereco, style: textos.bodyLarge),
                    ],
                    const SizedBox(height: 6),
                    Text(
                      'Diária: ${formatarReais(cliente.valorPadraoCentavos)}',
                      style: TextosApp.valor.copyWith(fontSize: 24),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.edit_outlined,
                size: 32,
                color: CoresApp.textoSecundario,
                semanticLabel: 'Mudar',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
