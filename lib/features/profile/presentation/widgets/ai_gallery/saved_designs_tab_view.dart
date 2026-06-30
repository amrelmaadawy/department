import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:shimmer/shimmer.dart';
import 'package:apartment/core/theme/app_colors.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/core/widgets/app_toast.dart';
import 'package:apartment/core/widgets/error_state_view.dart';

import '../../cubit/profile_cubit.dart';
import '../../cubit/profile_state.dart';
import '../saved_design_card.dart';

class SavedDesignsTabView extends StatelessWidget {
  const SavedDesignsTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError) {
          AppToast.show(context, message: state.message, isError: true);
        }
      },
      builder: (context, profileState) {
        if (profileState is ProfileLoading || profileState is ProfileInitial) {
          return _buildLoadingState(context);
        }
        if (profileState is ProfileError) {
          return ErrorStateView(
            message: profileState.message,
            onRetry: () => context.read<ProfileCubit>().getProfile(),
          );
        }
        if (profileState is ProfileLoaded) {
          final designs = profileState.profile.savedDesigns;
          if (designs.isEmpty) {
            return _buildEmptyState(context);
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.xl),
            physics: const BouncingScrollPhysics(),
            itemCount: designs.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              return SavedDesignCard(
                design: designs[index],
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(FluentIcons.heart_48_regular, size: 64, color: context.colors.primary),
          const SizedBox(height: AppSpacing.md),
          Text(
            'لا توجد تصميمات مفضلة',
            style: TextStyle(
              fontSize: AppFonts.headlineSmall,
              fontWeight: FontWeight.bold,
              color: context.colors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'لم تقم بإضافة أي تصميم للمفضلة بعد',
            style: TextStyle(
              fontSize: AppFonts.bodyMedium,
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.xl),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: context.colors.border.withValues(alpha: 0.5),
          highlightColor: context.colors.border.withValues(alpha: 0.1),
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
          ),
        );
      },
    );
  }
}
