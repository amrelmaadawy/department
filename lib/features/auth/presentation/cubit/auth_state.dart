part of 'auth_cubit.dart';

enum AuthStatus { initial, loading, success, failure }

class AuthState extends Equatable {
  final bool isLoginTab;
  final AuthStatus status;
  final String? errorMessage;
  final String? successMessage;

  const AuthState({
    this.isLoginTab = true,
    this.status = AuthStatus.initial,
    this.errorMessage,
    this.successMessage,
  });

  AuthState copyWith({
    bool? isLoginTab,
    AuthStatus? status,
    String? errorMessage,
    String? successMessage,
    bool clearMessages = false,
  }) {
    return AuthState(
      isLoginTab: isLoginTab ?? this.isLoginTab,
      status: status ?? this.status,
      errorMessage: clearMessages ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearMessages ? null : (successMessage ?? this.successMessage),
    );
  }

  @override
  List<Object?> get props => [isLoginTab, status, errorMessage, successMessage];
}
