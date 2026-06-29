import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apartment/core/network/app_cancel_token.dart';
import '../../domain/usecases/get_general_settings_usecase.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final GetGeneralSettingsUseCase getGeneralSettingsUseCase;
  final AppCancelToken _cancelToken = AppCancelToken();

  SettingsCubit({required this.getGeneralSettingsUseCase}) : super(SettingsInitial());

  Future<void> loadSettings() async {
    emit(SettingsLoading());

    final result = await getGeneralSettingsUseCase(cancelToken: _cancelToken);

    result.fold(
      (failure) => emit(SettingsError(message: failure.message)),
      (settings) => emit(SettingsLoaded(settings: settings)),
    );
  }

  @override
  Future<void> close() {
    _cancelToken.cancel('SettingsCubit closed');
    return super.close();
  }
}
