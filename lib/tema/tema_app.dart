import 'package:flutter/material.dart';

/// Paleta oficial do app. Regras de uso no PROJETO.md ("Regras de design").
///
/// Todo texto tem contraste de pelo menos 4,5:1 com o fundo onde aparece
/// (conferido em test/tema/tema_app_test.dart). O laranja de "hoje" NÃO serve
/// para texto: use só como borda ou fundo, com texto escuro por cima.
abstract final class CoresApp {
  static const fundo = Color(0xFFFAF8F5);
  static const superficie = Color(0xFFFFFFFF);
  static const texto = Color(0xFF1F2933);
  static const textoSecundario = Color(0xFF52606D);

  static const principal = Color(0xFF2F6F6B);
  static const principalClaro = Color(0xFFE3EFEE);
  static const sobrePrincipal = Color(0xFFFFFFFF);

  static const hoje = Color(0xFFD9822B);
  static const hojeClaro = Color(0xFFFBEBDA);

  static const sucesso = Color(0xFF2E7D32);
  static const sucessoClaro = Color(0xFFEEF6EE);

  static const erro = Color(0xFFB3261B);
  static const erroClaro = Color(0xFFFBE9E7);

  /// Borda de campos e botões de contorno (3:1 com o fundo).
  static const borda = Color(0xFF7B8794);

  /// Borda suave de cartões (só enfeite, o conteúdo tem o contraste).
  static const bordaSuave = Color(0xFFD5DBE1);

  /// Avisos ("Cliente salvo!", "Desfazer").
  static const fundoAviso = texto;
  static const acaoAviso = Color(0xFF9FD8D3);

  /// Cores dos círculos com a inicial do cliente (texto branco por cima).
  static const avatares = [
    Color(0xFF2F6F6B),
    Color(0xFF1565C0),
    Color(0xFF6A1B9A),
    Color(0xFFAD1457),
    Color(0xFF4E342E),
    Color(0xFF37474F),
    Color(0xFF2E7D32),
    Color(0xFFA0522D),
  ];
}

/// Espaços, cantos e alturas. Use sempre estes valores.
abstract final class MedidasApp {
  static const espacoP = 8.0;
  static const espaco = 16.0;
  static const espacoG = 24.0;

  static const raioBotao = 16.0;
  static const raioCampo = 14.0;
  static const raioCartao = 20.0;

  /// Mínimo para qualquer coisa que se toca.
  static const toqueMinimo = 48.0;
  static const alturaBotao = 56.0;
  static const alturaBotaoPrincipal = 64.0;
}

/// Estilos de texto extras, além do [TextTheme].
abstract final class TextosApp {
  /// Valor em reais em destaque (ex.: "R$ 150,00" no cartão da faxina).
  static const valor = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: CoresApp.texto,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  /// Valor já recebido.
  static final valorRecebido = valor.copyWith(color: CoresApp.sucesso);
}

