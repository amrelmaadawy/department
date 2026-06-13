part of 'auth_cubit.dart';

enum AuthStatus { initial, loading, success, failure }

class AuthState extends Equatable {
  final bool isLoginTab;
  final AuthStatus status;
  final String? errorMessage;

  const AuthState({
    this.isLoginTab = true,
    this.status = AuthStatus.initial,
    this.errorMessage,
  });

  AuthState copyWith({
    bool? isLoginTab,
    AuthStatus? status,
    String? errorMessage,
  }) {
    return AuthState(
      isLoginTab: isLoginTab ?? this.isLoginTab,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoginTab, status, errorMessage];
}
