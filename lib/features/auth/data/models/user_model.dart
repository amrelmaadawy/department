import 'package:apartment/features/auth/domain/entities/user_entity.dart';


class UserModel extends UserEntity {
  const UserModel({
    super.id,
    required super.name,
    required super.email,
    required super.phone,
    super.token,
    super.aiCredits,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, {String? token}) {
    return UserModel(
      id: json['id']?.toString(),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      aiCredits: json['ai_credits'] as int?,
      token: token,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'ai_credits': aiCredits,
    };
  }
}
