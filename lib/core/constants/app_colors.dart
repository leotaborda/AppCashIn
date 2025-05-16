import 'package:flutter/material.dart';

class AppColors {
  // Corres Principais
  static const Color primary = Color(0xFF2AB7A9); // Verde base
  static const Color secondary = Color(0xFF3F51B5); // Azul base

  // Tons auxiliares (Cor verde)
  static const Color greenLight = Color(0xFFD0F7F5);
  static const Color greenMedium = Color(0xFF80DED6);
  static const Color greenDark = Color(0xFF009D8C);

  // Tons auxiliares (Cor azul)
  static const Color blueLight = Color(0xFFE6E9FC);
  static const Color blueMedium = Color(0xFF9DAEF4);
  static const Color blueDark = Color(0xFF3F51B5);
  static const Color blueExtraDark = Color(0xFF3742CE);

  // Gradiente
  static const LinearGradient gradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Fundos e Textos
  static const Color background = Color(0xFFF5F5F5);
  static const Color textPrimary = Color(0xFF121212);
  static const Color textSecondary = Color(0xFF9E9E9E);
  static const Color border = Color(0xFFE0E0E0);

  // Alerta / Erro
  static const Color alert = Color(0xFFFF5252);
}
