import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:apartment/core/theme/theme_extension.dart';


class ChatInputBar extends StatelessWidget {
  const ChatInputBar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.md,
        bottom: MediaQuery.of(context).padding.bottom + AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: context.colors.white,
        border: Border(
          top: BorderSide(
            color: context.colors.border.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Input field
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: context.colors.white,
              border: Border.all(
                color: context.colors.border.withValues(alpha: 0.5),
              ),
              borderRadius: BorderRadius.circular(AppRadius.round),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 5,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Send Button (Left side in RTL)
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.colors.primary, // Professional primary color
                  ),
                  child: Icon(
                    FluentIcons.send_24_filled,
                    color: context.colors.white,
                    size: 20,
                  ),
                ),
                SizedBox(width: AppSpacing.md),

                // Text Field
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: l10n.typeMessageHint,
                      hintStyle: TextStyle(
                        color: context.colors.textSecondary.withValues(alpha: 0.5),
                        fontSize: AppFonts.bodyMedium,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),

                // Attachment Button (Right side in RTL)
                IconButton(
                  icon: Icon(
                    FluentIcons.attach_24_regular,
                    color: context.colors.textSecondary.withValues(alpha: 0.7),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
