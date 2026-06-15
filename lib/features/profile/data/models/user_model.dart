import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.phone,
    super.address,
    super.bio,
    super.avatarUrl,
    required super.isActive,
    required super.aiCredits,
    super.memberSince,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      address: json['address'],
      bio: json['bio'],
      avatarUrl: json['avatar_url'],
      isActive: json['is_active'] == true || json['is_active'] == 1,
      aiCredits: json['ai_credits'] is int ? json['ai_credits'] : int.tryParse(json['ai_credits']?.toString() ?? '0') ?? 0,
      memberSince: json['member_since'] != null ? DateTime.tryParse(json['member_since']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'bio': bio,
      'avatar_url': avatarUrl,
      'is_active': isActive,
      'ai_credits': aiCredits,
      'member_since': memberSince?.toIso8601String(),
    };
  }
}
