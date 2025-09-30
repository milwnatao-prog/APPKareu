import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

enum UserType {
  needCaregiver,  // Paciente ou família que precisa de cuidador
  amCaregiver,    // Profissional de saúde
}

enum SubscriptionTier {
  free,     // Perfil limitado - apenas visualização
  basic,    // R$ 29,90 - Perfil ativo + 5 agendamentos/mês
  plus,     // R$ 49,90 - Ilimitado + destaque na busca
  premium,  // R$ 79,90 - Tudo + posição top + badge premium
}

class UserModel {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String? bio;
  final String? profileImageUrl;
  final UserType userType;
  final SubscriptionTier subscriptionTier;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? lastLoginAt;
  final bool isEmailVerified;
  final bool isProfileComplete;

  // Campos específicos para cuidadores
  final String? specialty;
  final String? experience;
  final double? hourlyRate;
  final double? rating;
  final int? totalReviews;
  final List<String>? certifications;
  final Map<String, bool>? availability;

  // Campos específicos para pacientes/famílias
  final String? address;
  final String? city;
  final String? state;
  final double? latitude;
  final double? longitude;
  final List<String>? careNeeds;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this.bio,
    this.profileImageUrl,
    required this.userType,
    this.subscriptionTier = SubscriptionTier.free,
    required this.createdAt,
    this.updatedAt,
    this.lastLoginAt,
    this.isEmailVerified = false,
    this.isProfileComplete = false,
    // Campos para cuidadores
    this.specialty,
    this.experience,
    this.hourlyRate,
    this.rating,
    this.totalReviews,
    this.certifications,
    this.availability,
    // Campos para pacientes
    this.address,
    this.city,
    this.state,
    this.latitude,
    this.longitude,
    this.careNeeds,
  });

  // Criar cópia com campos modificados
  UserModel copyWith({
    String? name,
    String? phone,
    String? bio,
    String? profileImageUrl,
    SubscriptionTier? subscriptionTier,
    DateTime? updatedAt,
    bool? isProfileComplete,
    // Campos para cuidadores
    String? specialty,
    String? experience,
    double? hourlyRate,
    double? rating,
    int? totalReviews,
    List<String>? certifications,
    Map<String, bool>? availability,
    // Campos para pacientes
    String? address,
    String? city,
    String? state,
    double? latitude,
    double? longitude,
    List<String>? careNeeds,
  }) {
    return UserModel(
      id: id,
      email: email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      userType: userType,
      subscriptionTier: subscriptionTier ?? this.subscriptionTier,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLoginAt: lastLoginAt,
      isEmailVerified: isEmailVerified,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
      specialty: specialty ?? this.specialty,
      experience: experience ?? this.experience,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      certifications: certifications ?? this.certifications,
      availability: availability ?? this.availability,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      careNeeds: careNeeds ?? this.careNeeds,
    );
  }

  // Converte para Map para Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
      'userType': userType.name,
      'subscriptionTier': subscriptionTier.name,
      'createdAt': firestore.Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? firestore.Timestamp.fromDate(updatedAt!) : null,
      'lastLoginAt': lastLoginAt != null ? firestore.Timestamp.fromDate(lastLoginAt!) : null,
      'isEmailVerified': isEmailVerified,
      'isProfileComplete': isProfileComplete,
      // Campos para cuidadores
      'specialty': specialty,
      'experience': experience,
      'hourlyRate': hourlyRate,
      'rating': rating,
      'totalReviews': totalReviews,
      'certifications': certifications,
      'availability': availability,
      // Campos para pacientes
      'address': address,
      'city': city,
      'state': state,
      'latitude': latitude,
      'longitude': longitude,
      'careNeeds': careNeeds,
    };
  }

  // Cria instância a partir de dados do Firestore
  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    return UserModel(
      id: data['id'] ?? '',
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      phone: data['phone'],
      bio: data['bio'],
      profileImageUrl: data['profileImageUrl'],
      userType: UserType.values.firstWhere(
        (e) => e.name == data['userType'],
        orElse: () => UserType.needCaregiver,
      ),
      subscriptionTier: SubscriptionTier.values.firstWhere(
        (e) => e.name == data['subscriptionTier'],
        orElse: () => SubscriptionTier.free,
      ),
      createdAt: (data['createdAt'] as firestore.Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as firestore.Timestamp?)?.toDate(),
      lastLoginAt: (data['lastLoginAt'] as firestore.Timestamp?)?.toDate(),
      isEmailVerified: data['isEmailVerified'] ?? false,
      isProfileComplete: data['isProfileComplete'] ?? false,
      // Campos para cuidadores
      specialty: data['specialty'],
      experience: data['experience'],
      hourlyRate: data['hourlyRate']?.toDouble(),
      rating: data['rating']?.toDouble(),
      totalReviews: data['totalReviews']?.toInt(),
      certifications: data['certifications'] != null ? List<String>.from(data['certifications']) : null,
      availability: data['availability'] != null ? Map<String, bool>.from(data['availability']) : null,
      // Campos para pacientes
      address: data['address'],
      city: data['city'],
      state: data['state'],
      latitude: data['latitude']?.toDouble(),
      longitude: data['longitude']?.toDouble(),
      careNeeds: data['careNeeds'] != null ? List<String>.from(data['careNeeds']) : null,
    );
  }

  // Converte para JSON (para outras operações)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
      'userType': userType.name,
      'subscriptionTier': subscriptionTier.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'isEmailVerified': isEmailVerified,
      'isProfileComplete': isProfileComplete,
      'specialty': specialty,
      'experience': experience,
      'hourlyRate': hourlyRate,
      'rating': rating,
      'totalReviews': totalReviews,
      'certifications': certifications,
      'availability': availability,
      'address': address,
      'city': city,
      'state': state,
      'latitude': latitude,
      'longitude': longitude,
      'careNeeds': careNeeds,
    };
  }

  // Cria instância a partir de JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'],
      bio: json['bio'],
      profileImageUrl: json['profileImageUrl'],
      userType: UserType.values.firstWhere(
        (e) => e.name == json['userType'],
        orElse: () => UserType.needCaregiver,
      ),
      subscriptionTier: SubscriptionTier.values.firstWhere(
        (e) => e.name == json['subscriptionTier'],
        orElse: () => SubscriptionTier.free,
      ),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      lastLoginAt: json['lastLoginAt'] != null ? DateTime.parse(json['lastLoginAt']) : null,
      isEmailVerified: json['isEmailVerified'] ?? false,
      isProfileComplete: json['isProfileComplete'] ?? false,
      specialty: json['specialty'],
      experience: json['experience'],
      hourlyRate: json['hourlyRate']?.toDouble(),
      rating: json['rating']?.toDouble(),
      totalReviews: json['totalReviews']?.toInt(),
      certifications: json['certifications'] != null ? List<String>.from(json['certifications']) : null,
      availability: json['availability'] != null ? Map<String, bool>.from(json['availability']) : null,
      address: json['address'],
      city: json['city'],
      state: json['state'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      careNeeds: json['careNeeds'] != null ? List<String>.from(json['careNeeds']) : null,
    );
  }

  // Getters úteis
  String get displayName => name.isNotEmpty ? name : email.split('@')[0];
  String get userTypeDisplayName {
    switch (userType) {
      case UserType.needCaregiver:
        return 'Paciente/Família';
      case UserType.amCaregiver:
        return 'Cuidador';
    }
  }

  String get subscriptionDisplayName {
    switch (subscriptionTier) {
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

  double get subscriptionPrice {
    switch (subscriptionTier) {
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

  bool get isCaregiver => userType == UserType.amCaregiver;
  bool get isPatient => userType == UserType.needCaregiver;

  bool get canAcceptBookings {
    if (!isCaregiver) return false;
    return subscriptionTier != SubscriptionTier.free;
  }

  int get monthlyBookingLimit {
    switch (subscriptionTier) {
      case SubscriptionTier.free:
        return 0; // Perfil apenas para visualização
      case SubscriptionTier.basic:
        return 5;
      case SubscriptionTier.plus:
      case SubscriptionTier.premium:
        return -1; // Ilimitado
    }
  }

  bool get hasSearchPriority => subscriptionTier == SubscriptionTier.plus || subscriptionTier == SubscriptionTier.premium;
  bool get hasTopSearchPosition => subscriptionTier == SubscriptionTier.premium;
  bool get hasPremiumBadge => subscriptionTier == SubscriptionTier.premium;
  bool get hasVerifiedBadge => subscriptionTier != SubscriptionTier.free;
  bool get canAccessPremiumFeatures => subscriptionTier == SubscriptionTier.plus || subscriptionTier == SubscriptionTier.premium;

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, name: $name, userType: $userTypeDisplayName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
