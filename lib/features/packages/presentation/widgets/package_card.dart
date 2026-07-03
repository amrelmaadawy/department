import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';
import 'package:apartment/features/packages/domain/entities/finishing_package_entity.dart';
import 'package_card_header.dart';
import 'package_card_rooms.dart';
import 'package_card_action.dart';

class PackageCard extends StatelessWidget {
  final FinishingPackageEntity package;
  final ProjectUnitEntity unit;

  const PackageCard({super.key, required this.package, required this.unit});

  @override
  Widget build(BuildContext context) {
    final primaryBadge = package.badges.isNotEmpty
        ? package.badges.first
        : null;
    final secondaryBadges = package.badges.length > 1
        ? package.badges.sublist(1)
        : <String>[];

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            color: context.colors.white,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(
              color: context.colors.gold.withValues(alpha: 0.15),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: context.colors.black.withValues(alpha: 0.05),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PackageCardHeader(
                package: package,
                secondaryBadges: secondaryBadges,
              ),
              PackageCardRooms(package: package),
              PackageCardAction(package: package, unit: unit),
            ],
          ),
        ),
        if (primaryBadge != null)
          Positioned(
            top: -16,
            right: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [context.colors.gold, context.colors.goldDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppRadius.round),
                boxShadow: [
                  BoxShadow(
                    color: context.colors.gold.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: context.colors.white.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    FluentIcons.star_16_filled,
                    size: 14,
                    color: context.colors.white,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    primaryBadge,
                    style: TextStyle(
                      fontSize: AppFonts.bodySmall,
                      fontWeight: FontWeight.w800,
                      color: context.colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
