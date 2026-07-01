import 'package:apartment/core/theme/app_colors.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class UnitStatusBadge extends StatelessWidget {
  final UnitStatus status;
  final String statusLabel;
  final bool isOverlay;

  const UnitStatusBadge({
    super.key,
    required this.status,
    this.statusLabel = '',
    this.isOverlay = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final label = statusLabel.isNotEmpty
        ? statusLabel
        : (status == UnitStatus.sold
            ? l10n.unitSoldOut
            : (status == UnitStatus.reserved ? l10n.unitReserved : l10n.unitAvailable));

    Color primaryColor;
    Color bgColor;
    Color borderColor;
    IconData icon;

    if (status == UnitStatus.sold) {
      primaryColor = const Color(0xFFDC2626);
      bgColor = const Color(0xFFFEE2E2);
      borderColor = const Color(0xFFFECACA);
      icon = FluentIcons.lock_closed_16_filled;
    } else if (status == UnitStatus.reserved) {
      primaryColor = const Color(0xFFD97706); // Amber 600
      bgColor = const Color(0xFFFEF3C7); // Amber 100
      borderColor = const Color(0xFFFDE68A); // Amber 200
      icon = FluentIcons.bookmark_16_filled;
    } else {
      primaryColor = const Color(0xFF059669);
      bgColor = const Color(0xFFD1FAE5);
      borderColor = const Color(0xFFA7F3D0);
      icon = FluentIcons.checkmark_circle_16_filled;
    }

    if (isOverlay) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          color: primaryColor.withValues(alpha: 0.94),
          borderRadius: BorderRadius.circular(AppRadius.round),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.22),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: AppColors.white),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.white,
                fontWeight: FontWeight.w700,
                height: 1.1,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.round),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: primaryColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: primaryColor,
              fontWeight: FontWeight.w700,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}
