import 'package:flutter/material.dart';

/// Sistema de Design do App Kareu
/// 
/// Define padrões consistentes para fontes, espaçamentos, cores e outros elementos
/// visuais para garantir uma experiência fluida e orgânica em todo o aplicativo.
class AppDesignSystem {
  // ============================================================================
  // TIPOGRAFIA - Tamanhos de fonte padronizados
  // ============================================================================
  
  /// Tamanhos de fonte hierárquicos para uma experiência consistente
  static const double fontSizeDisplay = 48.0;     // Logo principal
  static const double fontSizeH1 = 24.0;          // Títulos principais
  static const double fontSizeH2 = 20.0;          // Títulos secundários
  static const double fontSizeH3 = 18.0;          // Subtítulos
  static const double fontSizeBody = 16.0;        // Texto principal
  static const double fontSizeBodySmall = 14.0;   // Texto secundário
  static const double fontSizeCaption = 12.0;     // Legendas e hints
  static const double fontSizeSmall = 10.0;       // Textos muito pequenos
  
  // ============================================================================
  // ESPAÇAMENTOS - Sistema de espaçamento baseado em múltiplos de 4
  // ============================================================================
  
  /// Espaçamentos padronizados em múltiplos de 4 para consistência visual
  static const double spaceXS = 4.0;     // 4px
  static const double spaceSM = 8.0;     // 8px
  static const double spaceMD = 12.0;    // 12px
  static const double spaceLG = 16.0;    // 16px
  static const double spaceXL = 20.0;    // 20px
  static const double space2XL = 24.0;   // 24px
  static const double space3XL = 32.0;   // 32px
  static const double space4XL = 40.0;   // 40px
  static const double space5XL = 48.0;   // 48px
  static const double space6XL = 64.0;   // 64px
  
  // Aliases para compatibilidade com código existente
  static const double spaceXXS = spaceXS;    // 4px
  static const double spaceS = spaceSM;      // 8px
  static const double spaceM = spaceMD;      // 12px
  static const double spaceL = spaceLG;      // 16px
  static const double spaceXXL = space2XL;   // 24px
  
  // ============================================================================
  // ESTILOS DE TEXTO PRÉ-DEFINIDOS
  // ============================================================================
  
  /// Logo principal do aplicativo
  static const TextStyle logoStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: fontSizeDisplay,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: Colors.white,
  );
  
  /// Título principal de telas
  static const TextStyle h1Style = TextStyle(
    fontFamily: 'Poppins',
    fontSize: fontSizeH1,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: Colors.black,
  );
  
  /// Título secundário
  static const TextStyle h2Style = TextStyle(
    fontFamily: 'Poppins',
    fontSize: fontSizeH2,
    fontWeight: FontWeight.w500,
    height: 1.3,
    color: Colors.black,
  );
  
  /// Subtítulo
  static const TextStyle h3Style = TextStyle(
    fontFamily: 'Poppins',
    fontSize: fontSizeH3,
    fontWeight: FontWeight.w500,
    height: 1.3,
    color: Colors.black,
  );
  
  /// Texto do corpo principal
  static const TextStyle bodyStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: fontSizeBody,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: Colors.black,
  );
  
  /// Texto do corpo menor
  static const TextStyle bodySmallStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: fontSizeBodySmall,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: Colors.black87,
  );
  
  /// Texto de legenda/hint
  static const TextStyle captionStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: fontSizeCaption,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: Colors.black54,
  );
  
  /// Labels de formulários
  static const TextStyle labelStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: fontSizeBodySmall,
    fontWeight: FontWeight.w500,
    height: 1.3,
    color: Colors.black,
  );
  
  /// Texto de botões
  static const TextStyle buttonStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: fontSizeBody,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: Colors.white,
  );
  
  /// Texto de botões pequenos
  static const TextStyle buttonSmallStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: fontSizeBodySmall,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: Colors.white,
  );
  
  /// Texto de links
  static const TextStyle linkStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: fontSizeBodySmall,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: Color(0xFF4D64C8),
    decoration: TextDecoration.underline,
  );
  
  /// Placeholder de campos de entrada
  static const TextStyle placeholderStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: fontSizeBodySmall,
    fontWeight: FontWeight.w300,
    height: 1.4,
    color: Color(0xFFA8A2A2),
  );
  
  // ============================================================================
  // CORES DO APLICATIVO
  // ============================================================================
  
  static const Color primaryColor = Color(0xFF4D64C8);
  static const Color secondaryColor = Color(0xFFFFAD00);
  static const Color backgroundColor = Colors.white;
  static const Color surfaceColor = Color(0xFFF4F4F4);
  static const Color borderColor = Color(0xFFE0E0E0);
  static const Color textPrimaryColor = Colors.black;
  static const Color textSecondaryColor = Color(0xFF666666);
  static const Color textHintColor = Color(0xFFA8A2A2);
  static const Color errorColor = Colors.red;
  static const Color successColor = Colors.green;
  
  // Aliases para compatibilidade
  static const Color textColor = textPrimaryColor;
  static const Color placeholderColor = textHintColor;
  
  // ============================================================================
  // DIMENSÕES DE COMPONENTES
  // ============================================================================
  
  /// Alturas padrão para componentes
  static const double buttonHeight = 48.0;
  static const double buttonHeightSmall = 36.0;
  static const double inputHeight = 48.0;
  static const double inputHeightSmall = 36.0;
  
  /// Raios de borda
  static const double borderRadiusSmall = 4.0;
  static const double borderRadius = 8.0;
  static const double borderRadiusLarge = 12.0;
  static const double borderRadiusXLarge = 16.0;
  
  /// Padding padrão para telas
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: spaceLG);
  static const EdgeInsets sectionPadding = EdgeInsets.all(space2XL);
  static const EdgeInsets cardPadding = EdgeInsets.all(spaceLG);
  
  // ============================================================================
  // MÉTODOS UTILITÁRIOS
  // ============================================================================
  
  /// Retorna um SizedBox com altura padronizada
  static SizedBox verticalSpace(double multiplier) {
    return SizedBox(height: spaceLG * multiplier);
  }
  
  /// Retorna um SizedBox com largura padronizada
  static SizedBox horizontalSpace(double multiplier) {
    return SizedBox(width: spaceLG * multiplier);
  }
  
  /// Retorna um Container com padding padronizado
  static Widget paddedContainer({
    required Widget child,
    EdgeInsets? padding,
  }) {
    return Container(
      padding: padding ?? screenPadding,
      child: child,
    );
  }
  
  /// Retorna um Card com estilo padronizado
  static Widget styledCard({
    required Widget child,
    EdgeInsets? padding,
    EdgeInsets? margin,
  }) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(vertical: spaceSM),
      padding: padding ?? cardPadding,
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor),
      ),
      child: child,
    );
  }
}
