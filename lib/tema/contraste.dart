import 'dart:ui';

/// Contraste entre duas cores, de 1 (igual) a 21 (preto no branco).
/// Texto precisa de pelo menos 4,5; bordas e ícones, de pelo menos 3.
double contraste(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final (claro, escuro) = la > lb ? (la, lb) : (lb, la);
  return (claro + 0.05) / (escuro + 0.05);
}
