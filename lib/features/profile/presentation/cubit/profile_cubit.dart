import 'package:apartment/features/projects/domain/entities/saved_design_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/toggle_favorite_design_usecase.dart';
import '../../domain/entities/profile_entity.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final ToggleFavoriteDesignUseCase toggleFavoriteDesignUseCase;

  ProfileCubit({
    required this.getProfileUseCase,
    required this.toggleFavoriteDesignUseCase,
  }) : super(ProfileInitial());

  Future<void> getProfile() async {
    emit(ProfileLoading());

    final result = await getProfileUseCase();

    result.fold(
      (failure) => emit(ProfileError(message: failure.message)),
      (profile) => emit(ProfileLoaded(profile: profile)),
    );
  }
  void clearProfile() {
    emit(ProfileInitial());
  }

  Future<void> toggleFavoriteDesign(int orderId, String imageUrl) async {
    if (state is! ProfileLoaded) return;
    
    final currentState = state as ProfileLoaded;
    final currentProfile = currentState.profile;
    
    // Check if it's currently saved
    final isCurrentlySaved = currentProfile.savedDesigns.any(
      (d) => d.id == orderId || d.finishingOrderId == orderId || (d.imageUrls.isNotEmpty && d.imageUrls.first == imageUrl)
    );
    
    List<SavedDesignEntity> updatedSavedDesigns;
    
    if (isCurrentlySaved) {
      // Optimistic Remove
      updatedSavedDesigns = currentProfile.savedDesigns.where(
        (d) => !(d.id == orderId || d.finishingOrderId == orderId || (d.imageUrls.isNotEmpty && d.imageUrls.first == imageUrl))
      ).toList();
    } else {
      // Optimistic Add
      final galleryItem = currentProfile.aiGallery.where((item) => item.orderId == orderId && item.url == imageUrl).firstOrNull;
      
      final newSavedDesign = SavedDesignEntity(
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
      
      updatedSavedDesigns = List.from(currentProfile.savedDesigns)..insert(0, newSavedDesign);
    }
    
    final updatedProfile = ProfileEntity(
      user: currentProfile.user,
      statistics: currentProfile.statistics,
      apartments: currentProfile.apartments,
      recentOrders: currentProfile.recentOrders,
      savedDesigns: updatedSavedDesigns,
      aiGallery: currentProfile.aiGallery,
    );
    
    emit(ProfileLoaded(profile: updatedProfile));
    
    // Call the API
    final result = await toggleFavoriteDesignUseCase(orderId, imageUrl);
    
    result.fold(
      (failure) {
        if (!isClosed) {
          // Rollback on failure
          emit(ProfileError(message: failure.message));
          emit(ProfileLoaded(profile: currentProfile));
        }
      },
      (isSaved) {
        if (!isClosed) {
          // API succeeded. Refresh the profile silently to ensure we have the correct backend IDs for the new items.
          // We do this without emitting ProfileLoading to keep the UX smooth.
          _refreshProfileSilently();
        }
      },
    );
  }

  Future<void> _refreshProfileSilently() async {
    final result = await getProfileUseCase();
    result.fold(
      (failure) => null, // Ignore silent failure
      (profile) {
        if (!isClosed && state is ProfileLoaded) {
          emit(ProfileLoaded(profile: profile));
        }
      },
    );
  }
}
