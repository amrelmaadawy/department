import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:apartment/l10n/app_localizations.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';

import '../../../cubit/ai_room_design_cubit.dart';
import 'ai_design_settings_section.dart';

class AiDesignSettingsBottomSheet extends StatelessWidget {
  final VoidCallback onStartDesign;

  const AiDesignSettingsBottomSheet({
    super.key,
    required this.onStartDesign,
  });

  static Future<void> show({
    required BuildContext context,
    required AiRoomDesignCubit aiRoomDesignCubit,
    required VoidCallback onStartDesign,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => BlocProvider.value(
        value: aiRoomDesignCubit,
        child: AiDesignSettingsBottomSheet(
          onStartDesign: onStartDesign,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + MediaQuery.of(context).padding.bottom + AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle Bar
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.lg),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.colors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.aiSettings,
                  style: TextStyle(
                    fontSize: AppFonts.headlineMedium,
                    fontWeight: FontWeight.bold,
                    color: context.colors.textPrimary,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(FluentIcons.dismiss_24_regular, color: context.colors.textSecondary),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppSpacing.md),
          
          // Settings Content
          const AiDesignSettingsSection(),
          
          const SizedBox(height: AppSpacing.xl),
          
          // Start Design Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context); // Close sheet
                onStartDesign(); // Trigger new design
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary,
                foregroundColor: context.colors.white,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                elevation: 0,
              ),
              icon: const Icon(FluentIcons.sparkle_24_filled, size: 20),
              label: Text(
                l10n.startDesign,
                style: const TextStyle(
                  fontSize: AppFonts.bodyMedium,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
