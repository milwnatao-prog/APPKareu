import 'package:cloud_firestore/cloud_firestore.dart';

enum ReviewType {
  caregiverToPatient,  // Cuidador avaliando paciente/família
  patientToCaregiver,  // Paciente/família avaliando cuidador
  serviceReview,       // Avaliação geral do serviço
}

class Review {
  final String id;
  final String reviewerId;
  final String reviewedUserId;
  final ReviewType type;
  final double rating;
  final String? comment;
  final List<String> tags;
  final Map<String, double>? categoryRatings; // Para avaliações detalhadas
  final bool isAnonymous;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isVerified; // Se o serviço foi realmente prestado
  final String? appointmentId; // ID do agendamento relacionado
  final String? contractId; // ID do contrato relacionado

  Review({
    required this.id,
    required this.reviewerId,
    required this.reviewedUserId,
    required this.type,
    required this.rating,
    this.comment,
    this.tags = const [],
    this.categoryRatings,
    this.isAnonymous = false,
    required this.createdAt,
    this.updatedAt,
    this.isVerified = false,
    this.appointmentId,
    this.contractId,
  });

  // Construtor para criar nova avaliação
  factory Review.create({
    required String reviewerId,
    required String reviewedUserId,
    required ReviewType type,
    required double rating,
    String? comment,
    List<String> tags = const [],
    Map<String, double>? categoryRatings,
    bool isAnonymous = false,
    String? appointmentId,
    String? contractId,
  }) {
    return Review(
      id: '', // Será gerado pelo Firestore
      reviewerId: reviewerId,
      reviewedUserId: reviewedUserId,
      type: type,
      rating: rating,
      comment: comment,
      tags: tags,
      categoryRatings: categoryRatings,
      isAnonymous: isAnonymous,
      createdAt: DateTime.now(),
      appointmentId: appointmentId,
      contractId: contractId,
    );
  }

  // Cópia com modificações
  Review copyWith({
    String? comment,
    List<String>? tags,
    Map<String, double>? categoryRatings,
    DateTime? updatedAt,
  }) {
    return Review(
      id: id,
      reviewerId: reviewerId,
      reviewedUserId: reviewedUserId,
      type: type,
      rating: rating,
      comment: comment ?? this.comment,
      tags: tags ?? this.tags,
      categoryRatings: categoryRatings ?? this.categoryRatings,
      isAnonymous: isAnonymous,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isVerified: isVerified,
      appointmentId: appointmentId,
      contractId: contractId,
    );
  }

