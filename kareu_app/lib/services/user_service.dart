import '../models/user_model.dart';

class UserService {
  static UserModel? _currentUser;
  static UserType _currentUserType = UserType.needCaregiver; // Default para teste
  static SubscriptionTier _currentSubscriptionTier = SubscriptionTier.free;

  static UserModel? get currentUser => _currentUser;
  static UserType get currentUserType {
    if (_currentUser != null) {
      return _currentUser!.userType;
    }
    return _currentUserType;
  }

  static SubscriptionTier get currentSubscriptionTier {
    if (_currentUser != null) {
      return _currentUser!.subscriptionTier;
    }
    return _currentSubscriptionTier;
  }
  static String get currentUserId => _currentUser?.id ?? 'user_001'; // Fallback para simulação

  static void setCurrentUser(UserModel? user) {
    _currentUser = user;
  }

  static void setUserType(UserType type) {
    _currentUserType = type;
  }

  static void setSubscriptionTier(SubscriptionTier tier) {
    _currentSubscriptionTier = tier;
  }

  static void clearCurrentUser() {
    _currentUser = null;
  }
  
  static bool get isCaregiver => _currentUserType == UserType.amCaregiver;
  static bool get isPatient => _currentUserType == UserType.needCaregiver;
  
  static String getAccountRoute() {
    return isCaregiver ? '/professional-account' : '/patient-account';
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
