import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/services/login_rate_limiter.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final RegisterUseCase registerUseCase;
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final LoginRateLimiter rateLimiter;

  AuthCubit({
    required this.registerUseCase,
    required this.loginUseCase,
    required this.logoutUseCase,
    LoginRateLimiter? rateLimiter,
  })  : rateLimiter = rateLimiter ?? LoginRateLimiter(),
        super(const AuthState());

  void toggleTab(bool isLogin) {
    emit(state.copyWith(
      isLoginTab: isLogin, 
      status: AuthStatus.initial, 
      clearMessages: true,
    ));
  }

  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await registerUseCase(
      RegisterParams(
        name: name,
        email: email,
        phone: phone,
        password: password,
        passwordConfirmation: passwordConfirmation,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: failure.message,
      )),
      (user) => emit(state.copyWith(
        status: AuthStatus.success,
        successMessage: 'تم إنشاء الحساب بنجاح، يرجى الانتظار حتى يتم تفعيل حسابك من قبل الإدارة',
      )),
    );
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    final attemptResult = rateLimiter.canAttempt();
    if (!attemptResult.isAllowed) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: attemptResult.lockMessage,
      ));
      return;
    }

    emit(state.copyWith(status: AuthStatus.loading));

    final result = await loginUseCase(
      LoginParams(
        email: email,
        password: password,
      ),
    );

    result.fold(
      (failure) {
        rateLimiter.recordFailure();
        final remaining = rateLimiter.remainingAttempts;
        emit(state.copyWith(
          status: AuthStatus.failure,
          errorMessage: '${failure.message} (تبقى $remaining محاولات)',
        ));
      },
      (user) {
        rateLimiter.recordSuccess();
        emit(state.copyWith(
          status: AuthStatus.success,
          clearMessages: true,
        ));
      },
    );
  }

  Future<void> logout() async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await logoutUseCase();

    result.fold(
      (failure) => emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(
        status: AuthStatus.success,
        clearMessages: true,
      )),
    );
  }
}
