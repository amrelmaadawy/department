import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/core/widgets/error_state_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../cubit/profile_cubit.dart';
import '../../cubit/profile_state.dart';
import 'package:apartment/core/utils/responsive_builder.dart';

import 'ai_gallery_grid.dart';
import 'ai_gallery_empty_state.dart';

class AiGalleryTabView extends StatelessWidget {
  const AiGalleryTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading || state is ProfileInitial) {
          return GridView.builder(
            padding: const EdgeInsets.all(AppSpacing.xl),
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: context.responsiveCrossAxisCount,
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
            return const AiGalleryEmptyState();
          }
          return AiGalleryGrid(gallery: gallery);
        }
        return const SizedBox.shrink();
      },
    );
  }
}