  // Converte para Map para Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'reviewerId': reviewerId,
      'reviewedUserId': reviewedUserId,
      'type': type.name,
      'rating': rating,
      'comment': comment,
      'tags': tags,
      'categoryRatings': categoryRatings,
      'isAnonymous': isAnonymous,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'isVerified': isVerified,
      'appointmentId': appointmentId,
      'contractId': contractId,
    };
  }

  // Cria instância a partir de dados do Firestore
  factory Review.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Review(
      id: doc.id,
      reviewerId: data['reviewerId'] ?? '',
      reviewedUserId: data['reviewedUserId'] ?? '',
      type: ReviewType.values.firstWhere(
        (e) => e.name == data['type'],
        orElse: () => ReviewType.serviceReview,
      ),
      rating: (data['rating'] ?? 0.0).toDouble(),
      comment: data['comment'],
      tags: data['tags'] != null ? List<String>.from(data['tags']) : [],
      categoryRatings: data['categoryRatings'] != null
          ? Map<String, double>.from(data['categoryRatings'])
          : null,
      isAnonymous: data['isAnonymous'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      isVerified: data['isVerified'] ?? false,
      appointmentId: data['appointmentId'],
      contractId: data['contractId'],
    );
  }

  // Converte para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reviewerId': reviewerId,
      'reviewedUserId': reviewedUserId,
      'type': type.name,
      'rating': rating,
      'comment': comment,
      'tags': tags,
      'categoryRatings': categoryRatings,
      'isAnonymous': isAnonymous,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isVerified': isVerified,
      'appointmentId': appointmentId,
      'contractId': contractId,
    };
  }

  // Cria instância a partir de JSON
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] ?? '',
      reviewerId: json['reviewerId'] ?? '',
      reviewedUserId: json['reviewedUserId'] ?? '',
      type: ReviewType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ReviewType.serviceReview,
      ),
      rating: (json['rating'] ?? 0.0).toDouble(),
      comment: json['comment'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      categoryRatings: json['categoryRatings'] != null
          ? Map<String, double>.from(json['categoryRatings'])
          : null,
      isAnonymous: json['isAnonymous'] ?? false,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isVerified: json['isVerified'] ?? false,
      appointmentId: json['appointmentId'],
      contractId: json['contractId'],
    );
  }

  // Getters úteis
  String get typeDisplayName {
    switch (type) {
      case ReviewType.caregiverToPatient:
        return 'Avaliação do Cuidador';
      case ReviewType.patientToCaregiver:
        return 'Avaliação do Paciente';
      case ReviewType.serviceReview:
        return 'Avaliação do Serviço';
    }
  }

  String get ratingDisplay => '${rating.toStringAsFixed(1)} ⭐';

  bool get hasComment => comment != null && comment!.trim().isNotEmpty;

  bool get hasTags => tags.isNotEmpty;

  bool get hasCategoryRatings => categoryRatings != null && categoryRatings!.isNotEmpty;

  // Validações
  bool get isValid => rating >= 1.0 && rating <= 5.0;

  String? validate() {
    if (rating < 1.0 || rating > 5.0) {
      return 'Avaliação deve estar entre 1 e 5 estrelas';
    }
    if (comment != null && comment!.length > 1000) {
      return 'Comentário deve ter no máximo 1000 caracteres';
    }
    if (tags.length > 10) {
      return 'Máximo 10 tags permitidas';
    }
    return null;
  }

  @override
  String toString() {
    return 'Review(id: $id, rating: $rating, type: $typeDisplayName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Review && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// Modelo para estatísticas de avaliações de um usuário
class ReviewStats {
  final String userId;
  final double averageRating;
  final int totalReviews;
  final int fiveStars;
  final int fourStars;
  final int threeStars;
  final int twoStars;
  final int oneStars;
  final Map<String, double> categoryAverages;
  final List<String> topTags;

  ReviewStats({
    required this.userId,
    required this.averageRating,
    required this.totalReviews,
    required this.fiveStars,
    required this.fourStars,
    required this.threeStars,
    required this.twoStars,
    required this.oneStars,
    required this.categoryAverages,
    required this.topTags,
  });

  // Cria estatísticas a partir de lista de avaliações
  factory ReviewStats.fromReviews(String userId, List<Review> reviews) {
    if (reviews.isEmpty) {
      return ReviewStats(
        userId: userId,
        averageRating: 0.0,
        totalReviews: 0,
        fiveStars: 0,
        fourStars: 0,
        threeStars: 0,
        twoStars: 0,
        oneStars: 0,
        categoryAverages: {},
        topTags: [],
      );
    }

    // Contar estrelas
    int five = 0, four = 0, three = 0, two = 0, one = 0;
    double totalRating = 0.0;
    Map<String, Map<String, double>> categoryTotals = {};

    for (var review in reviews) {
      totalRating += review.rating;

      switch (review.rating.round()) {
        case 5:
          five++;
          break;
        case 4:
          four++;
          break;
        case 3:
          three++;
          break;
        case 2:
          two++;
          break;
        case 1:
          one++;
          break;
      }

      // Calcular médias por categoria
      if (review.categoryRatings != null) {
        review.categoryRatings!.forEach((category, rating) {
          categoryTotals[category] = categoryTotals[category] ?? {'sum': 0.0, 'count': 0};
          categoryTotals[category]!['sum'] = (categoryTotals[category]!['sum']! as double) + rating;
          categoryTotals[category]!['count'] = (categoryTotals[category]!['count']! as int) + 1;
        });
      }
    }

    // Calcular médias por categoria
    Map<String, double> categoryAverages = {};
    categoryTotals.forEach((category, data) {
      categoryAverages[category] = (data['sum']! as double) / (data['count']! as int);
    });

    // Contar tags mais usadas
    Map<String, int> tagCount = {};
    for (var review in reviews) {
      for (var tag in review.tags) {
        tagCount[tag] = (tagCount[tag] ?? 0) + 1;
      }
    }

    List<String> topTags = tagCount.entries
        .where((entry) => entry.value >= 2) // Pelo menos 2 usos
        .map((entry) => entry.key)
        .toList()
      ..sort((a, b) => tagCount[b]!.compareTo(tagCount[a]!));

    if (topTags.length > 10) {
      topTags = topTags.sublist(0, 10);
    }

    return ReviewStats(
      userId: userId,
      averageRating: totalRating / reviews.length,
      totalReviews: reviews.length,
      fiveStars: five,
      fourStars: four,
      threeStars: three,
      twoStars: two,
      oneStars: one,
      categoryAverages: categoryAverages,
      topTags: topTags,
    );
  }

  // Converte para Map para Firestore (atualização em lote)
  Map<String, dynamic> toFirestore() {
    return {
      'averageRating': averageRating,
      'totalReviews': totalReviews,
      'fiveStars': fiveStars,
      'fourStars': fourStars,
      'threeStars': threeStars,
      'twoStars': twoStars,
      'oneStars': oneStars,
      'categoryAverages': categoryAverages,
      'topTags': topTags,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  @override
  String toString() {
    return 'ReviewStats(userId: $userId, averageRating: $averageRating, totalReviews: $totalReviews)';
  }
}

// Modelo para resposta à avaliação
class ReviewResponse {
  final String id;
  final String reviewId;
  final String authorId;
  final String comment;
  final DateTime createdAt;
  final bool isOfficial; // Se é resposta oficial da plataforma

  ReviewResponse({
    required this.id,
    required this.reviewId,
    required this.authorId,
    required this.comment,
    required this.createdAt,
    this.isOfficial = false,
  });

  // Converte para Map para Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'reviewId': reviewId,
      'authorId': authorId,
      'comment': comment,
      'createdAt': Timestamp.fromDate(createdAt),
      'isOfficial': isOfficial,
    };
  }

  // Cria instância a partir de dados do Firestore
  factory ReviewResponse.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return ReviewResponse(
      id: doc.id,
      reviewId: data['reviewId'] ?? '',
      authorId: data['authorId'] ?? '',
      comment: data['comment'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isOfficial: data['isOfficial'] ?? false,
    );
  }
}
