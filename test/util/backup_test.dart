import 'dart:io';

import 'package:agenda_faxinas/dados/banco/banco_dados.dart';
import 'package:agenda_faxinas/util/backup.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late BancoDados banco;
  late ServicoBackup servico;
  late Directory tempDir;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (methodCall) async => tempDir.path,
    );
    banco = BancoDados(NativeDatabase.memory());
    servico = ServicoBackup(banco);
  });

  tearDown(() {
    banco.close();
    if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
  });

  test('restaurarBackup grava os bytes do arquivo', () async {
    final tempFile = File('${tempDir.path}/test_backup.sqlite');
    await tempFile.writeAsBytes([1, 2, 3, 4, 5]);

    final ok = await servico.restaurarBackup(tempFile);
    expect(ok, isTrue);
  });
}
