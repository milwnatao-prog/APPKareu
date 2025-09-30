// Serviço de localização completamente simplificado
class LocationService {
  /// Verifica e solicita permissões de localização (simulado)
  static Future<bool> checkLocationPermission() async {
    // Simular verificação de permissões
    await Future.delayed(const Duration(milliseconds: 500));
    return true; // Simular que permissões estão concedidas
  }

  /// Obtém localização atual do usuário (simulada)
  static Future<Position?> getCurrentLocation() async {
    try {
      // Simular delay de obtenção de localização
      await Future.delayed(const Duration(seconds: 1));

      // Retornar localização simulada (São Paulo, Brasil)
      return Position(
        latitude: -23.5505,
        longitude: -46.6333,
        timestamp: DateTime.now(),
        accuracy: 10.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
      );
    } catch (e) {
      print('Erro ao obter localização: $e');
      return null;
    }
  }

  /// Calcula distância entre duas coordenadas (em km) - versão simplificada
  static double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    // Fórmula simplificada de distância (não é precisa, mas serve para demonstração)
    const double earthRadius = 6371; // Raio da Terra em km

    double dLat = _degreesToRadians(lat2 - lat1);
    double dLng = _degreesToRadians(lng2 - lng1);

    double a = (dLat / 2).sin() * (dLat / 2).sin() +
        lat1.cos() * lat2.cos() *
        (dLng / 2).sin() * (dLng / 2).sin();

    double c = 2 * a.sqrt().atan2(1 - a.sqrt());

    return earthRadius * c;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * (3.141592653589793 / 180);
  }

  /// Calcula distância formatada para exibição
  static String formatDistance(double distanceKm) {
    if (distanceKm < 1) {
      return '${(distanceKm * 1000).round()}m';
    } else {
      return '${distanceKm.toStringAsFixed(1)}km';
    }
  }

  /// Busca cuidadores próximos (simulada)
  static Future<List<UserModel>> findNearbyCaregivers({
    required double latitude,
    required double longitude,
    double radiusKm = 10.0,
    List<String>? specialties,
    double? minRating,
    int? limit,
  }) async {
    // Simular delay de busca
    await Future.delayed(const Duration(seconds: 1));

    // Retornar cuidadores simulados
    return [
      UserModel(
        id: 'caregiver_1',
        email: 'maria@email.com',
        name: 'Maria Silva',
        userType: UserType.amCaregiver,
        subscriptionTier: SubscriptionTier.premium,
        createdAt: DateTime.now(),
        isProfileComplete: true,
        specialty: 'Cuidadora',
        experience: '5 anos',
        hourlyRate: 25.0,
        rating: 4.8,
        totalReviews: 45,
        latitude: latitude + 0.01, // Próximo à localização do usuário
        longitude: longitude + 0.01,
        address: 'São Paulo, SP',
      ),
      UserModel(
        id: 'caregiver_2',
        email: 'joao@email.com',
        name: 'João Santos',
        userType: UserType.amCaregiver,
        subscriptionTier: SubscriptionTier.plus,
        createdAt: DateTime.now(),
        isProfileComplete: true,
        specialty: 'Técnico de Enfermagem',
        experience: '8 anos',
        hourlyRate: 35.0,
        rating: 4.9,
        totalReviews: 32,
        latitude: latitude - 0.005,
        longitude: longitude - 0.005,
        address: 'São Paulo, SP',
      ),
    ];
  }

  /// Atualiza localização do usuário (simulada)
  static Future<bool> updateUserLocation(String userId, double lat, double lng) async {
    // Simular atualização de localização
    print('Localização atualizada para usuário $userId: $lat, $lng');
    return true;
  }

  /// Obtém localização salva do usuário (simulada)
  static Future<Map<String, dynamic>?> getSavedLocation(String userId) async {
    // Simular retorno de localização salva
    return {
      'latitude': -23.5505,
      'longitude': -46.6333,
      'address': 'São Paulo, SP',
      'city': 'São Paulo',
      'state': 'SP',
    };
  }

  /// Obtém coordenadas do endereço completo (simulada)
  static Future<LocationData?> getLocationFromFullAddress({
    required String street,
    required String number,
    required String city,
    required String state,
    String? zipCode,
  }) async {
    // Simular conversão de endereço para coordenadas
    return LocationData(
      latitude: -23.5505,
      longitude: -46.6333,
      address: '$street, $number, $city, $state',
    );
  }
}

class LocationData {
  final double latitude;
  final double longitude;
  final String? address;

  LocationData({
    required this.latitude,
    required this.longitude,
    this.address,
  });
}

// Classe auxiliar para simular Position
class Position {
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final double accuracy;
  final double altitude;
  final double heading;
  final double speed;
  final double speedAccuracy;

  Position({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    required this.accuracy,
    required this.altitude,
    required this.heading,
    required this.speed,
    required this.speedAccuracy,
  });
}

