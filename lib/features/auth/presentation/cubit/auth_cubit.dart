import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState(isLoginTab: true));

  void toggleTab(bool isLogin) {
    emit(AuthState(isLoginTab: isLogin));
  }
}
