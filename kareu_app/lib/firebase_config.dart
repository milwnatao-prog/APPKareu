import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseConfig {
  static const _options = FirebaseOptions(
    apiKey: 'AIzaSyB8hQ3k4b0x7z9c1v2w3e4r5t6y7u8i9o0',
    appId: '1:123456789012:android:abc123def456ghi789',
    messagingSenderId: '123456789012',
    projectId: 'kareu-app',
    storageBucket: 'kareu-app.appspot.com',
    authDomain: 'kareu-app.firebaseapp.com',
    iosBundleId: 'com.kareu.app',
    iosClientId: '123456789012-abc123def456ghi789.apps.googleusercontent.com',
    androidClientId: '123456789012-abc123def456ghi789.apps.googleusercontent.com',
  );

  /// Inicializa o Firebase
  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: kIsWeb ? null : _options,
      );
      print('Firebase inicializado com sucesso');
    } catch (e) {
      print('Erro ao inicializar Firebase: $e');

      // Se já estiver inicializado, ignorar erro
      if (e.toString().contains('already exists')) {
        print('Firebase já estava inicializado');
        return;
      }

      // Para desenvolvimento local, inicializar sem opções específicas
      if (kDebugMode) {
        try {
          await Firebase.initializeApp();
          print('Firebase inicializado em modo desenvolvimento');
        } catch (e2) {
          print('Erro crítico na inicialização do Firebase: $e2');
        }
      }
    }
  }

  /// Obtém configuração específica para ambiente
  static FirebaseOptions getCurrentPlatformOptions() {
    if (kIsWeb) {
      return const FirebaseOptions(
        apiKey: 'AIzaSyB8hQ3k4b0x7z9c1v2w3e4r5t6y7u8i9o0',
        appId: '1:123456789012:web:abc123def456ghi789',
        messagingSenderId: '123456789012',
        projectId: 'kareu-app',
        authDomain: 'kareu-app.firebaseapp.com',
        storageBucket: 'kareu-app.appspot.com',
      );
    }

    // Para desenvolvimento, usar configuração genérica
    if (kDebugMode) {
      return _options;
    }

    return _options;
  }

  /// Verifica se o Firebase está inicializado
  static bool get isInitialized => Firebase.apps.isNotEmpty;

  /// Obtém instância do Firebase já inicializada
  static FirebaseApp get instance {
    if (!isInitialized) {
      throw Exception('Firebase não foi inicializado. Chame FirebaseConfig.initialize() primeiro.');
    }
    return Firebase.apps.first;
  }
}
