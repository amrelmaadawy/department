import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extension.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/widgets/error_state_view.dart';
import '../../../../core/di/injection_container.dart';

class AiGalleryScreen extends StatelessWidget {
  const AiGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(
          'معرض الذكاء الاصطناعي',
          style: TextStyle(
            fontSize: AppFonts.headlineSmall,
            fontWeight: FontWeight.bold,
            color: context.colors.textPrimary,
          ),
        ),
        centerTitle: true,
        backgroundColor: context.colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(FluentIcons.ios_arrow_rtl_24_regular, color: context.colors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocProvider(
        create: (context) => sl<ProfileCubit>()..getProfile(),
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading || state is ProfileInitial) {
              return GridView.builder(
                padding: const EdgeInsets.all(AppSpacing.xl),
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: AppSpacing.lg,
                  mainAxisSpacing: AppSpacing.lg,
                  childAspectRatio: 0.8,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return Shimmer.fromColors(
                    baseColor: context.colors.border.withValues(alpha: 0.5),
                    highlightColor: context.colors.border.withValues(alpha: 0.1),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                      ),
                    ),
                  );
                },
              );
            }
            if (state is ProfileError) {
              return ErrorStateView(
                message: state.message,
                onRetry: () {
                  context.read<ProfileCubit>().getProfile();
                },
              );
            }
            if (state is ProfileLoaded) {
              final gallery = state.profile.aiGallery;
              if (gallery.isEmpty) {
                return _buildEmptyState(context);
              }
              return GridView.builder(
                padding: const EdgeInsets.all(AppSpacing.xl),
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: AppSpacing.lg,
                  mainAxisSpacing: AppSpacing.lg,
                  childAspectRatio: 0.8, // Slightly taller for portrait elegance
                ),
                itemCount: gallery.length,
                itemBuilder: (context, index) {
                  final item = gallery[index];
                  return _buildGalleryItem(context, item);
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xxxl),
            decoration: BoxDecoration(
              color: context.colors.primary.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              FluentIcons.sparkle_48_regular,
              size: 64,
              color: context.colors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'لا توجد تصميمات محفوظة',
            style: TextStyle(
              fontSize: AppFonts.headlineSmall,
              fontWeight: FontWeight.bold,
              color: context.colors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'قم بإنشاء تصميماتك المذهلة بالذكاء الاصطناعي\nواحفظها لتجدها هنا',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFonts.bodyLarge,
              color: context.colors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryItem(BuildContext context, dynamic item) {
    // Generate a unique hero tag
    final heroTag = 'ai_image_${item.url}_${item.hashCode}';
    final profileCubit = context.read<ProfileCubit>();
    final state = profileCubit.state;
    bool isFavorite = false;
    
    if (state is ProfileLoaded) {
      isFavorite = state.profile.savedDesigns.any((d) => d.id == item.orderId || (d.imageUrls.isNotEmpty && d.imageUrls.first == item.url));
    }

    return GestureDetector(
      onTap: () {
        _showAiGalleryDetails(context, item, heroTag);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 15,
              spreadRadius: -2,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Hero(
                tag: heroTag,
                child: Image.network(
                  item.url,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Shimmer.fromColors(
                      baseColor: context.colors.border.withValues(alpha: 0.3),
                      highlightColor: context.colors.border.withValues(alpha: 0.1),
                      child: Container(color: Colors.white),
                    );
                  },
                  errorBuilder: (context, _, __) => Container(
                    color: context.colors.border.withValues(alpha: 0.2),
                    child: Center(
                      child: Icon(FluentIcons.image_off_24_regular, color: context.colors.textSecondary),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.4),
                      ),
                      child: Text(
                        item.roomName.isNotEmpty ? item.roomName : 'غرفة بدون اسم',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: AppFonts.bodyMedium,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: AppSpacing.xs,
                right: AppSpacing.xs,
                child: IconButton(
                  icon: Icon(
                    isFavorite ? FluentIcons.heart_24_filled : FluentIcons.heart_24_regular,
                    color: isFavorite ? Colors.red : Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  onPressed: () {
                    profileCubit.toggleFavoriteDesign(item.orderId, item.url);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAiGalleryDetails(BuildContext context, dynamic item, String heroTag) {
    final profileCubit = context.read<ProfileCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.90, // Take up most of the screen
          decoration: BoxDecoration(
            color: context.colors.background,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.sm),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: context.colors.border,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                ),
              ),
              
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'تفاصيل التصميم',
                      style: TextStyle(
                        fontSize: AppFonts.headlineSmall,
                        fontWeight: FontWeight.bold,
                        color: context.colors.textPrimary,
                      ),
                    ),
                    Row(
                      children: [
                        BlocBuilder<ProfileCubit, ProfileState>(
                          builder: (context, state) {
                            bool isFavorite = false;
                            if (state is ProfileLoaded) {
                              isFavorite = state.profile.savedDesigns.any((d) => d.id == item.orderId || (d.imageUrls.isNotEmpty && d.imageUrls.first == item.url));
                            }
                            return IconButton(
                              icon: Icon(
                                isFavorite ? FluentIcons.heart_24_filled : FluentIcons.heart_24_regular,
                                color: isFavorite ? Colors.red : context.colors.textSecondary,
                              ),
                              onPressed: () {
                                profileCubit.toggleFavoriteDesign(item.orderId, item.url);
                              },
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(FluentIcons.dismiss_24_regular, color: context.colors.textSecondary),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Interactive Image Viewer
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                    child: InteractiveViewer(
                      minScale: 1.0,
                      maxScale: 5.0, // Allow deep zoom
                      child: Hero(
                        tag: heroTag,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: context.colors.border.withValues(alpha: 0.1),
                          ),
                          child: Image.network(
                            item.url,
                            fit: BoxFit.contain, // Keep aspect ratio intact while viewing
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return Shimmer.fromColors(
                                baseColor: context.colors.border.withValues(alpha: 0.3),
                                highlightColor: context.colors.border.withValues(alpha: 0.1),
                                child: Container(color: Colors.white),
                              );
                            },
                            errorBuilder: (context, _, __) => Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(FluentIcons.image_off_24_regular, size: 48, color: context.colors.textSecondary.withValues(alpha: 0.5)),
                                  const SizedBox(height: AppSpacing.sm),
                                  Text('الصورة غير متوفرة', style: TextStyle(color: context.colors.textSecondary)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Details Card
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: context.colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: context.colors.border.withValues(alpha: 0.2)),
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow(context, 'اسم الغرفة', item.roomName.isNotEmpty ? item.roomName : 'بدون اسم'),
                        const Divider(height: AppSpacing.xl),
                        if (item.projectName.isNotEmpty) ...[
                          _buildDetailRow(context, 'المشروع', item.projectName),
                          const Divider(height: AppSpacing.xl),
                        ],
                        if (item.unitName.isNotEmpty) ...[
                          _buildDetailRow(context, 'الوحدة', item.unitName),
                          const Divider(height: AppSpacing.xl),
                        ],
                        _buildDetailRow(context, 'رقم الطلب', '#${item.orderId}', isPrimary: true),
                        const Divider(height: AppSpacing.xl),
                        _buildDetailRow(context, 'تاريخ الإنشاء', item.createdAt != null ? '${item.createdAt!.day}/${item.createdAt!.month}/${item.createdAt!.year}' : 'غير متوفر'),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value, {bool isPrimary = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: AppFonts.bodyLarge,
            color: context.colors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isPrimary ? AppFonts.headlineSmall : AppFonts.bodyLarge,
            fontWeight: FontWeight.bold,
            color: isPrimary ? context.colors.primary : context.colors.textPrimary,
          ),
        ),
      ],
    );
  }
}
