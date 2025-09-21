class SessionService {
  SessionService._internal();

  static final SessionService instance = SessionService._internal();

  bool isLoggedIn = false;
  bool isProfessional = false;

  void loginAsFamily() {
    isLoggedIn = true;
    isProfessional = false;
  }

  void loginAsProfessional() {
    isLoggedIn = true;
    isProfessional = true;
  }

  void logout() {
    isLoggedIn = false;
    isProfessional = false;
  }
}


