import 'package:agenda_faxinas/tema/contraste.dart';
import 'package:agenda_faxinas/tema/tema_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('contraste: preto no branco é 21 e cor igual é 1', () {
    expect(contraste(Colors.black, Colors.white), closeTo(21, 0.01));
    expect(contraste(CoresApp.fundo, CoresApp.fundo), closeTo(1, 0.01));
  });

  // Toda combinação de texto x fundo usada no app.
  final combinacoes = <String, (Color, Color)>{
    'texto no fundo': (CoresApp.texto, CoresApp.fundo),
    'texto no cartão': (CoresApp.texto, CoresApp.superficie),
    'texto secundário no fundo': (CoresApp.textoSecundario, CoresApp.fundo),
    'texto secundário no cartão': (
      CoresApp.textoSecundario,
      CoresApp.superficie,
    ),
    'principal no fundo': (CoresApp.principal, CoresApp.fundo),
    'principal no principal claro': (
      CoresApp.principal,
      CoresApp.principalClaro,
    ),
    'branco no principal': (CoresApp.sobrePrincipal, CoresApp.principal),
    'texto no laranja de hoje': (CoresApp.texto, CoresApp.hoje),
    'texto no fundo de hoje': (CoresApp.texto, CoresApp.hojeClaro),
    'sucesso no fundo': (CoresApp.sucesso, CoresApp.fundo),
    'sucesso no cartão': (CoresApp.sucesso, CoresApp.superficie),
    'sucesso no verde claro': (CoresApp.sucesso, CoresApp.sucessoClaro),
    'erro no fundo': (CoresApp.erro, CoresApp.fundo),
    'erro no vermelho claro': (CoresApp.erro, CoresApp.erroClaro),
    'branco no erro': (Colors.white, CoresApp.erro),
    'aviso': (Colors.white, CoresApp.fundoAviso),
    '"Desfazer" no aviso': (CoresApp.acaoAviso, CoresApp.fundoAviso),
    'principal no texto do aviso': (CoresApp.texto, CoresApp.principalClaro),
  };

  for (final MapEntry(key: nome, value: (texto, fundo))
      in combinacoes.entries) {
    test('contraste de pelo menos 4,5:1 — $nome', () {
      expect(contraste(texto, fundo), greaterThanOrEqualTo(4.5));
    });
  }

  test('círculos dos clientes: letra branca com contraste 4,5:1', () {
    for (final cor in CoresApp.avatares) {
      expect(contraste(Colors.white, cor), greaterThanOrEqualTo(4.5));
    }
  });

  test('bordas e o laranja de hoje como borda têm contraste de borda', () {
    expect(contraste(CoresApp.borda, CoresApp.fundo), greaterThanOrEqualTo(3));
    expect(
      contraste(CoresApp.borda, CoresApp.superficie),
      greaterThanOrEqualTo(3),
    );
  });

  test('o laranja de hoje NÃO pode ser cor de texto no fundo', () {
    expect(contraste(CoresApp.hoje, CoresApp.fundo), lessThan(4.5));
  });

  test('nenhum estilo de texto do tema é menor que 18', () {
    final t = criarTemaApp().textTheme;
    final estilos = [
      t.displaySmall,
      t.headlineLarge,
      t.headlineMedium,
      t.headlineSmall,
      t.titleLarge,
      t.titleMedium,
      t.titleSmall,
      t.bodyLarge,
      t.bodyMedium,
      t.bodySmall,
      t.labelLarge,
      t.labelMedium,
      t.labelSmall,
    ];
    for (final estilo in estilos) {
      expect(estilo!.fontSize, greaterThanOrEqualTo(18));
    }
    expect(t.bodyLarge!.fontSize, greaterThanOrEqualTo(18));
    expect(TextosApp.valor.fontSize, greaterThan(t.titleLarge!.fontSize!));
  });

  test('cores principais do tema', () {
    final tema = criarTemaApp();
    expect(tema.scaffoldBackgroundColor, const Color(0xFFFAF8F5));
    expect(tema.colorScheme.primary, const Color(0xFF2F6F6B));
    expect(tema.colorScheme.onSurface, const Color(0xFF1F2933));
    expect(tema.colorScheme.error, const Color(0xFFB3261B));
    expect(CoresApp.hoje, const Color(0xFFD9822B));
    expect(CoresApp.sucesso, const Color(0xFF2E7D32));
  });
}
