class UserService {
  static UserType _currentUserType = UserType.patient; // Default para teste
  
  static UserType get currentUserType => _currentUserType;
  
  static void setUserType(UserType type) {
    _currentUserType = type;
  }
  
  static bool get isCaregiver => _currentUserType == UserType.caregiver;
  static bool get isPatient => _currentUserType == UserType.patient;
  
  static String getAccountRoute() {
    return isCaregiver ? '/caregiver-account' : '/patient-account';
  }
}

enum UserType {
  caregiver,
  patient,
}
