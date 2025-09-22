import 'package:flutter/material.dart';
import '../constants/app_design_system.dart';
import 'home_professional_screen.dart';

class TermsConfirmationScreen extends StatefulWidget {
  const TermsConfirmationScreen({super.key});

  @override
  State<TermsConfirmationScreen> createState() => _TermsConfirmationScreenState();
}

class _TermsConfirmationScreenState extends State<TermsConfirmationScreen> {
  bool _truthfulInfoAccepted = false;
  bool _documentVerificationAccepted = false;
  bool _termsAndPrivacyAccepted = false;

  bool get _allTermsAccepted => 
    _truthfulInfoAccepted && 
    _documentVerificationAccepted && 
    _termsAndPrivacyAccepted;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDesignSystem.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppDesignSystem.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppDesignSystem.textColor,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Termos e Confirmação',
          style: AppDesignSystem.h3Style,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDesignSystem.spaceL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                
                // Termos e checkboxes
                _buildTermItem(
                  isChecked: _truthfulInfoAccepted,
                  text: 'Declaro que as informações prestadas são verdadeiras.',
                  onChanged: (value) {
                    setState(() {
                      _truthfulInfoAccepted = value ?? false;
                    });
                  },
                ),
                
                const SizedBox(height: 20),
                
                _buildTermItem(
                  isChecked: _documentVerificationAccepted,
                  text: 'Autorizo a verificação de documentos e referências.',
                  onChanged: (value) {
                    setState(() {
                      _documentVerificationAccepted = value ?? false;
                    });
                  },
                ),
                
                const SizedBox(height: 20),
                
                _buildTermItem(
                  isChecked: _termsAndPrivacyAccepted,
                  text: 'Aceito os termos de Uso e Políticas de Privacidade da Kareu.',
                  onChanged: (value) {
                    setState(() {
                      _termsAndPrivacyAccepted = value ?? false;
                    });
                  },
                ),
                
                const SizedBox(height: 32),
                
                // Botão de envio
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _allTermsAccepted ? _submitRegistration : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _allTermsAccepted 
                          ? AppDesignSystem.primaryColor 
                          : AppDesignSystem.borderColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDesignSystem.spaceS),
                      ),
                    ),
                    child: Text(
                      'Enviar Cadastro',
                      style: AppDesignSystem.buttonStyle,
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTermItem({
    required bool isChecked,
    required String text,
    required ValueChanged<bool?> onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!isChecked),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppDesignSystem.spaceM,
          vertical: AppDesignSystem.spaceM,
        ),
        decoration: BoxDecoration(
          color: isChecked 
            ? AppDesignSystem.primaryColor.withValues(alpha: 0.1)
            : AppDesignSystem.surfaceColor,
          borderRadius: BorderRadius.circular(AppDesignSystem.spaceS),
          border: Border.all(
            color: isChecked 
              ? AppDesignSystem.primaryColor
              : AppDesignSystem.borderColor,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isChecked 
                  ? AppDesignSystem.primaryColor 
                  : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isChecked 
                    ? AppDesignSystem.primaryColor
                    : AppDesignSystem.borderColor,
                ),
              ),
              child: isChecked 
                ? Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  )
                : null,
            ),
            
            SizedBox(width: AppDesignSystem.spaceS),
            
            Expanded(
              child: Text(
                text,
                style: AppDesignSystem.bodySmallStyle,
                overflow: TextOverflow.visible,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitRegistration() {
    // Mostrar dialog de sucesso
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppDesignSystem.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesignSystem.spaceS),
          ),
          title: Text(
            'Cadastro Enviado!',
            style: AppDesignSystem.h3Style,
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Text(
              'Seu cadastro foi enviado com sucesso! Bem-vindo(a) à Kareu. Agora você pode acessar sua área profissional.',
              style: AppDesignSystem.bodySmallStyle,
              textAlign: TextAlign.center,
            ),
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fecha o dialog
                  // Navegar para a tela de usuário profissional
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const HomeProfessionalScreen(),
                    ),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppDesignSystem.primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDesignSystem.spaceS),
                  ),
                ),
                child: Text(
                  'Acessar Área Profissional',
                  style: AppDesignSystem.buttonStyle,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
