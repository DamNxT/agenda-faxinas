import 'package:flutter/material.dart';

import '../tema/tema_app.dart';
import '../util/dinheiro.dart';
import 'avatar_cliente.dart';

enum SituacaoFaxina { marcada, recebida, cancelada }

/// Cartão grande de uma faxina: cliente, endereço e valor.
/// Não sabe nada do banco; quem usa passa os textos prontos.
class CartaoFaxina extends StatelessWidget {
  const CartaoFaxina({
    super.key,
    required this.nome,
    this.endereco,
    this.valorCentavos,
    this.detalhe,
    this.situacao = SituacaoFaxina.marcada,
    this.destacarHoje = false,
    this.aoTocar,
    this.acoes = const [],
  });

  final String nome;
  final String? endereco;
  final int? valorCentavos;

  /// Ex.: "Fixa: toda semana".
  final String? detalhe;
  final SituacaoFaxina situacao;

  /// Borda laranja de "hoje".
  final bool destacarHoje;
  final VoidCallback? aoTocar;

  /// Botões embaixo do cartão (ex.: "Mudar só esta vez").
  final List<Widget> acoes;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final cancelada = situacao == SituacaoFaxina.cancelada;
    final forma = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(MedidasApp.raioCartao),
      side: destacarHoje
          ? const BorderSide(color: CoresApp.hoje, width: 3)
          : const BorderSide(color: CoresApp.bordaSuave, width: 1.5),
    );
    final endereco = this.endereco;
    final detalhe = this.detalhe;
    final valor = valorCentavos;

    return Material(
      color: CoresApp.superficie,
      shape: forma,
      child: InkWell(
        customBorder: forma,
        onTap: aoTocar,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MergeSemantics(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AvatarCliente(nome: nome),
                    const SizedBox(width: MedidasApp.espaco),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nome,
                            style: textos.headlineSmall?.copyWith(
                              decoration: cancelada
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          if (endereco != null && endereco.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 2),
                                  child: Icon(
                                    Icons.place_outlined,
                                    size: 24,
                                    color: CoresApp.textoSecundario,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    endereco,
                                    style: textos.bodyLarge,
                                  ),
                                ),
                              ],
                            ),
                          ],
                          if (detalhe != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              detalhe,
                              style: textos.bodyMedium?.copyWith(
                                color: CoresApp.textoSecundario,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (valor != null || situacao != SituacaoFaxina.marcada) ...[
                const SizedBox(height: MedidasApp.espaco),
                Row(
                  children: [
                    if (valor != null)
                      Expanded(
                        child: Text(
                          formatarReais(valor),
                          style: situacao == SituacaoFaxina.recebida
                              ? TextosApp.valorRecebido
                              : TextosApp.valor.copyWith(
                                  decoration: cancelada
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                        ),
                      )
                    else
                      const Spacer(),
                    if (situacao != SituacaoFaxina.marcada)
                      _Selo(situacao: situacao),
                  ],
                ),
              ],
              if (acoes.isNotEmpty) ...[
                const SizedBox(height: MedidasApp.espaco),
                for (final acao in acoes)
                  Padding(
                    padding: const EdgeInsets.only(top: MedidasApp.espacoP),
                    child: acao,
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Selo extends StatelessWidget {
  const _Selo({required this.situacao});

  final SituacaoFaxina situacao;

  @override
  Widget build(BuildContext context) {
    final (texto, icone, cor, fundo) = situacao == SituacaoFaxina.recebida
        ? (
            'Recebido',
            Icons.check_circle,
            CoresApp.sucesso,
            CoresApp.sucessoClaro,
          )
        : ('Cancelada', Icons.cancel, CoresApp.erro, CoresApp.erroClaro);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: fundo,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icone, color: cor, size: 24),
          const SizedBox(width: 6),
          Text(
            texto,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: cor,
            ),
          ),
        ],
      ),
    );
  }
}
