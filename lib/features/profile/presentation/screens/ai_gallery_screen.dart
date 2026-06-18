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
import 'package:apartment/core/utils/responsive_builder.dart';
import 'package:apartment/l10n/app_localizations.dart';

import '../widgets/ai_gallery/ai_gallery_grid.dart';
import '../widgets/ai_gallery/ai_gallery_empty_state.dart';

class AiGalleryScreen extends StatefulWidget {
  const AiGalleryScreen({super.key});

  @override
  State<AiGalleryScreen> createState() => _AiGalleryScreenState();
}

class _AiGalleryScreenState extends State<AiGalleryScreen> {
  @override
  void initState() {
    super.initState();
    sl<ProfileCubit>().loadProfileIfNeeded();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(
          l10n.aiGalleryTitle,
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
      body: BlocBuilder<ProfileCubit, ProfileState>(
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
      ),
    );
  }
}
