import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  
  // Aliases de spacing para manter compatibilidade
  static const double spacing2 = spaceSM;    // 8px
  static const double spacing3 = spaceMD;    // 12px
  static const double spacing4 = spaceLG;    // 16px

  // ============================================================================
  // RESPONSIVIDADE - Breakpoints e adaptações
  // ============================================================================

  /// Breakpoints para diferentes tamanhos de tela
  static const double breakpointMobile = 480;
  static const double breakpointTablet = 768;
  static const double breakpointDesktop = 1024;
  static const double breakpointLarge = 1440;

  /// Verifica se está em modo mobile
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < breakpointTablet;

  /// Verifica se está em modo tablet
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= breakpointTablet &&
      MediaQuery.of(context).size.width < breakpointDesktop;

  /// Verifica se está em modo desktop
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= breakpointDesktop;

  /// Retorna espaçamento responsivo baseado no tamanho da tela
  static double responsiveSpacing(BuildContext context, double mobile, double tablet, double desktop) {
    if (isDesktop(context)) return desktop;
    if (isTablet(context)) return tablet;
    return mobile;
  }

  /// Retorna tamanho de fonte responsivo
  static double responsiveFontSize(BuildContext context, double mobile, double tablet, double desktop) {
    if (isDesktop(context)) return desktop;
    if (isTablet(context)) return tablet;
    return mobile;
  }

  /// Padding responsivo para telas
  static EdgeInsets responsivePadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= breakpointLarge) {
      return const EdgeInsets.symmetric(horizontal: space6XL, vertical: space2XL);
    } else if (width >= breakpointDesktop) {
      return const EdgeInsets.symmetric(horizontal: space4XL, vertical: spaceLG);
    } else if (width >= breakpointTablet) {
      return const EdgeInsets.symmetric(horizontal: space2XL, vertical: spaceLG);
    } else {
      return const EdgeInsets.symmetric(horizontal: spaceLG, vertical: spaceMD);
    }
  }

  /// Widget wrapper para responsividade automática
  static Widget responsiveWrapper({
    required BuildContext context,
    required Widget child,
    double? maxWidth,
  }) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? (isDesktop(context) ? 1200 : double.infinity),
        ),
        child: Padding(
          padding: responsivePadding(context),
          child: child,
        ),
      ),
    );
  }

  /// Altura da AppBar responsiva
  static double responsiveAppBarHeight(BuildContext context) {
    return isMobile(context) ? kToolbarHeight : kToolbarHeight + 8;
  }
  
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
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: textSecondaryColor,
  );
  
  /// Estilo para AppBar
  static const TextStyle appBarStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: fontSizeH3,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: textPrimaryColor,
  );
  
  /// Estilo para seções/categorias
  static const TextStyle sectionTitleStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: fontSizeH3,
    fontWeight: FontWeight.w700,
    height: 1.3,
    color: textPrimaryColor,
  );
  
  /// Estilo para cards
  static const TextStyle cardTitleStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: fontSizeBody,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: textPrimaryColor,
  );
  
  /// Estilo para subtítulos de cards
  static const TextStyle cardSubtitleStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: fontSizeBodySmall,
    fontWeight: FontWeight.w500,
    height: 1.3,
    color: primaryColor,
  );
  
  /// Estilo para informações secundárias
  static const TextStyle infoStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: fontSizeCaption,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: textSecondaryColor,
  );
  
  /// Estilo para preços/valores
  static const TextStyle priceStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: fontSizeBodySmall,
    fontWeight: FontWeight.w700,
    height: 1.3,
    color: successColor,
  );
  
  // ============================================================================
  // CORES DO APLICATIVO
  // ============================================================================
  
  // Cores principais
  static const Color primaryColor = Color(0xFF4D64C8);
  static const Color secondaryColor = Color(0xFFFFAD00);
  static const Color accentColor = Color(0xFF353B7E);
  
  // Cores de fundo
  static const Color backgroundColor = Colors.white;
  static const Color surfaceColor = Color(0xFFF8F9FA);
  static const Color cardColor = Colors.white;
  static const Color overlayColor = Color(0xFFF5F5F5);
  
  // Cores de borda
  static const Color borderColor = Color(0xFFE1E5E9);
  static const Color borderLightColor = Color(0xFFF1F3F4);
  static const Color borderDarkColor = Color(0xFFD1D5DB);
  
  // Cores de texto
  static const Color textPrimaryColor = Color(0xFF1F2937);
  static const Color textSecondaryColor = Color(0xFF6B7280);
  static const Color textTertiaryColor = Color(0xFF9CA3AF);
  static const Color textHintColor = Color(0xFFD1D5DB);
  
  // Cores de estado
  static const Color errorColor = Color(0xFFEF4444);
  static const Color successColor = Color(0xFF10B981);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color infoColor = Color(0xFF3B82F6);

  // Cores específicas para funcionalidades
  static const Color goldColor = Color(0xFFFFD700); // Dourado para badges premium
  static const Color verifiedColor = Color(0xFF10B981); // Verde para badges verificados
  static const Color ratingColor = Color(0xFFFFAD00); // Amarelo para estrelas de avaliação
  
  // Aliases para compatibilidade
  static const Color textColor = textPrimaryColor;
  static const Color placeholderColor = textHintColor;
  
  // Aliases para manter compatibilidade com código existente
  static const Color darkColor = textPrimaryColor;
  static const Color grayColor = textSecondaryColor;
  static const Color lightGrayColor = borderLightColor;
  
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
    Color? color,
  }) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(vertical: spaceSM),
      padding: padding ?? cardPadding,
      decoration: BoxDecoration(
        color: color ?? cardColor,
        borderRadius: BorderRadius.circular(borderRadiusLarge),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: child,
    );
  }
  
  /// Retorna um AppBar padronizado
  static AppBar styledAppBar({
    required String title,
    required BuildContext context,
    bool centerTitle = true,
    List<Widget>? actions,
    Widget? leading,
    VoidCallback? onBackPressed,
  }) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      centerTitle: centerTitle,
      leading: leading ?? (onBackPressed != null 
        ? IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: textPrimaryColor,
              size: 20,
            ),
            onPressed: onBackPressed,
          )
        : null),
      title: Text(title, style: appBarStyle),
      actions: actions,
    );
  }
  
  /// Retorna um botão primário padronizado
  static Widget primaryButton({
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
    double? width,
    double height = 56,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusLarge),
          ),
          elevation: 0,
        ),
        child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Text(text, style: buttonStyle),
      ),
    );
  }
  
  /// Retorna um botão secundário padronizado
  static Widget secondaryButton({
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
    double? width,
    double height = 56,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: primaryColor, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusLarge),
          ),
        ),
        child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: primaryColor,
                strokeWidth: 2,
              ),
            )
          : Text(
              text, 
              style: buttonStyle.copyWith(color: primaryColor),
            ),
      ),
    );
  }
  
  /// Retorna um campo de entrada padronizado
  static Widget styledTextField({
    required String label,
    String? hint,
    TextEditingController? controller,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    Widget? suffixIcon,
    IconData? prefixIcon,
    List<TextInputFormatter>? inputFormatters,
    TextCapitalization textCapitalization = TextCapitalization.none,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: labelStyle),
        const SizedBox(height: spaceSM),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          onChanged: onChanged,
          maxLines: maxLines,
          style: bodyStyle,
          inputFormatters: inputFormatters,
          textCapitalization: textCapitalization,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: placeholderStyle,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: grayColor) : null,
            filled: true,
            fillColor: surfaceColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadiusLarge),
              borderSide: const BorderSide(color: borderColor, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadiusLarge),
              borderSide: const BorderSide(color: borderColor, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadiusLarge),
              borderSide: const BorderSide(color: primaryColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadiusLarge),
              borderSide: const BorderSide(color: errorColor, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: spaceLG,
              vertical: spaceLG,
            ),
          ),
        ),
      ],
    );
  }
}
