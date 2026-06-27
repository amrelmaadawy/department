import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../contracts/domain/usecases/get_contracts_usecase.dart';
import 'my_contracts_state.dart';

class MyContractsCubit extends Cubit<MyContractsState> {
  final GetContractsUseCase getContractsUseCase;

  MyContractsCubit({required this.getContractsUseCase}) : super(MyContractsInitial());

  Future<void> fetchContracts() async {
    emit(MyContractsLoading());

    final result = await getContractsUseCase();

    if (isClosed) return;

    result.fold(
      (failure) => emit(MyContractsError(failure.message)),
      (contracts) => emit(MyContractsLoaded(contracts)),
    );
  }
}
