import 'dart:io';

import 'package:flutter/material.dart';

import '../../dados/banco/banco_dados.dart';
import '../../tema/tema_app.dart';
import '../../util/backup.dart';
import '../../widgets/avisos.dart';
import '../../widgets/botao_principal.dart';

/// Tela BACKUP: exporta e importa cópia dos dados.
class TelaBackup extends StatefulWidget {
  const TelaBackup({super.key, required this.banco, this.servicoMock});

  final BancoDados banco;
  final ServicoBackup? servicoMock;

  @override
  State<TelaBackup> createState() => _TelaBackupState();
}

class _TelaBackupState extends State<TelaBackup> {
  late final ServicoBackup _servico =
      widget.servicoMock ?? ServicoBackup(widget.banco);
  bool _carregando = false;

  Future<void> _salvarCopia() async {
    setState(() => _carregando = true);
    try {
      final ok = await _servico.exportarBackup();
      if (!mounted) return;
      if (ok) {
        mostrarAviso(context, 'Cópia de dados gerada com sucesso!');
      }
    } catch (_) {
      if (mounted) {
        mostrarAviso(context, 'Não foi possível compartilhar a cópia.');
      }
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  Future<void> _restaurarCopia() async {
    File? arquivo;
    try {
      arquivo = await _servico.selecionarArquivoBackup();
    } catch (_) {}

    if (arquivo == null || !mounted) return;

    final confirmou = await confirmarAcao(
      context,
      titulo: 'Restaurar cópia dos dados?',
      mensagem:
          'Atenção: todas as faxinas, clientes e vendas atuais serão substituídos pelas informações do arquivo selecionado. Deseja continuar?',
      textoConfirmar: 'Sim, restaurar',
    );

    if (!confirmou || !mounted) return;

    setState(() => _carregando = true);
    try {
      final ok = await _servico.restaurarBackup(arquivo);
      if (!mounted) return;
      if (ok) {
        mostrarAviso(context, 'Dados restaurados com sucesso!');
      } else {
        mostrarAviso(context, 'Erro ao restaurar a cópia dos dados.');
      }
    } catch (_) {
      if (mounted) {
        mostrarAviso(context, 'Não foi possível ler o arquivo selecionado.');
      }
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Backup')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: CoresApp.principalClaro,
                borderRadius: BorderRadius.circular(MedidasApp.raioCartao),
                border: Border.all(color: CoresApp.principal, width: 2),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.security,
                    size: 56,
                    color: CoresApp.principal,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Cópia de Segurança',
                    style: textos.headlineSmall?.copyWith(
                      color: CoresApp.principal,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Guarde uma cópia dos seus dados para não perder nada se trocar de celular ou precisar restaurar suas informações.',
                    style: textos.bodyLarge?.copyWith(
                      color: CoresApp.textoSecundario,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            if (_carregando)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              )
            else ...[
              BotaoPrincipal(
                texto: 'Salvar cópia dos dados',
                icone: Icons.share,
                aoTocar: _salvarCopia,
              ),
              const SizedBox(height: 16),
              BotaoPrincipal(
                texto: 'Restaurar cópia',
                icone: Icons.file_open,
                tipo: TipoBotao.secundario,
                aoTocar: _restaurarCopia,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
