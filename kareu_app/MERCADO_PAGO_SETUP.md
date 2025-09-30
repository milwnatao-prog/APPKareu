# 🚀 Configuração do Mercado Pago com Split de Pagamento - Kareu

## 💰 **MODELO DE NEGÓCIO IMPLEMENTADO**

O sistema implementa **split de pagamento automático**:
- **92%** vai para o cuidador
- **8%** taxa de serviço da Kareu
- **Divisão automática** em cada transação
- **Transparência total** para o usuário
- **Modelo equilibrado** que beneficia cuidadores e pacientes

---

## 📋 Pré-requisitos

### 1. Criar Conta no Mercado Pago
1. Acesse: https://www.mercadopago.com.br/developers
2. Crie uma conta de desenvolvedor
3. Acesse o painel de desenvolvedores

### 2. Obter Credenciais
1. No painel, vá em **"Suas integrações"**
2. Crie uma nova aplicação
3. Anote as credenciais:
   - **Public Key** (chave pública)
   - **Access Token** (token de acesso)

## 🔧 Configuração no Código

### 1. Atualizar Credenciais
No arquivo `lib/services/mercado_pago_service.dart`, substitua:

```dart
// LINHA 8-9: Substitua pelas suas credenciais reais
static const String _publicKey = 'TEST-your-public-key-here';
static const String _accessToken = 'TEST-your-access-token-here';
```

Por:
```dart
static const String _publicKey = 'TEST-sua-chave-publica-aqui';
static const String _accessToken = 'TEST-seu-access-token-aqui';
```

### 2. Configurar Webhooks
No painel do Mercado Pago:
1. Vá em **"Webhooks"**
2. Configure a URL: `https://seudominio.com/webhooks/mercadopago`
3. Selecione os eventos: **Payments**

### 3. Instalar Dependências
Execute no terminal:
```bash
cd kareu_app
flutter pub get
```

## 🌐 Configuração do Backend (Necessário)

### 1. Endpoint de Webhooks
Crie um endpoint para receber notificações:

```dart
// Exemplo em Dart/Flutter (backend)
@Post('/webhooks/mercadopago')
Future<Response> handleMercadoPagoWebhook(@Body() Map<String, dynamic> data) async {
  final result = await MercadoPagoService.processWebhook(data);
  
  if (result.success) {
    // Atualizar status do pagamento no banco de dados
    await updatePaymentStatus(result.paymentStatus);
  }
  
  return Response.ok({'status': 'received'});
}
```

### 2. Tokenização de Cartão (Frontend)
Para maior segurança, implemente tokenização no frontend:

```html
<!-- Adicionar no index.html -->
<script src="https://sdk.mercadopago.com/js/v2"></script>

<script>
const mp = new MercadoPago('SUA_PUBLIC_KEY');

// Criar token do cartão
const cardToken = await mp.createCardToken({
  cardNumber: '4509953566233704',
  cardholderName: 'APRO',
  cardExpirationMonth: '11',
  cardExpirationYear: '25',
  securityCode: '123',
  identificationType: 'CPF',
  identificationNumber: '12345678901'
});
</script>
```

## 🧪 Testes

### 1. Cartões de Teste
Use estes cartões para testar:

| Cartão | Número | CVV | Resultado |
|--------|--------|-----|-----------|
| Visa | 4509 9535 6623 3704 | 123 | Aprovado |
| Mastercard | 5031 7557 3453 0604 | 123 | Aprovado |
| Visa | 4013 5406 8274 6260 | 123 | Recusado |

### 2. CPFs de Teste
- **Aprovado:** 12345678909
- **Recusado:** 12345678901

### 3. PIX de Teste
- Qualquer valor funciona em ambiente de teste
- QR Code será gerado automaticamente

## 🔒 Segurança

### 1. Variáveis de Ambiente
**NUNCA** commite credenciais no código. Use variáveis de ambiente:

```dart
// Exemplo com flutter_dotenv
static String get _publicKey => dotenv.env['MERCADO_PAGO_PUBLIC_KEY']!;
static String get _accessToken => dotenv.env['MERCADO_PAGO_ACCESS_TOKEN']!;
```

### 2. HTTPS Obrigatório
- Mercado Pago exige HTTPS em produção
- Configure SSL no seu servidor

### 3. Validação de Webhooks
Implemente validação de assinatura nos webhooks:

```dart
bool validateWebhookSignature(String signature, String body) {
  // Implementar validação conforme documentação MP
  return true;
}
```

## 📊 Monitoramento

### 1. Logs Importantes
Monitore estes eventos:
- Pagamentos aprovados/recusados
- Webhooks recebidos
- Erros de API

### 2. Métricas Recomendadas
- Taxa de aprovação de pagamentos
- Tempo médio de processamento
- Chargebacks e disputas

## 🚀 Deploy em Produção

### 1. Credenciais de Produção
1. No painel MP, mude para **"Produção"**
2. Obtenha novas credenciais (sem "TEST-")
3. Atualize no código

### 2. Certificação
1. Complete o processo de certificação no MP
2. Teste todos os fluxos de pagamento
3. Configure monitoramento

## 📞 Suporte

### Documentação Oficial
- https://www.mercadopago.com.br/developers/pt/docs

### Suporte Técnico
- developers@mercadopago.com
- Slack da comunidade de desenvolvedores

## ✅ Checklist de Implementação

- [ ] Conta criada no Mercado Pago
- [ ] Credenciais obtidas e configuradas
- [ ] Dependências instaladas
- [ ] Webhooks configurados
- [ ] Testes realizados com cartões de teste
- [ ] Tokenização implementada (frontend)
- [ ] Validação de webhooks implementada
- [ ] Logs e monitoramento configurados
- [ ] Certificação concluída
- [ ] Deploy em produção realizado

## 💡 Dicas Importantes

1. **Sempre teste em ambiente de desenvolvimento primeiro**
2. **Use HTTPS mesmo em desenvolvimento**
3. **Monitore logs de erro constantemente**
4. **Mantenha as credenciais seguras**
5. **Implemente retry para APIs que falharem**
6. **Configure timeouts adequados**
7. **Valide todos os dados antes de enviar**

---

**🎯 Com essa configuração, o Kareu terá um sistema de pagamento real e robusto!**
