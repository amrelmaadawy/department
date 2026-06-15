import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? address;
  final String? bio;
  final String? avatarUrl;
  final bool isActive;
  final int aiCredits;
  final DateTime? memberSince;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.address,
    this.bio,
    this.avatarUrl,
    required this.isActive,
    required this.aiCredits,
    this.memberSince,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        address,
        bio,
        avatarUrl,
        isActive,
        aiCredits,
        memberSince,
      ];
}
