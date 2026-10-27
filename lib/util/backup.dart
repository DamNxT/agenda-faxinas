import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../dados/banco/banco_dados.dart';

class ServicoBackup {
  ServicoBackup(this._banco);

  final BancoDados _banco;

  /// Localiza o arquivo principal do banco de dados SQLite.
  Future<File> obterArquivoBanco() async {
    final docDir = await getApplicationDocumentsDirectory();
    final fileDoc = File(p.join(docDir.path, 'agenda_faxinas.sqlite'));
    if (await fileDoc.exists()) return fileDoc;

    final fileDocDb = File(p.join(docDir.path, 'agenda_faxinas.db'));
    if (await fileDocDb.exists()) return fileDocDb;

    final supportDir = await getApplicationSupportDirectory();
    final fileSupport = File(p.join(supportDir.path, 'agenda_faxinas.sqlite'));
    if (await fileSupport.exists()) return fileSupport;

    final fileSupportDb = File(p.join(supportDir.path, 'agenda_faxinas.db'));
    if (await fileSupportDb.exists()) return fileSupportDb;

    // Se ainda não existir, retorna o caminho em documentos
    return fileDoc;
  }

  /// Descarrega o WAL journal e compartilha o arquivo .sqlite através do menu do Android.
  Future<bool> exportarBackup() async {
    try {
      await _banco.customStatement('PRAGMA wal_checkpoint(FULL);');
    } catch (_) {}

    final arquivoBanco = await obterArquivoBanco();
    if (!await arquivoBanco.exists()) return false;

    final tempDir = await getTemporaryDirectory();
    final dataHoje = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final nomeBackup = 'agenda_faxinas_backup_$dataHoje.sqlite';
    final arquivoTemp = File(p.join(tempDir.path, nomeBackup));

    await arquivoBanco.copy(arquivoTemp.path);

    final resultado = await Share.shareXFiles(
      [XFile(arquivoTemp.path)],
      text: 'Cópia de segurança - Agenda de Faxinas',
      subject: 'Backup Agenda de Faxinas',
    );

    return resultado.status == ShareResultStatus.success ||
        resultado.status == ShareResultStatus.dismissed;
  }

  /// Abre o seletor de arquivos para o usuário escolher o backup.
  Future<File?> selecionarArquivoBackup() async {
    final resultado = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (resultado == null || resultado.files.isEmpty) return null;
    final caminho = resultado.files.single.path;
    if (caminho == null) return null;
    return File(caminho);
  }

  /// Restaura o arquivo do banco de dados a partir de um arquivo de backup.
  Future<bool> restaurarBackup(File arquivoOrigem) async {
    if (!await arquivoOrigem.exists()) return false;

    try {
      await _banco.customStatement('PRAGMA wal_checkpoint(FULL);');
    } catch (_) {}

    final arquivoBanco = await obterArquivoBanco();
    final bytes = await arquivoOrigem.readAsBytes();

    await arquivoBanco.writeAsBytes(bytes, flush: true);

    try {
      await _banco.customStatement('PRAGMA wal_checkpoint(FULL);');
    } catch (_) {}

    return true;
  }
}
