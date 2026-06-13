import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? id;
  final String name;
  final String email;
  final String phone;
  final String? token;

  const UserEntity({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.token,
  });

  @override
  List<Object?> get props => [id, name, email, phone, token];
}
