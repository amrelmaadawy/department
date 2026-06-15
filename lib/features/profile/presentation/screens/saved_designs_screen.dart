import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extension.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/widgets/error_state_view.dart';

import '../../../../core/di/injection_container.dart';

class SavedDesignsScreen extends StatelessWidget {
  const SavedDesignsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('التصميمات المحفوظة'),
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
            final designs = state.profile.savedDesigns;
            if (designs.isEmpty) {
              return Center(
                child: Text(
                  'لا توجد تصميمات محفوظة',
                  style: TextStyle(
                    fontSize: AppFonts.bodyLarge,
                    color: context.colors.textSecondary,
                  ),
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.xl),
              itemCount: designs.length,
              separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final design = designs[index];
                return Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: context.colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                    border: Border.all(
                      color: context.colors.border.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: context.colors.background,
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                        ),
                        child: design.imageUrls.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(AppRadius.lg),
                                child: Image.network(
                                  design.imageUrls.first,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, _, __) => const Icon(FluentIcons.image_off_24_regular),
                                ),
                              )
                            : const Icon(FluentIcons.image_24_regular),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              design.name.isNotEmpty ? design.name : 'تصميم بدون اسم',
                              style: TextStyle(
                                fontSize: AppFonts.bodyLarge,
                                fontWeight: FontWeight.bold,
                                color: context.colors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              'النمط: ${design.style.isNotEmpty ? design.style : "غير محدد"}',
                              style: TextStyle(
                                fontSize: AppFonts.bodyMedium,
                                color: context.colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
