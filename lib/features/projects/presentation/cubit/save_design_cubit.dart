import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/save_design_use_case.dart';
import '../../data/models/save_design_request_model.dart';
import 'save_design_state.dart';

class SaveDesignCubit extends Cubit<SaveDesignState> {
  final SaveDesignUseCase saveDesignUseCase;

  SaveDesignCubit({required this.saveDesignUseCase}) : super(SaveDesignInitial());

  Future<void> saveDesign(int finishingOrderId, String imageUrl) async {
    emit(SaveDesignLoading());

    final request = SaveDesignRequestModel(
      finishingOrderId: finishingOrderId,
      imageUrl: imageUrl,
    );

    final result = await saveDesignUseCase(request);

    result.fold(
      (failure) => emit(SaveDesignError(message: failure.message)),
      (savedDesign) => emit(SaveDesignSuccess(savedDesign: savedDesign)),
    );
  }
}
