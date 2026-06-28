import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apartment/features/packages/domain/usecases/get_packages_usecase.dart';
import 'packages_state.dart';

class PackagesCubit extends Cubit<PackagesState> {
  final GetPackagesUseCase getPackagesUseCase;

  PackagesCubit({required this.getPackagesUseCase}) : super(PackagesInitial());

  Future<void> loadPackages() async {
    emit(PackagesLoading());
    final result = await getPackagesUseCase();
    result.fold(
      (failure) => emit(PackagesError(failure.message)),
      (packages) => emit(PackagesLoaded(packages)),
    );
  }
}
