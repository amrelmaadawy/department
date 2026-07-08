import 'dart:async';
import 'package:apartment/features/projects/domain/entities/saved_design_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/toggle_favorite_design_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import '../../domain/usecases/update_profile_params.dart';
import '../../domain/entities/profile_entity.dart';
import 'profile_state.dart';
import '../../../../core/events/app_events.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final ToggleFavoriteDesignUseCase toggleFavoriteDesignUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  StreamSubscription? _contractSignedSubscription;
  StreamSubscription? _logoutSubscription;

  ProfileCubit({
    required this.getProfileUseCase,
    required this.toggleFavoriteDesignUseCase,
    required this.updateProfileUseCase,
  }) : super(ProfileInitial()) {
    _contractSignedSubscription = AppEvents.onContractSigned.listen((_) => getProfile());
    _logoutSubscription = AppEvents.onLogout.listen((_) => clearProfile());
  }

  @override
  void emit(ProfileState state) {
    if (isClosed) return;
    super.emit(state);
  }

  Future<void> getProfile() async {
    emit(ProfileLoading());
    final result = await getProfileUseCase();
    result.fold(
      (failure) => emit(ProfileError(message: failure.message)),
      (profile) => emit(ProfileLoaded(profile: profile)),
    );
  }

  void loadProfileIfNeeded() {
    if (state is ProfileInitial || state is ProfileError) getProfile();
  }

  Future<void> updateProfile(UpdateProfileParams params) async {
    final currentState = state;
    emit(ProfileUpdateLoading());
    final result = await updateProfileUseCase(params);
    result.fold(
      (failure) {
        emit(ProfileUpdateError(message: failure.message));
        if (currentState is ProfileLoaded) emit(currentState);
      },
      (profile) {
        emit(ProfileUpdateSuccess(profile: profile));
        emit(ProfileLoaded(profile: profile));
      },
    );
  }

  void clearProfile() => emit(ProfileInitial());

  @override
  Future<void> close() {
    _contractSignedSubscription?.cancel();
    _logoutSubscription?.cancel();
    return super.close();
  }

  Future<void> toggleFavoriteDesign(int orderId, String imageUrl) async {
    if (state is! ProfileLoaded) return;
    final currentProfile = (state as ProfileLoaded).profile;

    final isSaved = currentProfile.savedDesigns.any((d) =>
        d.id == orderId || d.finishingOrderId == orderId || (d.imageUrls.isNotEmpty && d.imageUrls.first == imageUrl));

    List<SavedDesignEntity> updatedDesigns;
    if (isSaved) {
      updatedDesigns = currentProfile.savedDesigns.where((d) =>
          !(d.id == orderId || d.finishingOrderId == orderId || (d.imageUrls.isNotEmpty && d.imageUrls.first == imageUrl))).toList();
    } else {
      final galleryItem = currentProfile.aiGallery.where((item) => item.orderId == orderId && item.url == imageUrl).firstOrNull;
      final newDesign = SavedDesignEntity(
        id: orderId,
        customerId: currentProfile.user.id,
        apartmentId: 0,
        name: galleryItem?.roomName.isNotEmpty == true ? galleryItem!.roomName : 'تصميم بدون اسم',
        style: '',
        totalCost: 0.0,
        imageUrls: [imageUrl],
        projectName: galleryItem?.projectName ?? '',
        unitName: galleryItem?.unitName ?? '',
        roomName: galleryItem?.roomName ?? '',
        createdAt: DateTime.now(),
        finishingOrderId: orderId,
      );
      updatedDesigns = List.from(currentProfile.savedDesigns)..insert(0, newDesign);
    }

    emit(ProfileLoaded(profile: ProfileEntity(
      user: currentProfile.user,
      statistics: currentProfile.statistics,
      apartments: currentProfile.apartments,
      recentOrders: currentProfile.recentOrders,
      savedDesigns: updatedDesigns,
      aiGallery: currentProfile.aiGallery,
    )));

    final result = await toggleFavoriteDesignUseCase(orderId, imageUrl);
    result.fold(
      (failure) {
        emit(ProfileError(message: failure.message));
        emit(ProfileLoaded(profile: currentProfile));
      },
      (_) => _refreshProfileSilently(),
    );
  }

  Future<void> _refreshProfileSilently() async {
    final result = await getProfileUseCase();
    result.fold(
      (_) => null,
      (profile) {
        if (state is ProfileLoaded) emit(ProfileLoaded(profile: profile));
      },
    );
  }
}
