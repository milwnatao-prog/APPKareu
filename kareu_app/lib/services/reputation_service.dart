// Import removido - não utilizado diretamente

class ReputationService {
  // Simulação de dados de avaliações
  static final Map<String, List<Rating>> _ratings = {
    'caregiver_001': [
      Rating(
        contractId: 'contract_001',
        raterId: 'patient_001',
        score: 4.8,
        contractValue: 500.0,
        comment: 'Excelente profissional, muito cuidadosa',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        isVerified: true,
      ),
      Rating(
        contractId: 'contract_002',
        raterId: 'patient_002',
        score: 4.9,
        contractValue: 800.0,
        comment: 'Pontual e dedicada, recomendo!',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        isVerified: true,
      ),
    ],
  };

  static final Map<String, List<String>> _completedContracts = {
    'patient_001': ['contract_001', 'contract_003'],
    'patient_002': ['contract_002', 'contract_004'],
  };

  /// Verifica se um usuário pode avaliar um cuidador
  /// Apenas usuários que tiveram contratos finalizados via app podem avaliar
  static Future<bool> canUserRate(String raterId, String caregiverId) async {
    final userContracts = _completedContracts[raterId] ?? [];
    
    // Verifica se existe pelo menos um contrato finalizado entre eles
    for (final contractId in userContracts) {
      final contract = await _getContractDetails(contractId);
      if (contract != null && contract['caregiverId'] == caregiverId && contract['status'] == 'completed') {
        return true;
      }
    }
    
    return false;
  }

  /// Calcula a avaliação ponderada baseada no valor dos contratos
  /// Contratos de maior valor têm peso maior na avaliação final
  static double calculateWeightedRating(String caregiverId) {
    final ratings = _ratings[caregiverId] ?? [];
    
    if (ratings.isEmpty) return 0.0;
    
    double totalWeight = 0;
    double weightedSum = 0;
    
    for (final rating in ratings) {
      if (!rating.isVerified) continue; // Apenas avaliações verificadas
      
      final weight = _getContractWeight(rating.contractValue);
      weightedSum += rating.score * weight;
      totalWeight += weight;
    }
    
    return totalWeight > 0 ? weightedSum / totalWeight : 0.0;
  }

  /// Obtém todas as avaliações verificadas de um cuidador
  static List<Rating> getVerifiedRatings(String caregiverId) {
    final ratings = _ratings[caregiverId] ?? [];
    return ratings.where((rating) => rating.isVerified).toList();
  }

  /// Adiciona uma nova avaliação (apenas para contratos via app)
  static Future<bool> addRating({
    required String caregiverId,
    required String raterId,
    required String contractId,
    required double score,
    required double contractValue,
    required String comment,
  }) async {
    // Verifica se o usuário pode avaliar
    if (!await canUserRate(raterId, caregiverId)) {
      return false;
    }

    // Verifica se já não avaliou este contrato
    final existingRatings = _ratings[caregiverId] ?? [];
    if (existingRatings.any((r) => r.contractId == contractId && r.raterId == raterId)) {
      return false; // Já avaliou este contrato
    }

    final newRating = Rating(
      contractId: contractId,
      raterId: raterId,
      score: score,
      contractValue: contractValue,
      comment: comment,
      createdAt: DateTime.now(),
      isVerified: true, // Sempre true para contratos via app
    );

    if (_ratings[caregiverId] == null) {
      _ratings[caregiverId] = [];
    }
    _ratings[caregiverId]!.add(newRating);

    return true;
  }

  /// Calcula estatísticas de reputação
  static ReputationStats getReputationStats(String caregiverId) {
    final ratings = getVerifiedRatings(caregiverId);
    
    if (ratings.isEmpty) {
      return ReputationStats(
        averageRating: 0.0,
        totalRatings: 0,
        ratingDistribution: {},
        totalContractValue: 0.0,
        verificationRate: 0.0,
      );
    }

    final averageRating = calculateWeightedRating(caregiverId);
    final totalContractValue = ratings.fold<double>(0.0, (sum, rating) => sum + rating.contractValue);
    
    // Distribuição de avaliações
    final distribution = <int, int>{};
    for (final rating in ratings) {
      final star = rating.score.round();
      distribution[star] = (distribution[star] ?? 0) + 1;
    }

    return ReputationStats(
      averageRating: averageRating,
      totalRatings: ratings.length,
      ratingDistribution: distribution,
      totalContractValue: totalContractValue,
      verificationRate: 1.0, // 100% para contratos via app
    );
  }

