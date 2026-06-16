import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../home/domain/usecases/share_design_usecase.dart';

// States
abstract class ShareDesignState extends Equatable {
  const ShareDesignState();

  @override
  List<Object?> get props => [];
}

class ShareDesignInitial extends ShareDesignState {}

class ShareDesignLoading extends ShareDesignState {}

class ShareDesignSuccess extends ShareDesignState {}

class ShareDesignError extends ShareDesignState {
  final String message;

  const ShareDesignError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Cubit
class ShareDesignCubit extends Cubit<ShareDesignState> {
  final ShareDesignUseCase shareDesignUseCase;

  ShareDesignCubit({required this.shareDesignUseCase}) : super(ShareDesignInitial());

  Future<void> shareDesign({required String imagePath, required String text}) async {
    emit(ShareDesignLoading());
    
    final result = await shareDesignUseCase(imagePath, text);
    
    result.fold(
      (failure) => emit(ShareDesignError(message: failure.message)),
      (_) => emit(ShareDesignSuccess()),
    );
  }
}
