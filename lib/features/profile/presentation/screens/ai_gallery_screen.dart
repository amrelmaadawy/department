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
                return GestureDetector(
                  onTap: () {
                    _showAiGalleryDetails(context, item);
                  },
                  child: Container(
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

  void _showAiGalleryDetails(BuildContext context, dynamic item) {
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
                      'تفاصيل التصميم',
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
                          image: item.url.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(item.url),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: item.url.isEmpty
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