  /// Determina o nível de reputação baseado nas métricas
  static ReputationLevel getReputationLevel(String caregiverId) {
    final stats = getReputationStats(caregiverId);
    
    if (stats.totalRatings == 0) return ReputationLevel.newbie;
    if (stats.averageRating >= 4.8 && stats.totalRatings >= 20) return ReputationLevel.elite;
    if (stats.averageRating >= 4.5 && stats.totalRatings >= 10) return ReputationLevel.expert;
    if (stats.averageRating >= 4.0 && stats.totalRatings >= 5) return ReputationLevel.trusted;
    return ReputationLevel.developing;
  }

  /// Calcula o peso de um contrato baseado no valor
  static double _getContractWeight(double contractValue) {
    if (contractValue >= 1000) return 3.0;      // Contratos altos
    if (contractValue >= 500) return 2.0;       // Contratos médios
    if (contractValue >= 200) return 1.5;       // Contratos pequenos
    return 1.0;                                  // Contratos mínimos
  }

  /// Simula busca de detalhes do contrato
  static Future<Map<String, dynamic>?> _getContractDetails(String contractId) async {
    // Simulação - em produção viria do banco de dados
    final contracts = {
      'contract_001': {
        'id': 'contract_001',
        'caregiverId': 'caregiver_001',
        'patientId': 'patient_001',
        'status': 'completed',
        'value': 500.0,
      },
      'contract_002': {
        'id': 'contract_002',
        'caregiverId': 'caregiver_001',
        'patientId': 'patient_002',
        'status': 'completed',
        'value': 800.0,
      },
    };
    
    return contracts[contractId];
  }
}

/// Classe para representar uma avaliação
class Rating {
  final String contractId;
  final String raterId;
  final double score;
  final double contractValue;
  final String comment;
  final DateTime createdAt;
  final bool isVerified; // Sempre true para contratos via app

  Rating({
    required this.contractId,
    required this.raterId,
    required this.score,
    required this.contractValue,
    required this.comment,
    required this.createdAt,
    required this.isVerified,
  });
}

/// Estatísticas de reputação
class ReputationStats {
  final double averageRating;
  final int totalRatings;
  final Map<int, int> ratingDistribution; // Estrelas -> Quantidade
  final double totalContractValue;
  final double verificationRate; // % de avaliações verificadas

  ReputationStats({
    required this.averageRating,
    required this.totalRatings,
    required this.ratingDistribution,
    required this.totalContractValue,
    required this.verificationRate,
  });
}

/// Níveis de reputação
enum ReputationLevel {
  newbie,     // Novo no app
  developing, // Desenvolvendo reputação
  trusted,    // Confiável
  expert,     // Especialista
  elite,      // Elite
}

/// Extensão para obter informações dos níveis
extension ReputationLevelExtension on ReputationLevel {
  String get displayName {
    switch (this) {
      case ReputationLevel.newbie:
        return 'Iniciante';
      case ReputationLevel.developing:
        return 'Em Desenvolvimento';
      case ReputationLevel.trusted:
        return 'Confiável';
      case ReputationLevel.expert:
        return 'Especialista';
      case ReputationLevel.elite:
        return 'Elite';
    }
  }

  String get description {
    switch (this) {
      case ReputationLevel.newbie:
        return 'Novo profissional na plataforma';
      case ReputationLevel.developing:
        return 'Construindo sua reputação';
      case ReputationLevel.trusted:
        return 'Profissional confiável e bem avaliado';
      case ReputationLevel.expert:
        return 'Especialista com excelente histórico';
      case ReputationLevel.elite:
        return 'Profissional de elite com reputação excepcional';
    }
  }

  String get badgeColor {
    switch (this) {
      case ReputationLevel.newbie:
        return '#9CA3AF';      // Cinza
      case ReputationLevel.developing:
        return '#3B82F6';      // Azul
      case ReputationLevel.trusted:
        return '#10B981';      // Verde
      case ReputationLevel.expert:
        return '#F59E0B';      // Amarelo/Dourado
      case ReputationLevel.elite:
        return '#8B5CF6';      // Roxo
    }
  }
}
