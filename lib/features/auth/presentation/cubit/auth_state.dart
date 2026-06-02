part of 'auth_cubit.dart';

class AuthState extends Equatable {
  final bool isLoginTab;

  const AuthState({required this.isLoginTab});

  @override
  List<Object> get props => [isLoginTab];
}