/// Tema único do app. Usa a fonte padrão do Android (Roboto), que já vem no
/// celular; nenhuma fonte é baixada da internet.
ThemeData criarTemaApp() {
  final esquema =
      ColorScheme.fromSeed(
        seedColor: CoresApp.principal,
        dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
      ).copyWith(
        primary: CoresApp.principal,
        onPrimary: CoresApp.sobrePrincipal,
        primaryContainer: CoresApp.principalClaro,
        onPrimaryContainer: CoresApp.texto,
        secondary: CoresApp.hoje,
        onSecondary: CoresApp.texto,
        error: CoresApp.erro,
        onError: Colors.white,
        errorContainer: CoresApp.erroClaro,
        onErrorContainer: CoresApp.erro,
        surface: CoresApp.fundo,
        onSurface: CoresApp.texto,
        onSurfaceVariant: CoresApp.textoSecundario,
        outline: CoresApp.borda,
        outlineVariant: CoresApp.bordaSuave,
      );

  // Nenhum texto do app fica abaixo de 18 sp.
  const textos = TextTheme(
    displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
    headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
    headlineSmall: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
    titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    titleMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
    titleSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    bodyLarge: TextStyle(fontSize: 20, height: 1.35),
    bodyMedium: TextStyle(fontSize: 18, height: 1.35),
    bodySmall: TextStyle(fontSize: 18, height: 1.35),
    labelLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    labelMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    labelSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
  );
  final textosComCor = textos.apply(
    bodyColor: CoresApp.texto,
    displayColor: CoresApp.texto,
  );

  final formaBotao = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(MedidasApp.raioBotao),
  );
  OutlineInputBorder bordaCampo(Color cor, double largura) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(MedidasApp.raioCampo),
        borderSide: BorderSide(color: cor, width: largura),
      );

  return ThemeData(
    useMaterial3: true,
    colorScheme: esquema,
    scaffoldBackgroundColor: CoresApp.fundo,
    textTheme: textosComCor,
    materialTapTargetSize: MaterialTapTargetSize.padded,
    visualDensity: VisualDensity.standard,
    appBarTheme: const AppBarTheme(
      backgroundColor: CoresApp.fundo,
      foregroundColor: CoresApp.texto,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: true,
      toolbarHeight: 72,
      titleTextStyle: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: CoresApp.texto,
      ),
      iconTheme: IconThemeData(size: 32, color: CoresApp.texto),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: CoresApp.principal,
        foregroundColor: CoresApp.sobrePrincipal,
        elevation: 0,
        minimumSize: const Size.fromHeight(MedidasApp.alturaBotaoPrincipal),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        textStyle: textos.labelLarge,
        iconSize: 30,
        shape: formaBotao,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: CoresApp.principal,
        foregroundColor: CoresApp.sobrePrincipal,
        minimumSize: const Size(64, MedidasApp.alturaBotao),
        textStyle: textos.labelLarge,
        shape: formaBotao,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: CoresApp.principal,
        minimumSize: const Size(64, MedidasApp.alturaBotao),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        textStyle: textos.labelLarge,
        iconSize: 28,
        side: const BorderSide(color: CoresApp.principal, width: 2),
        shape: formaBotao,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: CoresApp.principal,
        minimumSize: const Size(64, MedidasApp.toqueMinimo),
        textStyle: textos.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        iconSize: 26,
        shape: formaBotao,
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: CoresApp.texto,
        minimumSize: const Size.square(56),
        iconSize: 32,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: CoresApp.superficie,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      hintStyle: const TextStyle(fontSize: 20, color: CoresApp.textoSecundario),
      labelStyle: const TextStyle(fontSize: 20, color: CoresApp.texto),
      errorStyle: const TextStyle(fontSize: 18, color: CoresApp.erro),
      errorMaxLines: 3,
      border: bordaCampo(CoresApp.borda, 1.5),
      enabledBorder: bordaCampo(CoresApp.borda, 1.5),
      focusedBorder: bordaCampo(CoresApp.principal, 3),
      errorBorder: bordaCampo(CoresApp.erro, 2),
      focusedErrorBorder: bordaCampo(CoresApp.erro, 3),
    ),
    cardTheme: CardThemeData(
      color: CoresApp.superficie,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MedidasApp.raioCartao),
        side: const BorderSide(color: CoresApp.bordaSuave, width: 1.5),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: 84,
      backgroundColor: CoresApp.superficie,
      surfaceTintColor: Colors.transparent,
      elevation: 3,
      indicatorColor: CoresApp.principalClaro,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (estados) => estados.contains(WidgetState.selected)
            ? const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: CoresApp.principal,
              )
            : const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: CoresApp.textoSecundario,
              ),
      ),
      iconTheme: WidgetStateProperty.resolveWith(
        (estados) => estados.contains(WidgetState.selected)
            ? const IconThemeData(size: 32, color: CoresApp.principal)
            : const IconThemeData(size: 30, color: CoresApp.textoSecundario),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: CoresApp.fundoAviso,
      contentTextStyle: const TextStyle(fontSize: 20, color: Colors.white),
      actionTextColor: CoresApp.acaoAviso,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MedidasApp.raioCampo),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: CoresApp.superficie,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: textosComCor.headlineSmall,
      contentTextStyle: textosComCor.bodyLarge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: CoresApp.fundo,
      surfaceTintColor: Colors.transparent,
      dragHandleColor: CoresApp.borda,
      showDragHandle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
    ),
    listTileTheme: const ListTileThemeData(
      minTileHeight: 72,
      iconColor: CoresApp.principal,
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: CoresApp.texto,
      ),
      subtitleTextStyle: TextStyle(
        fontSize: 18,
        color: CoresApp.textoSecundario,
      ),
    ),
    dividerTheme: const DividerThemeData(color: CoresApp.bordaSuave),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: CoresApp.principal,
    ),
  );
}
