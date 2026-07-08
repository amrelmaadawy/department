import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_ai_renders_use_case.dart';
import 'ai_renders_state.dart';

class AiRendersCubit extends Cubit<AiRendersState> {
  final GetAiRendersUseCase getAiRendersUseCase;
  Timer? _pollingTimer;

  AiRendersCubit({
    required this.getAiRendersUseCase,
  }) : super(AiRendersInitial());

  Future<void> fetchAiRenders(int orderId) async {
    emit(AiRendersLoading());
    await _fetchData(orderId);
  }

  Future<void> _fetchData(int orderId) async {
    final result = await getAiRendersUseCase(orderId);

    result.fold(
      (failure) {
        _stopPolling();
        emit(AiRendersError(message: failure.message));
      },
      (aiRenders) {
        if (aiRenders.aiStatus == 'completed') {
          _stopPolling();
          emit(AiRendersCompleted(aiRenders: aiRenders));
        } else if (aiRenders.aiStatus == 'failed') {
          _stopPolling();
          emit(AiRendersError(message: aiRenders.aiStatusLabel));
        } else {
          emit(AiRendersPending(aiRenders: aiRenders));
          _startPolling(orderId);
        }
      },
    );
  }

  void _startPolling(int orderId) {
    if (_pollingTimer != null && _pollingTimer!.isActive) return;
    
    _pollingTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      _fetchData(orderId);
    });
  }

  void _stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  @override
  Future<void> close() {
    _stopPolling();
    return super.close();
  }
}
