import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/features/home/domain/entities/unit_room_entity.dart';
import 'package:apartment/features/home/domain/entities/finishing_material_entity.dart';

class InlineMaterialApply extends StatefulWidget {
  final FinishingMaterialEntity selectedMaterial;
  final List<UnitRoomEntity> otherRooms;
  final List<int> currentlyAppliedRoomIds;
  final Function(bool applyToAll, List<int> specificRoomIds) onApplyChanged;

  const InlineMaterialApply({
    super.key,
    required this.selectedMaterial,
    required this.otherRooms,
    required this.currentlyAppliedRoomIds,
    required this.onApplyChanged,
  });

  @override
  State<InlineMaterialApply> createState() => _InlineMaterialApplyState();
}

class _InlineMaterialApplyState extends State<InlineMaterialApply> {
  late bool _isApplyToAll;
  late Set<int> _selectedSpecificRoomIds;

  @override
  void initState() {
    super.initState();
    _initStates();
  }

  @override
  void didUpdateWidget(covariant InlineMaterialApply oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedMaterial.id != oldWidget.selectedMaterial.id ||
        widget.currentlyAppliedRoomIds != oldWidget.currentlyAppliedRoomIds) {
      _initStates();
    }
  }

  void _initStates() {
    // If the material is applied to ALL other rooms
    _isApplyToAll = widget.otherRooms.isNotEmpty &&
        widget.otherRooms.every((r) => widget.currentlyAppliedRoomIds.contains(r.id));
    
    _selectedSpecificRoomIds = widget.currentlyAppliedRoomIds.toSet();
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
    widget.onApplyChanged(_isApplyToAll, _selectedSpecificRoomIds.toList());
  }

  void _onChipToggled(int roomId, bool isSelected) {
    HapticFeedback.lightImpact();
    setState(() {
      if (isSelected) {
        _selectedSpecificRoomIds.add(roomId);
      } else {
        _selectedSpecificRoomIds.remove(roomId);
      }
      
      // Update applyToAll checkbox state dynamically
      _isApplyToAll = widget.otherRooms.every((r) => _selectedSpecificRoomIds.contains(r.id));
    });
    widget.onApplyChanged(_isApplyToAll, _selectedSpecificRoomIds.toList());
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
    if (widget.otherRooms.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.primary.withValues(alpha: 0.02),
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
                'تطبيق على جميع الغرف',
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
    );
  }
}
