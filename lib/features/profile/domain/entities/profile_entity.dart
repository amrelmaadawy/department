import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final int isActive;
  final String? avatarUrl;

  const ProfileEntity({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.isActive,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [id, name, email, phone, isActive, avatarUrl];
}
