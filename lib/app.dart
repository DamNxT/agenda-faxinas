import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'dados/banco/banco_dados.dart';
import 'tema/tema_app.dart';
import 'telas/estrutura/tela_principal.dart';

class AgendaFaxinasApp extends StatelessWidget {
  const AgendaFaxinasApp({super.key, required this.banco});

  final BancoDados banco;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda de Faxinas',
      debugShowCheckedModeBanner: false,
      theme: criarTemaApp(),
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [Locale('pt', 'BR')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      home: TelaPrincipal(banco: banco),
    );
  }
}
