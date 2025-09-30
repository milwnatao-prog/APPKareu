import 'package:flutter/material.dart';

class AppStateProvider extends ChangeNotifier {
  bool _isLoading = true;
  String? _error;

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;

  AppStateProvider() {
    _initializeApp();
  }

  /// Inicializa o estado do aplicativo
  Future<void> _initializeApp() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simular inicialização
      await Future.delayed(const Duration(seconds: 1));
      _error = null;
    } catch (e) {
      _error = 'Erro ao inicializar aplicativo: ${e.toString()}';
      print(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Define erro
  void setError(String error) {
    _error = error;
    notifyListeners();
  }

  /// Limpa erro
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
