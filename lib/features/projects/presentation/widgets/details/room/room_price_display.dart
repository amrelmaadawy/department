import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';

import '../../../../../home/domain/entities/project_unit_entity.dart';

class RoomPriceDisplay extends StatelessWidget {
  final ProjectUnitEntity unit;
  final double finishingCost;
  final VoidCallback onDesignOptionsPressed;

  const RoomPriceDisplay({
    super.key,
    required this.unit,
    required this.finishingCost,
    required this.onDesignOptionsPressed,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final formatter = NumberFormat.currency(symbol: '', decimalDigits: 0);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.priceTitle,
              style: TextStyle(
                fontSize: AppFonts.bodySmall,
                color: context.colors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${formatter.format(unit.price + finishingCost).trim()} ${l10n.sar}',
                  style: TextStyle(
                    fontSize: AppFonts.headlineMedium,
                    fontWeight: FontWeight.bold,
                    color: context.colors.gold,
                  ),
                ),
                if (finishingCost > 0) ...[
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    '(+ ${formatter.format(finishingCost).trim()})',
                    style: TextStyle(
                      fontSize: AppFonts.labelSmall,
                      color: context.colors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        OutlinedButton.icon(
          onPressed: onDesignOptionsPressed,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            side: BorderSide(color: context.colors.gold.withValues(alpha: 0.5)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.round),
            ),
          ),
          icon: Icon(
            FluentIcons.options_24_regular, 
            size: 20, 
            color: context.colors.gold,
          ),
          label: Text(
            l10n.designOptions,
            style: TextStyle(
              fontSize: AppFonts.labelMedium,
              fontWeight: FontWeight.bold,
              color: context.colors.gold,
            ),
          ),
        ),
      ],
    );
  }
}
