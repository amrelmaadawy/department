import 'package:apartment/features/projects/presentation/cubit/ai_room_design_cubit.dart';
import 'package:apartment/features/projects/presentation/cubit/ai_room_design_state.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/widgets/app_toast.dart';

import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/theme_extension.dart';
import 'package:apartment/l10n/app_localizations.dart';

class RoomDesignBottomBar extends StatelessWidget {
  const RoomDesignBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocConsumer<AiRoomDesignCubit, AiRoomDesignState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == AiDesignStatus.success) {
          AppToast.showSuccess(context, l10n.requestSentSuccessfully);
          // Navigate to AI renders screen with the orderId
          if (state.resultOrder != null) {
            context.push('/ai-renders/${state.resultOrder!.id}');
          }
        } else if (state.status == AiDesignStatus.failure) {
          AppToast.showError(context, state.errorMessage ?? l10n.unexpectedError);
        }
      },
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.only(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            top: AppSpacing.md,
            bottom: MediaQuery.of(context).padding.bottom + AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: context.colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.approximateCost,
                      style: TextStyle(
                        fontSize: AppFonts.labelMedium,
                        color: context.colors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${state.expectedTotalCost.toStringAsFixed(0)} ر.س',
                      style: TextStyle(
                        fontSize: AppFonts.headlineSmall,
                        fontWeight: FontWeight.bold,
                        color: context.colors.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: state.status == AiDesignStatus.loading
                        ? null
                        : () {
                            context.read<AiRoomDesignCubit>().submitOrder();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.primary,
                      foregroundColor: context.colors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: AppSpacing.md,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                      elevation: 0,
                    ),
                    icon: state.status == AiDesignStatus.loading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: context.colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(FluentIcons.sparkle_24_filled, size: 20),
                    label: Text(
                      state.status == AiDesignStatus.loading ? l10n.sending : l10n.smartDesign,
                      style: TextStyle(
                        fontSize: AppFonts.bodyMedium,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
