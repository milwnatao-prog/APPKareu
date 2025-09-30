import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_design_system.dart';
import '../services/mercado_pago_service.dart';
import '../services/split_payment_service.dart';
import '../services/user_service.dart';

class RealPaymentScreen extends StatefulWidget {
  const RealPaymentScreen({super.key});

  @override
  State<RealPaymentScreen> createState() => _RealPaymentScreenState();
}

class _RealPaymentScreenState extends State<RealPaymentScreen> {
  String _selectedPaymentMethod = '';
  bool _isProcessing = false;
  
  // Dados recebidos via argumentos
  Map<String, dynamic>? _caregiverData;
  dynamic _priceCalculation;
  
  // Dados do pagador
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  
  // Dados do cartão (para tokenização)
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  
  // Parcelamento
  List<InstallmentOption> _installmentOptions = [];
  int _selectedInstallments = 1;
  
  // PIX
  PixPaymentResponse? _pixResponse;
  
  @override
  void initState() {
    super.initState();
    _handlePixPayment = () {
      _processPixPayment().catchError((error) {
        setState(() {
          _isProcessing = false;
        });
        _showError('Erro no processamento do pagamento PIX');
      });
    };
    _handleCardPayment = () {
      _processCardPayment().catchError((error) {
        setState(() {
          _isProcessing = false;
        });
        _showError('Erro no processamento do pagamento com cartão');
      });
    };
    _loadUserData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Receber dados via argumentos
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      setState(() {
        _caregiverData = args['caregiverData'];
        _priceCalculation = args['priceCalculation'];
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _cpfController.dispose();
    _phoneController.dispose();
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    // Carregar dados do usuário logado (simulado)
    _nameController.text = 'João';
    _surnameController.text = 'Silva';
    _emailController.text = 'joao.silva@email.com';
    _cpfController.text = '12345678901';
    _phoneController.text = '11999999999';
  }

  Future<void> _loadInstallmentOptions() async {
    if (_selectedPaymentMethod.isNotEmpty && _priceCalculation != null) {
      try {
        final options = await MercadoPagoService.getInstallmentOptions(
          paymentMethodId: _selectedPaymentMethod,
          amount: _priceCalculation!.totalAmount,
        );
        
        setState(() {
          _installmentOptions = options;
          _selectedInstallments = 1;
        });
      } catch (e) {
        _showError('Erro ao carregar parcelamento: $e');
      }
    }
  }

  Future<void> _processPixPayment() async {
    if (!_validatePayerData()) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      // Usar split payment para PIX
      final splitRequest = SplitPaymentRequest(
        totalAmount: _priceCalculation!.totalAmount,
        description: 'Contratação de cuidador - ${_caregiverData?['name'] ?? 'Cuidador'}',
        paymentMethodId: 'pix',
        payerEmail: _emailController.text,
        payerName: _nameController.text,
        payerSurname: _surnameController.text,
        payerCPF: _cpfController.text.replaceAll(RegExp(r'[^0-9]'), ''),
        caregiverAccountId: _caregiverData?['account_id'] ?? 'caregiver_account_123',
        caregiverId: _caregiverData?['id'] ?? 'caregiver_123',
        contractId: 'contract_${DateTime.now().millisecondsSinceEpoch}',
        externalReference: 'kareu_${DateTime.now().millisecondsSinceEpoch}',
      );

      final response = await SplitPaymentService.createSplitPayment(request: splitRequest);
      
      _showSplitSuccessDialog(response);
    } catch (e) {
      _showError('Erro ao processar PIX: $e');
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<void> _processCardPayment() async {
    if (!_validatePayerData() || !_validateCardData()) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      // Em uma implementação real, você precisaria tokenizar o cartão
      // usando o SDK do Mercado Pago no frontend antes de enviar para o backend
      
      // Por enquanto, vamos simular um token
      final cardToken = 'simulated_card_token_${DateTime.now().millisecondsSinceEpoch}';
      
      final splitRequest = SplitPaymentRequest(
        totalAmount: _priceCalculation!.totalAmount,
        description: 'Contratação de cuidador - ${_caregiverData?['name'] ?? 'Cuidador'}',
        paymentMethodId: _selectedPaymentMethod,
        payerEmail: _emailController.text,
        payerName: _nameController.text,
        payerSurname: _surnameController.text,
        payerCPF: _cpfController.text.replaceAll(RegExp(r'[^0-9]'), ''),
        caregiverAccountId: _caregiverData?['account_id'] ?? 'caregiver_account_123',
        caregiverId: _caregiverData?['id'] ?? 'caregiver_123',
        contractId: 'contract_${DateTime.now().millisecondsSinceEpoch}',
        externalReference: 'kareu_${DateTime.now().millisecondsSinceEpoch}',
        cardToken: cardToken,
        installments: _selectedInstallments,
        issuerId: 'visa', // Seria obtido dinamicamente
      );

      final response = await SplitPaymentService.createSplitPayment(request: splitRequest);
      
      _showSplitSuccessDialog(response);
    } catch (e) {
      _showError('Erro ao processar cartão: $e');
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  bool _validatePayerData() {
    if (_nameController.text.trim().isEmpty) {
      _showError('Nome é obrigatório');
      return false;
    }
    
    if (_surnameController.text.trim().isEmpty) {
      _showError('Sobrenome é obrigatório');
      return false;
    }
    
    if (_emailController.text.trim().isEmpty || !_emailController.text.contains('@')) {
      _showError('Email válido é obrigatório');
      return false;
    }
    
    if (!MercadoPagoService.isValidCPF(_cpfController.text)) {
      _showError('CPF inválido');
      return false;
    }
    
    return true;
  }

  bool _validateCardData() {
    if (_cardNumberController.text.replaceAll(' ', '').length < 16) {
      _showError('Número do cartão inválido');
      return false;
    }
    
    if (_cardHolderController.text.trim().isEmpty) {
      _showError('Nome no cartão é obrigatório');
      return false;
    }
    
    if (_expiryController.text.length < 5) {
      _showError('Data de validade inválida');
      return false;
    }
    
    if (_cvvController.text.length < 3) {
      _showError('CVV inválido');
      return false;
    }
    
    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppDesignSystem.errorColor,
      ),
    );
  }

  void _showPixDialog(PixPaymentResponse response) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppDesignSystem.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.pix,
              color: AppDesignSystem.successColor,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'PIX Gerado!',
              style: AppDesignSystem.h2Style,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppDesignSystem.borderColor),
              ),
              child: Column(
                children: [
                  // QR Code seria exibido aqui
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: AppDesignSystem.backgroundColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'QR CODE\n(Implementar com\nbiblioteca QR)',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Código PIX Copia e Cola:',
                    style: AppDesignSystem.captionStyle,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppDesignSystem.backgroundColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      response.qrCode,
                      style: AppDesignSystem.captionStyle.copyWith(
                        fontFamily: 'monospace',
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Escaneie o QR Code ou copie o código PIX para realizar o pagamento.',
              style: AppDesignSystem.bodyStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: response.qrCode));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Código PIX copiado!')),
              );
            },
            child: const Text('Copiar Código'),
          ),
          AppDesignSystem.primaryButton(
            text: 'Fechar',
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showSplitSuccessDialog(SplitPaymentResponse response) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppDesignSystem.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle,
              color: AppDesignSystem.successColor,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Pagamento Aprovado!',
              style: AppDesignSystem.h2Style,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'ID: ${response.id}',
              style: AppDesignSystem.captionStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            
            // Detalhes do Split
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppDesignSystem.backgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    'Divisão do Pagamento',
                    style: AppDesignSystem.bodyStyle.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSplitRow(
                    'Total Pago',
                    'R\$ ${response.splitCalculation.totalAmount.toStringAsFixed(2)}',
                    AppDesignSystem.textPrimaryColor,
                  ),
                  _buildSplitRow(
                    'Para o Cuidador',
                    'R\$ ${response.splitCalculation.caregiverAmount.toStringAsFixed(2)}',
                    AppDesignSystem.successColor,
                  ),
                  _buildSplitRow(
                    'Taxa de Serviço Kareu (${(response.splitCalculation.serviceFeeRate * 100).toStringAsFixed(0)}%)',
                    'R\$ ${response.splitCalculation.kareuServiceFee.toStringAsFixed(2)}',
                    AppDesignSystem.primaryColor,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            Text(
              'O cuidador receberá automaticamente sua parte. Você receberá confirmação por email.',
              style: AppDesignSystem.bodyStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          AppDesignSystem.primaryButton(
            text: 'Continuar',
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSplitInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppDesignSystem.captionStyle.copyWith(
              fontSize: 11,
            ),
          ),
          Text(
            value,
            style: AppDesignSystem.captionStyle.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSplitRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppDesignSystem.captionStyle,
          ),
          Text(
            value,
            style: AppDesignSystem.captionStyle.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String transactionId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppDesignSystem.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle,
              color: AppDesignSystem.successColor,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Pagamento Aprovado!',
              style: AppDesignSystem.h2Style,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Transação: $transactionId',
              style: AppDesignSystem.captionStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Seu cuidador foi contratado com sucesso. Você receberá uma confirmação por email.',
              style: AppDesignSystem.bodyStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          AppDesignSystem.primaryButton(
            text: 'Continuar',
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDesignSystem.backgroundColor,
      appBar: AppDesignSystem.styledAppBar(
        title: 'Pagamento Seguro',
        context: context,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resumo do Pagamento
            _buildPaymentSummary(),
            
            const SizedBox(height: 24),
            
            // Dados do Pagador
            _buildPayerData(),
            
            const SizedBox(height: 24),
            
            // Métodos de Pagamento
            _buildPaymentMethods(),
            
            const SizedBox(height: 24),
            
            // Formulário específico do método selecionado
            if (_selectedPaymentMethod == 'pix') _buildPixForm(),
            if (_selectedPaymentMethod == 'visa' || _selectedPaymentMethod == 'master') _buildCardForm(),
            
            const SizedBox(height: 24),
            
            // Botão de Pagamento
            _buildPaymentButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSummary() {
    if (_priceCalculation == null) return const SizedBox();

    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumo do Pagamento',
            style: AppDesignSystem.h3Style,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cuidador: ${_caregiverData?['name'] ?? 'Cuidador'}',
                style: AppDesignSystem.bodyStyle,
              ),
            ],
          ),
          const Divider(),
          ..._priceCalculation!.breakdown.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.description,
                    style: AppDesignSystem.bodyStyle,
                  ),
                  Text(
                    'R\$ ${item.amount.toStringAsFixed(2)}',
                    style: AppDesignSystem.bodyStyle.copyWith(
                      color: item.amount < 0 
                          ? AppDesignSystem.successColor 
                          : AppDesignSystem.textPrimaryColor,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total a Pagar',
                style: AppDesignSystem.h3Style,
              ),
              Text(
                'R\$ ${_priceCalculation!.totalAmount.toStringAsFixed(2)}',
                style: AppDesignSystem.h3Style.copyWith(
                  color: AppDesignSystem.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Informações do Split
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppDesignSystem.infoColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppDesignSystem.infoColor,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Divisão do Pagamento',
                      style: AppDesignSystem.captionStyle.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppDesignSystem.infoColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildSplitInfoRow(
                  'Para o cuidador (92%)',
                  'R\$ ${(_priceCalculation!.totalAmount * 0.92).toStringAsFixed(2)}',
                ),
                _buildSplitInfoRow(
                  'Taxa de Serviço Kareu (8%)',
                  'R\$ ${(_priceCalculation!.totalAmount * 0.08).toStringAsFixed(2)}',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayerData() {
    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dados do Pagador',
            style: AppDesignSystem.h3Style,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome *',
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _surnameController,
                  decoration: const InputDecoration(
                    labelText: 'Sobrenome *',
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email *',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _cpfController,
                  decoration: const InputDecoration(
                    labelText: 'CPF *',
                    border: OutlineInputBorder(),
                    hintText: '000.000.000-00',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Telefone',
                    border: OutlineInputBorder(),
                    hintText: '(11) 99999-9999',
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethods() {
    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Forma de Pagamento',
            style: AppDesignSystem.h3Style,
          ),
          const SizedBox(height: 16),
          _buildPaymentOption(
            'pix',
            'PIX',
            'Pagamento instantâneo',
            Icons.pix,
            AppDesignSystem.successColor,
          ),
          const SizedBox(height: 12),
          _buildPaymentOption(
            'visa',
            'Cartão de Crédito Visa',
            'Parcelamento disponível',
            Icons.credit_card,
            AppDesignSystem.primaryColor,
          ),
          const SizedBox(height: 12),
          _buildPaymentOption(
            'master',
            'Cartão de Crédito Mastercard',
            'Parcelamento disponível',
            Icons.credit_card,
            AppDesignSystem.warningColor,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String value, String title, String subtitle, IconData icon, Color color) {
    final isSelected = _selectedPaymentMethod == value;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = value;
        });
        if (value != 'pix') {
          _loadInstallmentOptions();
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? color : AppDesignSystem.borderColor,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? color.withOpacity(0.05) : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppDesignSystem.bodyStyle.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppDesignSystem.captionStyle,
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: color,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPixForm() {
    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PIX - Pagamento Instantâneo',
            style: AppDesignSystem.h3Style,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppDesignSystem.successColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppDesignSystem.successColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Após confirmar, você receberá o QR Code para pagamento instantâneo.',
                    style: AppDesignSystem.bodyStyle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardForm() {
    return Column(
      children: [
        AppDesignSystem.styledCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dados do Cartão',
                style: AppDesignSystem.h3Style,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _cardNumberController,
                decoration: const InputDecoration(
                  labelText: 'Número do Cartão *',
                  border: OutlineInputBorder(),
                  hintText: '1234 5678 9012 3456',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _cardHolderController,
                decoration: const InputDecoration(
                  labelText: 'Nome no Cartão *',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _expiryController,
                      decoration: const InputDecoration(
                        labelText: 'Validade *',
                        border: OutlineInputBorder(),
                        hintText: 'MM/AA',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _cvvController,
                      decoration: const InputDecoration(
                        labelText: 'CVV *',
                        border: OutlineInputBorder(),
                        hintText: '123',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        if (_installmentOptions.isNotEmpty) ...[
          const SizedBox(height: 16),
          AppDesignSystem.styledCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Parcelamento',
                  style: AppDesignSystem.h3Style,
                ),
                const SizedBox(height: 16),
                ...List.generate(_installmentOptions.length.clamp(0, 6), (index) {
                  final option = _installmentOptions[index];
                  
                  return RadioListTile<int>(
                    value: option.installments,
                    groupValue: _selectedInstallments,
                    onChanged: (value) {
                      setState(() {
                        _selectedInstallments = value ?? 1;
                      });
                    },
                    title: Text(
                      option.description,
                      style: AppDesignSystem.bodyStyle,
                    ),
                    subtitle: option.installments > 1 
                        ? Text(
                            'Total: R\$ ${option.totalAmount.toStringAsFixed(2)}',
                            style: AppDesignSystem.captionStyle,
                          )
                        : null,
                    activeColor: AppDesignSystem.primaryColor,
                    contentPadding: EdgeInsets.zero,
                  );
                }),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPaymentButton() {
    return SizedBox(
      width: double.infinity,
      child: AppDesignSystem.primaryButton(
        text: _isProcessing 
            ? 'Processando...' 
            : _selectedPaymentMethod == 'pix' 
                ? 'Gerar PIX' 
                : 'Pagar com Cartão',
        onPressed: () {
          // Temporariamente desabilitado para resolver conflitos de tipos
          // TODO: Implementar lógica de pagamento adequada
        },
      ),
    );
  }

  late final VoidCallback? _handlePixPayment;
  late final VoidCallback? _handleCardPayment;

  VoidCallback? _getPaymentCallback() {
    if (_selectedPaymentMethod == 'pix' && _handlePixPayment != null) {
      return _handlePixPayment;
    } else if (_selectedPaymentMethod == 'card' && _handleCardPayment != null) {
      return _handleCardPayment;
    }
    return null;
  }
}
