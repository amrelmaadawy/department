import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/custom_finishing_cubit.dart';
import '../cubit/custom_finishing_state.dart';
import 'package:apartment/core/theme/theme_extension.dart';

class CustomFinishingBottomBar extends StatelessWidget {
  const CustomFinishingBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: context.colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.totalEstimatedCost,
                    style: TextStyle(
                      fontSize: AppFonts.bodyMedium,
                      color: context.colors.textPrimary.withValues(alpha: 0.6),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  BlocBuilder<CustomFinishingCubit, CustomFinishingState>(
                    buildWhen: (previous, current) =>
                        previous.totalEstimatedCost !=
                        current.totalEstimatedCost,
                    builder: (context, state) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            state.totalEstimatedCost
                                .toStringAsFixed(0)
                                .replaceAllMapped(
                                  RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                  (Match m) => '${m[1]},',
                                ),
                            style: TextStyle(
                              fontSize: AppFonts.displayMedium,
                              fontWeight: FontWeight.w900,
                              color: context.colors.textPrimary,
                              letterSpacing: -1,
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            l10n.sar,
                            style: TextStyle(
                              fontSize: AppFonts.headlineSmall,
                              fontWeight: FontWeight.bold,
                              color: context.colors.gold,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [context.colors.gold, Color(0xFFE5B962)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  boxShadow: [
                    BoxShadow(
                      color: context.colors.gold.withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    onTap: () {
                      context.read<CustomFinishingCubit>().nextStep();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          l10n.nextButton,
                          style: TextStyle(
                            fontSize: AppFonts.headlineSmall,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: AppSpacing.sm),
                        Icon(
                          FluentIcons
                              .arrow_right_20_filled, // Points other way based on request
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
