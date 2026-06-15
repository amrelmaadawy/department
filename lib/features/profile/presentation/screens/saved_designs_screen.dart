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
                return GestureDetector(
                  onTap: () {
                    _showSavedDesignDetails(context, design);
                  },
                  child: Container(
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
                              if (design.projectName.isNotEmpty)
                                Text(
                                  '${design.projectName} - ${design.unitName.isNotEmpty ? design.unitName : "غير محدد"}',
                                  style: TextStyle(
                                    fontSize: AppFonts.labelMedium,
                                    color: context.colors.textSecondary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
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

  void _showSavedDesignDetails(BuildContext context, dynamic design) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
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
                  margin: const EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.lg),
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
                      'تفاصيل التصميم المحفوظ',
                      style: TextStyle(
                        fontSize: AppFonts.headlineSmall,
                        fontWeight: FontWeight.bold,
                        color: context.colors.textPrimary,
                      ),
                    ),
                    IconButton(
                      icon: Icon(FluentIcons.dismiss_24_regular, color: context.colors.textSecondary),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image Viewer
                      Container(
                        height: 300,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppRadius.xl),
                          color: context.colors.border.withValues(alpha: 0.1),
                          image: design.imageUrls.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(design.imageUrls.first),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: design.imageUrls.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(FluentIcons.image_24_regular, size: 48, color: context.colors.textSecondary.withValues(alpha: 0.5)),
                                    const SizedBox(height: AppSpacing.sm),
                                    Text('الصورة غير متوفرة', style: TextStyle(color: context.colors.textSecondary)),
                                  ],
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(height: AppSpacing.xxl),

                      // Details Card
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: context.colors.white,
                          borderRadius: BorderRadius.circular(AppRadius.xl),
                          border: Border.all(color: context.colors.border.withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          children: [
                            _buildDetailRow(context, 'اسم التصميم', design.name.isNotEmpty ? design.name : 'بدون اسم'),
                            const Divider(height: AppSpacing.xl),
                            if (design.projectName.isNotEmpty) ...[
                              _buildDetailRow(context, 'المشروع', design.projectName),
                              const Divider(height: AppSpacing.xl),
                            ],
                            if (design.unitName.isNotEmpty) ...[
                              _buildDetailRow(context, 'الوحدة', design.unitName),
                              const Divider(height: AppSpacing.xl),
                            ],
                            if (design.roomName.isNotEmpty) ...[
                              _buildDetailRow(context, 'الغرفة', design.roomName),
                              const Divider(height: AppSpacing.xl),
                            ],
                            _buildDetailRow(context, 'النمط', design.style.isNotEmpty ? design.style : 'غير محدد'),
                            const Divider(height: AppSpacing.xl),
                            _buildDetailRow(context, 'رقم الشقة', design.apartmentId.toString()),
                            const Divider(height: AppSpacing.xl),
                            if (design.createdAt != null) ...[
                              _buildDetailRow(context, 'تاريخ التصميم', '${design.createdAt!.day}/${design.createdAt!.month}/${design.createdAt!.year}'),
                              const Divider(height: AppSpacing.xl),
                            ],
                            _buildDetailRow(context, 'التكلفة', '${design.totalCost.toStringAsFixed(0)} ج.م', isPrimary: true),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxxl),
                    ],
                  ),
                ),
              ),
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
            fontSize: AppFonts.bodyMedium,
            color: context.colors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isPrimary ? AppFonts.bodyLarge : AppFonts.bodyMedium,
            fontWeight: FontWeight.bold,
            color: isPrimary ? context.colors.primary : context.colors.textPrimary,
          ),
        ),
      ],
    );
  }
}
