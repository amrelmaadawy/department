import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? id;
  final String name;
  final String email;
  final String phone;
  final String? token;
  final int? aiCredits;

  const UserEntity({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.token,
    this.aiCredits,
  });

  @override
  List<Object?> get props => [id, name, email, phone, token, aiCredits];
}
