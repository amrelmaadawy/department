import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';

import '../../../../../home/domain/entities/finishing_subtype_entity.dart';
import '../../../cubit/ai_room_design_cubit.dart';
import '../../../cubit/ai_room_design_state.dart';

class RoomLinearProgressBar extends StatelessWidget {
  final List<FinishingSubtypeEntity> allSubtypes;

  const RoomLinearProgressBar({
    super.key,
    required this.allSubtypes,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<AiRoomDesignCubit, AiRoomDesignState>(
      buildWhen: (previous, current) => previous.selectedMaterialIds != current.selectedMaterialIds,
      builder: (context, state) {
        if (allSubtypes.isEmpty) return const SizedBox.shrink();

        final completedCount = allSubtypes.where((subtype) {
          return subtype.materials.any((m) => state.selectedMaterialIds.contains(m.id));
        }).length;
        
        final progress = completedCount / allSubtypes.length;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.roomProgressLabel,
                    style: TextStyle(
                      fontSize: AppFonts.labelMedium,
                      fontWeight: FontWeight.bold,
                      color: context.colors.textSecondary,
                    ),
                  ),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: AppFonts.labelMedium,
                      fontWeight: FontWeight.bold,
                      color: context.colors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.round),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: context.colors.border,
                  valueColor: AlwaysStoppedAnimation<Color>(context.colors.primary),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
