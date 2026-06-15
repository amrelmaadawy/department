import 'package:apartment/features/projects/presentation/cubit/ai_room_design_cubit.dart';
import 'package:apartment/features/projects/presentation/cubit/ai_room_design_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/theme_extension.dart';
class AiDesignSettingsSection extends StatefulWidget {
  const AiDesignSettingsSection({super.key});

  @override
  State<AiDesignSettingsSection> createState() => _AiDesignSettingsSectionState();
}

class _AiDesignSettingsSectionState extends State<AiDesignSettingsSection> {
  final TextEditingController _notesController = TextEditingController();

  final List<String> _availableStyles = [
    'Modern',
    'Classic',
    'Japandi',
    'Industrial',
    'Bohemian',
    'Minimalist',
  ];

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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: context.colors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Text(
                'إعدادات الذكاء الاصطناعي',
                style: TextStyle(
                  fontSize: AppFonts.headlineSmall,
                  fontWeight: FontWeight.bold,
                  color: context.colors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          
          // Style Selection
          Text(
            'اختر الستايل (اختياري)',
            style: TextStyle(
              fontSize: AppFonts.bodyMedium,
              fontWeight: FontWeight.bold,
              color: context.colors.textPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: 40,
            child: BlocBuilder<AiRoomDesignCubit, AiRoomDesignState>(
              builder: (context, state) {
                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _availableStyles.length,
                  separatorBuilder: (context, index) => SizedBox(width: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final style = _availableStyles[index];
                    final isSelected = state.selectedStyle == style;

                    return GestureDetector(
                      onTap: () {
                        context.read<AiRoomDesignCubit>().updateStyle(isSelected ? null : style);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected ? context.colors.primary : context.colors.white,
                          borderRadius: BorderRadius.circular(AppRadius.round),
                          border: Border.all(
                            color: isSelected ? context.colors.primary : context.colors.border,
                          ),
                        ),
                        child: Text(
                          style,
                          style: TextStyle(
                            color: isSelected ? context.colors.white : context.colors.textPrimary,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          
          SizedBox(height: AppSpacing.lg),
          
          // Notes TextField
          Text(
            'ملاحظات إضافية (اختياري)',
            style: TextStyle(
              fontSize: AppFonts.bodyMedium,
              fontWeight: FontWeight.bold,
              color: context.colors.textPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _notesController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'مثال: أرغب بدمج بساطة التصميم الياباني...',
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
        ],
      ),
    );
  }
}
