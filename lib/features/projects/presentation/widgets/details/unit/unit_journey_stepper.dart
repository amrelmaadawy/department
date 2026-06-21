import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/theme_extension.dart';
import 'package:apartment/l10n/app_localizations.dart';

class UnitJourneyStepper extends StatelessWidget {
  final int currentStep; // 0 to 3

  const UnitJourneyStepper({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final steps = [
      l10n.stepStyle,
      l10n.stepMaterials,
      l10n.stepDesign,
      l10n.stepApproval,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(steps.length * 2 - 1, (index) {
          if (index.isOdd) {
            // Connector line
            final stepIndex = index ~/ 2;
            final isCompleted = currentStep > stepIndex;
            return Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 14), // Align with the center of the circle (which is 28/2 = 14)
                height: 2,
                color: isCompleted ? context.colors.primary : context.colors.border,
              ),
            );
          } else {
            // Step node
            final stepIndex = index ~/ 2;
            final isActive = currentStep == stepIndex;
            final isCompleted = currentStep > stepIndex;
            
            return _buildStepNode(
              context,
              title: steps[stepIndex],
              isActive: isActive,
              isCompleted: isCompleted,
            );
          }
        }),
      ),
    );
  }

  Widget _buildStepNode(
    BuildContext context, {
    required String title,
    required bool isActive,
    required bool isCompleted,
  }) {
    final isDoneOrActive = isCompleted || isActive;
    return SizedBox(
      width: 70, // Fixed width for centering text below the node
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDoneOrActive ? context.colors.primary : context.colors.background,
              border: Border.all(
                color: isDoneOrActive ? context.colors.primary : context.colors.border,
                width: 2,
              ),
            ),
            child: Icon(
              FluentIcons.checkmark_12_filled,
              size: 16,
              color: isDoneOrActive ? context.colors.white : context.colors.textSecondary.withValues(alpha: 0.3),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFonts.bodySmall,
              fontWeight: isDoneOrActive ? FontWeight.bold : FontWeight.w600,
              color: isDoneOrActive ? context.colors.textPrimary : context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
