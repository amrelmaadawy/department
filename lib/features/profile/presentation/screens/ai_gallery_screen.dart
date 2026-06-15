import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
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
      appBar: AppBar(
        title: const Text('معرض الذكاء الاصطناعي'),
        leading: IconButton(
          icon: const Icon(FluentIcons.ios_arrow_rtl_24_regular),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocProvider(
        create: (context) => sl<ProfileCubit>()..getProfile(),
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
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
              return Center(
                child: Text(
                  'لا توجد صور في المعرض',
                  style: TextStyle(
                    fontSize: AppFonts.bodyLarge,
                    color: context.colors.textSecondary,
                  ),
                ),
              );
            }
            return GridView.builder(
              padding: const EdgeInsets.all(AppSpacing.xl),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.md,
                childAspectRatio: 0.8,
              ),
              itemCount: gallery.length,
              itemBuilder: (context, index) {
                final item = gallery[index];
                return Container(
                  decoration: BoxDecoration(
                    color: context.colors.background,
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                    border: Border.all(
                      color: context.colors.border.withValues(alpha: 0.2),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          item.url,
                          fit: BoxFit.cover,
                          errorBuilder: (context, _, __) => const Center(
                            child: Icon(FluentIcons.image_off_24_regular),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withValues(alpha: 0.8),
                                  Colors.transparent,
                                ],
                              ),
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
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
      ),
    );
  }
}
