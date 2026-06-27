import 'package:apartment/features/projects/presentation/cubit/ai_room_design_cubit.dart';
import 'package:apartment/features/projects/presentation/cubit/ai_room_design_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/theme_extension.dart';
import 'package:apartment/l10n/app_localizations.dart';
class AiDesignSettingsSection extends StatefulWidget {
  const AiDesignSettingsSection({super.key});

  @override
  State<AiDesignSettingsSection> createState() => _AiDesignSettingsSectionState();
}

class _AiDesignSettingsSectionState extends State<AiDesignSettingsSection> {
  final TextEditingController _notesController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _notesController.addListener(() {
      context.read<AiRoomDesignCubit>().updateNotes(_notesController.text);
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

        
          // Notes TextField
          Text(
            l10n.additionalNotesOptional,
            style: TextStyle(
              fontSize: AppFonts.bodyMedium,
              fontWeight: FontWeight.bold,
              color: context.colors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _notesController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: l10n.notesExample,
              hintStyle: TextStyle(color: context.colors.textSecondary),
              filled: true,
              fillColor: context.colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: BorderSide(color: context.colors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: BorderSide(color: context.colors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: BorderSide(color: context.colors.primary),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          BlocBuilder<AiRoomDesignCubit, AiRoomDesignState>(
            builder: (context, state) {
              if (state.presetNotesStatus == PresetNotesStatus.loading) {
                return SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.sm),
                    itemBuilder: (context, index) => Shimmer.fromColors(
                      baseColor: context.colors.border.withValues(alpha: 0.5),
                      highlightColor: context.colors.border.withValues(alpha: 0.1),
                      child: Container(
                        width: 150,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppRadius.round),
                        ),
                      ),
                    ),
                  ),
                );
              }
              
              if (state.presetNotes.isEmpty) {
                return const SizedBox.shrink();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.suggestedNotes,
                    style: TextStyle(
                      fontSize: AppFonts.labelLarge,
                      color: context.colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.presetNotes.length,
                      separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final note = state.presetNotes[index];
                        return ActionChip(
                          label: Text(note),
                          labelStyle: TextStyle(
                            fontSize: AppFonts.bodySmall,
                            color: context.colors.primary,
                          ),
                          backgroundColor: context.colors.primary.withValues(alpha: 0.05),
                          side: BorderSide(color: context.colors.primary.withValues(alpha: 0.2)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.round)),
                          onPressed: () {
                            final currentText = _notesController.text;
                            final newText = currentText.isEmpty ? note : '$currentText\n$note';
                            _notesController.text = newText;
                            _notesController.selection = TextSelection.fromPosition(
                              TextPosition(offset: newText.length),
                            );
                            // Cubit is updated via the controller's listener set in initState
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
