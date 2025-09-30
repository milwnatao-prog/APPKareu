// Serviço de autenticação simplificado para evitar problemas de compatibilidade
class AuthService {
  // Estado atual do usuário (simulado para evitar problemas Firebase)
  static bool _isAuthenticated = false;
  static String? _currentUserId;

  // Estado atual do usuário
  static bool get isAuthenticated => _isAuthenticated;
  static String? get currentUserId => _currentUserId;

  /// Login com email e senha (simulado)
  static Future<AuthResult> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      // Simular delay de autenticação
      await Future.delayed(const Duration(seconds: 1));

      // Simular autenticação bem-sucedida
      _isAuthenticated = true;
      _currentUserId = 'user_${DateTime.now().millisecondsSinceEpoch}';

      return AuthResult.success('Login realizado com sucesso');
    } catch (e) {
      return AuthResult.error('Erro inesperado: ${e.toString()}');
    }
  }

  /// Registro com email e senha (simulado)
  static Future<AuthResult> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required UserType userType,
  }) async {
    try {
      // Simular delay de registro
      await Future.delayed(const Duration(seconds: 1));

      // Simular registro bem-sucedido
      _isAuthenticated = true;
      _currentUserId = 'user_${DateTime.now().millisecondsSinceEpoch}';

      return AuthResult.success('Conta criada com sucesso');
    } catch (e) {
      return AuthResult.error('Erro inesperado: ${e.toString()}');
    }
  }

  /// Logout (simulado)
  static Future<void> signOut() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      _isAuthenticated = false;
      _currentUserId = null;
      print('Logout realizado com sucesso');
    } catch (e) {
      print('Erro ao fazer logout: ${e.toString()}');
      throw Exception('Erro ao fazer logout: ${e.toString()}');
    }
  }

  /// Recuperação de senha (simulada)
  static Future<AuthResult> resetPassword(String email) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return AuthResult.success('Email de recuperação enviado (simulado)');
    } catch (e) {
      return AuthResult.error('Erro ao enviar email de recuperação');
    }
  }

  /// Obter dados do usuário atual (simulado)
  static Future<UserModel?> getCurrentUserData() async {
    if (!isAuthenticated) return null;

    try {
      await Future.delayed(const Duration(milliseconds: 300));
      // Retorna dados simulados
      return UserModel(
        id: _currentUserId!,
        email: 'usuario@exemplo.com',
        name: 'Usuário Exemplo',
        userType: UserType.needCaregiver,
        createdAt: DateTime.now(),
        subscriptionTier: SubscriptionTier.free,
      );
    } catch (e) {
      return null;
    }
  }

  /// Atualizar perfil do usuário (simulado)
  static Future<AuthResult> updateUserProfile({
    String? name,
    String? phone,
    String? bio,
    String? profileImageUrl,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return AuthResult.success('Perfil atualizado com sucesso (simulado)');
    } catch (e) {
      return AuthResult.error('Erro ao atualizar perfil: ${e.toString()}');
    }
  }

  /// Verificar se email já está em uso (simulado)
  static Future<bool> isEmailInUse(String email) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return false; // Simular que email está disponível
    } catch (e) {
      return false;
    }
  }

  // Métodos auxiliares removidos - serviço completamente simplificado
}

class AuthResult {
  final bool success;
  final String message;

  AuthResult.success(this.message) : success = true;
  AuthResult.error(this.message) : success = false;
}

// Métodos auxiliares para facilitar o uso
class AuthHelper {
  static bool get isCaregiver => AuthService.currentUser != null &&
      AuthService.getCurrentUserData() != null;

  static bool get isPatient => AuthService.currentUser != null &&
      AuthService.getCurrentUserData() != null;

  static Future<UserType?> get currentUserType async {
    final userData = await AuthService.getCurrentUserData();
    return userData?.userType;
  }
}
