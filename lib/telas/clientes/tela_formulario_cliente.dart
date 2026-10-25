import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';

import '../../dados/banco/banco_dados.dart';
import '../../dados/repositorios/repositorio_clientes.dart';
import '../../tema/tema_app.dart';
import '../../util/dinheiro.dart';
import '../../widgets/avisos.dart';
import '../../widgets/botao_principal.dart';
import '../../widgets/campo_valor.dart';
import '../../widgets/titulo_campo.dart';

/// Formulário para criar (cliente == null) ou editar um cliente.
/// Ao fechar, devolve uma mensagem para mostrar na lista.
class TelaFormularioCliente extends StatefulWidget {
  const TelaFormularioCliente({
    super.key,
    required this.repositorio,
    this.cliente,
  });

  final RepositorioClientes repositorio;
  final Cliente? cliente;

  @override
  State<TelaFormularioCliente> createState() => _TelaFormularioClienteState();
}

class _TelaFormularioClienteState extends State<TelaFormularioCliente> {
  final _chaveFormulario = GlobalKey<FormState>();
  late final _nome = TextEditingController(text: widget.cliente?.nome);
  late final _endereco = TextEditingController(text: widget.cliente?.endereco);
  late final _valor = TextEditingController(
    text: widget.cliente == null
        ? ''
        : formatarValorParaCampo(widget.cliente!.valorPadraoCentavos),
  );
  bool _salvando = false;

  bool get _editando => widget.cliente != null;

  @override
  void dispose() {
    _nome.dispose();
    _endereco.dispose();
    _valor.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_chaveFormulario.currentState!.validate()) return;
    setState(() => _salvando = true);

    final valorCentavos = converterParaCentavos(_valor.text)!;
    if (_editando) {
      await widget.repositorio.atualizar(
        widget.cliente!.copyWith(
          nome: _nome.text,
          endereco: Value(_endereco.text),
          valorPadraoCentavos: valorCentavos,
        ),
      );
    } else {
      await widget.repositorio.inserir(
        nome: _nome.text,
        endereco: _endereco.text,
        valorPadraoCentavos: valorCentavos,
      );
    }
    if (mounted) Navigator.of(context).pop('Cliente salvo!');
  }

  Future<void> _excluir() async {
    final cliente = widget.cliente!;
    final confirmou = await confirmarAcao(
      context,
      titulo: 'Excluir cliente?',
      mensagem:
          'Tem certeza que quer excluir "${cliente.nome}"?\n\n'
          'As faxinas marcadas para este cliente também serão apagadas.',
      textoConfirmar: 'Sim, excluir',
    );
    if (!confirmou) return;

    try {
      await widget.repositorio.excluir(cliente.id);
      if (mounted) Navigator.of(context).pop('Cliente excluído.');
    } on ClienteComHistoricoException {
      if (!mounted) return;
      await explicar(
        context,
        titulo: 'Não foi possível excluir',
        mensagem:
            'Este cliente já tem diárias registradas. '
            'Ele não pode ser excluído para não perder o histórico de ganhos.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editando ? 'Editar cliente' : 'Novo cliente'),
      ),
      body: SafeArea(
        child: Form(
          key: _chaveFormulario,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _Campo(
                rotulo: 'Nome',
                controlador: _nome,
                capitalizacao: TextCapitalization.words,
                validador: (texto) {
                  final nome = texto?.trim() ?? '';
                  if (nome.isEmpty) return 'Digite o nome do cliente';
                  if (nome.length > 100) return 'Nome muito grande';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              _Campo(
                rotulo: 'Endereço (opcional)',
                controlador: _endereco,
                capitalizacao: TextCapitalization.sentences,
                linhas: 2,
              ),
              const SizedBox(height: 24),
              CampoValor(
                rotulo: 'Valor da diária',
                controlador: _valor,
                mensagemVazio: 'Digite o valor da diária',
              ),
              const SizedBox(height: 32),
              BotaoPrincipal(
                texto: 'Salvar',
                icone: Icons.check,
                aoTocar: _salvando ? null : _salvar,
              ),
              if (_editando) ...[
                const SizedBox(height: 40),
                BotaoPrincipal(
                  texto: 'Excluir cliente',
                  icone: Icons.delete_outline,
                  tipo: TipoBotao.secundario,
                  cor: CoresApp.erro,
                  aoTocar: _salvando ? null : _excluir,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Campo extends StatelessWidget {
  const _Campo({
    required this.rotulo,
    required this.controlador,
    this.validador,
    this.capitalizacao = TextCapitalization.none,
    this.linhas = 1,
  });

  final String rotulo;
  final TextEditingController controlador;
  final String? Function(String?)? validador;
  final TextCapitalization capitalizacao;
  final int linhas;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TituloCampo(rotulo),
        TextFormField(
          controller: controlador,
          validator: validador,
          textCapitalization: capitalizacao,
          minLines: linhas,
          maxLines: linhas,
          style: const TextStyle(fontSize: 24, color: CoresApp.texto),
          decoration: const InputDecoration(),
        ),
      ],
    );
  }
}
