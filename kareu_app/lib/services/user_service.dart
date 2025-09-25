class UserService {
  static UserType _currentUserType = UserType.patient; // Default para teste
  static SubscriptionTier _currentSubscriptionTier = SubscriptionTier.free;
  static final String _currentUserId = 'user_001'; // Simulação
  
  static UserType get currentUserType => _currentUserType;
  static SubscriptionTier get currentSubscriptionTier => _currentSubscriptionTier;
  static String get currentUserId => _currentUserId;
  
  static void setUserType(UserType type) {
    _currentUserType = type;
  }
  
  static void setSubscriptionTier(SubscriptionTier tier) {
    _currentSubscriptionTier = tier;
  }
  
  static bool get isCaregiver => _currentUserType == UserType.caregiver;
  static bool get isPatient => _currentUserType == UserType.patient;
  
  static String getAccountRoute() {
    return isCaregiver ? '/caregiver-account' : '/patient-account';
  }
  
  // Funcionalidades de monetização
  static bool canAcceptBookings() {
    if (!isCaregiver) return false;
    return _currentSubscriptionTier != SubscriptionTier.free;
  }
  
  static int getMonthlyBookingLimit() {
    switch (_currentSubscriptionTier) {
      case SubscriptionTier.free:
        return 0; // Perfil apenas para visualização
      case SubscriptionTier.basic:
        return 5;
      case SubscriptionTier.plus:
      case SubscriptionTier.premium:
        return -1; // Ilimitado
    }
  }
  
  static bool hasSearchPriority() {
    return _currentSubscriptionTier == SubscriptionTier.plus || 
           _currentSubscriptionTier == SubscriptionTier.premium;
  }
  
  static bool hasTopSearchPosition() {
    return _currentSubscriptionTier == SubscriptionTier.premium;
  }
  
  static bool hasPremiumBadge() {
    return _currentSubscriptionTier == SubscriptionTier.premium;
  }
  
  static bool hasVerifiedBadge() {
    return _currentSubscriptionTier != SubscriptionTier.free;
  }
  
  static bool canAccessPremiumFeatures() {
    return _currentSubscriptionTier == SubscriptionTier.plus || 
           _currentSubscriptionTier == SubscriptionTier.premium;
  }
  
  static String getSubscriptionDisplayName() {
    switch (_currentSubscriptionTier) {
      case SubscriptionTier.free:
        return 'Gratuito';
      case SubscriptionTier.basic:
        return 'Básico';
      case SubscriptionTier.plus:
        return 'Plus';
      case SubscriptionTier.premium:
        return 'Premium';
    }
  }
  
  static double getSubscriptionPrice() {
    switch (_currentSubscriptionTier) {
      case SubscriptionTier.free:
        return 0.0;
      case SubscriptionTier.basic:
        return 29.90;
      case SubscriptionTier.plus:
        return 49.90;
      case SubscriptionTier.premium:
        return 79.90;
    }
  }
}

enum UserType {
  caregiver,
  patient,
}

enum SubscriptionTier {
  free,     // Perfil limitado - apenas visualização
  basic,    // R$ 29,90 - Perfil ativo + 5 agendamentos/mês
  plus,     // R$ 49,90 - Ilimitado + destaque na busca
  premium,  // R$ 79,90 - Tudo + posição top + badge premium
}
