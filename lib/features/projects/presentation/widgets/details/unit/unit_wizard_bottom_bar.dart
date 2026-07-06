import 'package:apartment/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/core/widgets/custom_button.dart';
import 'package:apartment/core/routes/app_router.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class UnitWizardBottomBar extends StatefulWidget {
  final ProjectUnitEntity unit;
  final double finishingCost;
  final TabController tabController;

  const UnitWizardBottomBar({
    super.key,
    required this.unit,
    required this.tabController,
    this.finishingCost = 0.0,
  });

  @override
  State<UnitWizardBottomBar> createState() => _UnitWizardBottomBarState();
}

class _UnitWizardBottomBarState extends State<UnitWizardBottomBar> {
  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(_handleTabChange);
  }

  @override
  void didUpdateWidget(covariant UnitWizardBottomBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tabController != oldWidget.tabController) {
      oldWidget.tabController.removeListener(_handleTabChange);
      widget.tabController.addListener(_handleTabChange);
    }
  }

  @override
  void dispose() {
    widget.tabController.removeListener(_handleTabChange);
    super.dispose();
  }

  void _handleTabChange() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;


    final currentIndex = widget.tabController.index;
    final totalRooms = widget.unit.rooms.length;
    final isLastRoom = totalRooms == 0 || currentIndex == totalRooms - 1;
    final isFirstRoom = totalRooms == 0 || currentIndex == 0;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: context.colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              
              const SizedBox(height: AppSpacing.md),
              
              // Wizard Actions Row
              Row(
                children: [
                  if (!isFirstRoom) ...[
                    OutlinedButton(
                      onPressed: () {
                        widget.tabController.animateTo(currentIndex - 1);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        side: BorderSide(color: context.colors.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.md),
                        ),
                      ),
                      child: Icon(
                        FluentIcons.chevron_right_24_regular,
                        color: context.colors.textPrimary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                  ],
                  Expanded(
                    child: CustomButton(
                      text: isLastRoom
                          ? l10n.reviewAndSignContracts
                          : 'التالي: ${widget.unit.rooms[currentIndex + 1].name}',
                      onPressed: () {
                        if (isLastRoom) {
                          context.push(
                            AppRouter.contractsReview,
                            extra: {
                              'totalFinishingCost': widget.finishingCost,
                              'unit': widget.unit,
                            },
                          );
                        } else {
                          widget.tabController.animateTo(currentIndex + 1);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
