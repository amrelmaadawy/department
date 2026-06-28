import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/features/home/domain/entities/unit_room_entity.dart';
import 'package:apartment/features/home/domain/entities/finishing_material_entity.dart';
import 'package:apartment/core/widgets/custom_button.dart';


class ApplyToOtherRoomsSheet extends StatefulWidget {
  final FinishingMaterialEntity selectedMaterial;
  final List<UnitRoomEntity> otherRooms;
  final List<int> currentlyAppliedRoomIds;
  final Function(List<int> specificRoomIds) onApply;

  const ApplyToOtherRoomsSheet({
    super.key,
    required this.selectedMaterial,
    required this.otherRooms,
    required this.currentlyAppliedRoomIds,
    required this.onApply,
  });

  static Future<void> show(
    BuildContext context, {
    required FinishingMaterialEntity selectedMaterial,
    required List<UnitRoomEntity> otherRooms,
    required List<int> currentlyAppliedRoomIds,
    required Function(List<int> specificRoomIds) onApply,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ApplyToOtherRoomsSheet(
        selectedMaterial: selectedMaterial,
        otherRooms: otherRooms,
        currentlyAppliedRoomIds: currentlyAppliedRoomIds,
        onApply: onApply,
      ),
    );
  }

  @override
  State<ApplyToOtherRoomsSheet> createState() => _ApplyToOtherRoomsSheetState();
}

class _ApplyToOtherRoomsSheetState extends State<ApplyToOtherRoomsSheet> {
  late bool _isApplyToAll;
  late Set<int> _selectedSpecificRoomIds;

  @override
  void initState() {
    super.initState();
    _isApplyToAll = false;
    _selectedSpecificRoomIds = {};
  }

  void _onCheckboxChanged(bool? value) {
    if (value == null) return;
    HapticFeedback.lightImpact();
    setState(() {
      _isApplyToAll = value;
      if (_isApplyToAll) {
        _selectedSpecificRoomIds = widget.otherRooms.map((r) => r.id).toSet();
      } else {
        _selectedSpecificRoomIds.clear();
      }
    });
  }

  void _onChipToggled(int roomId, bool isSelected) {
    HapticFeedback.lightImpact();
    setState(() {
      if (isSelected) {
        _selectedSpecificRoomIds.add(roomId);
      } else {
        _selectedSpecificRoomIds.remove(roomId);
      }
      
      _isApplyToAll = widget.otherRooms.every((r) => _selectedSpecificRoomIds.contains(r.id));
    });
  }

  IconData _getIconForRoomType(String type) {
    switch (type) {
      case 'bedroom': return FluentIcons.bed_24_regular;
      case 'bathroom': return FluentIcons.drop_24_regular;
      case 'kitchen': return FluentIcons.food_24_regular;
      case 'living_room': return FluentIcons.tv_24_regular;
      case 'men_majlis':
      case 'women_majlis': return FluentIcons.conference_room_24_regular;
      case 'laundry': return FluentIcons.weather_blowing_snow_24_regular;
      case 'entrance': return FluentIcons.door_arrow_left_24_regular;
      default: return FluentIcons.building_24_regular;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.sm),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.colors.border,
                borderRadius: BorderRadius.circular(AppRadius.round),
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: context.colors.success.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(FluentIcons.checkmark_circle_24_filled, size: 48, color: context.colors.success),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'تم اختيار الخامة بنجاح',
                  style: TextStyle(
                    fontSize: AppFonts.headlineSmall,
                    fontWeight: FontWeight.bold,
                    color: context.colors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'هل ترغب في تطبيق نفس هذه الخامة على باقي الغرف لتوفير الوقت؟',
                  style: TextStyle(
                    fontSize: AppFonts.bodyMedium,
                    color: context.colors.textSecondary,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          Container(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            decoration: BoxDecoration(
              color: context.colors.white,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: context.colors.border.withValues(alpha: 0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Theme(
                  data: Theme.of(context).copyWith(
                    checkboxTheme: CheckboxThemeData(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      fillColor: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) return context.colors.primary;
                        return Colors.transparent;
                      }),
                    ),
                  ),
                  child: CheckboxListTile(
                    value: _isApplyToAll,
                    onChanged: _onCheckboxChanged,
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    title: Text(
                      'تحديد جميع الغرف',
                      style: TextStyle(
                        fontSize: AppFonts.bodyMedium,
                        fontWeight: FontWeight.bold,
                        color: context.colors.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      '(${widget.otherRooms.length} غرف أخرى)',
                      style: TextStyle(
                        fontSize: AppFonts.labelSmall,
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ),
                ),
                
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: !_isApplyToAll
                      ? Padding(
                          padding: const EdgeInsets.only(
                            left: AppSpacing.lg,
                            right: AppSpacing.lg,
                            bottom: AppSpacing.lg,
                          ),
                          child: Wrap(
                            spacing: AppSpacing.sm,
                            runSpacing: AppSpacing.sm,
                            children: widget.otherRooms.map((room) {
                              final isSelected = _selectedSpecificRoomIds.contains(room.id);
                              return FilterChip(
                                label: Text(room.name),
                                selected: isSelected,
                                onSelected: (val) => _onChipToggled(room.id, val),
                                showCheckmark: false,
                                avatar: Icon(
                                  _getIconForRoomType(room.type),
                                  size: 16,
                                  color: isSelected ? context.colors.white : context.colors.primary,
                                ),
                                backgroundColor: context.colors.white,
                                selectedColor: context.colors.primary,
                                labelStyle: TextStyle(
                                  fontSize: AppFonts.labelMedium,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  color: isSelected ? context.colors.white : context.colors.textPrimary,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppRadius.round),
                                  side: BorderSide(
                                    color: isSelected ? context.colors.primary : context.colors.border,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        )
                      : const SizedBox(width: double.infinity),
                ),
              ],
            ),
          ),
          
          Padding(
            padding: EdgeInsets.only(
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              top: AppSpacing.xl,
              bottom: MediaQuery.of(context).padding.bottom + AppSpacing.lg,
            ),
            child: Column(
              children: [
                CustomButton(
                  text: 'تطبيق التحديد',
                  onPressed: _selectedSpecificRoomIds.isEmpty ? null : () {
                    widget.onApply(_selectedSpecificRoomIds.toList());
                    Navigator.pop(context);
                  },
                  backgroundColor: context.colors.primary,
                  textColor: Colors.white,
                ),
                const SizedBox(height: AppSpacing.md),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'تخطي (هذه الغرفة فقط)',
                    style: TextStyle(
                      fontSize: AppFonts.bodyMedium,
                      fontWeight: FontWeight.bold,
                      color: context.colors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
