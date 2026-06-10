import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/widgets/custom_button.dart';
import 'package:apartment/features/home/domain/entities/project_service_entity.dart';
import 'package:flutter/material.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:apartment/core/theme/theme_extension.dart';


class ProjectServiceCard extends StatelessWidget {
  final ProjectServiceEntity service;
  final int index;

  const ProjectServiceCard({
    super.key,
    required this.service,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + (index * 150)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: AppSpacing.lg),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: context.colors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: context.colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              // Future navigation or interaction
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image and Icon Badge
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Image
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(AppRadius.lg),
                        topRight: Radius.circular(AppRadius.lg),
                      ),
                      child: Image.asset(
                        service.imagePath,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),

                    // Icon Badge (overlapping bottom-left in LTR, bottom-right in RTL)
                    // We use Positioned to place it carefully. Since the app is RTL,
                    // right: 16 will place it on the right side.
                    Positioned(
                      bottom: -20,
                      right: AppSpacing.md, // Right side in RTL
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: context.colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: context.colors.border),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            service.icon,
                            size: 20,
                            color: context.colors.gold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Content
                Padding(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: AppSpacing.sm,
                      ), // Space for the overlapping badge
                      Text(
                        service.title,
                        style: TextStyle(
                          fontSize: AppFonts.headlineSmall,
                          fontWeight: FontWeight.bold,
                          color: context.colors.primary,
                        ),
                      ),
                      SizedBox(height: AppSpacing.sm),
                      Text(
                        service.description,
                        style: TextStyle(
                          fontSize: AppFonts.bodyMedium,
                          color: context.colors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: AppSpacing.lg),

                      // Action Button
                      CustomButton(
                        text: l10n.details,
                        onPressed: () {
                          // Empty action for now as requested
                        },
                        backgroundColor: context.colors.gold,
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
