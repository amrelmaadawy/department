import 'package:apartment/features/projects/presentation/cubit/ai_room_design_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apartment/l10n/app_localizations.dart';

import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/theme_extension.dart';
import '../../../../../home/domain/entities/finishing_category_entity.dart';
import '../../../../../home/domain/entities/finishing_material_entity.dart';
import '../../../../../home/domain/entities/finishing_subtype_entity.dart';
import '../../../../../home/domain/entities/unit_room_entity.dart';

import 'category_tab_controller.dart';
import 'company_filter_chips.dart';
import 'finishing_material_grid_section.dart';
import 'finishing_subtype_tabs_row.dart';
import 'room_linear_progress_bar.dart';

class FinishingOptionsSection extends StatefulWidget {
  final List<FinishingCategoryEntity> options;
  final List<UnitRoomEntity> unitRooms;
  final UnitRoomEntity? currentRoom;
  final CategoryTabController categoryTabController;
  final bool isReadOnly;
  final bool isPackageMode;

  const FinishingOptionsSection({
    super.key,
    required this.options,
    this.unitRooms = const [],
    this.currentRoom,
    required this.categoryTabController,
    this.isReadOnly = false,
    this.isPackageMode = false,
  });

  @override
  State<FinishingOptionsSection> createState() => _FinishingOptionsSectionState();
}

class _FinishingOptionsSectionState extends State<FinishingOptionsSection> {
  late List<FinishingSubtypeEntity> _allSubtypes;
  int? _highlightedTabIndex;
  int _lastSubtypeIndex = 0;
  int? _selectedCompanyId = -1;

  @override
  void initState() {
    super.initState();
    _flattenSubtypes();
  }

  @override
  void didUpdateWidget(FinishingOptionsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.options != oldWidget.options) {
      _flattenSubtypes();
      if (widget.categoryTabController.currentIndex >= _allSubtypes.length) {
        widget.categoryTabController.setIndex(0);
      }
    }
  }

  void _flattenSubtypes() {
    _allSubtypes = widget.options.expand((category) => category.subtypes).toList();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AiRoomDesignCubit>().setTotalSubtypesCount(_allSubtypes.length);
      }
    });
    widget.categoryTabController.setTotalTabs(_allSubtypes.length);
  }

  void _triggerHighlightNextTab() {
    if (widget.categoryTabController.currentIndex < _allSubtypes.length - 1) {
      setState(() => _highlightedTabIndex = widget.categoryTabController.currentIndex + 1);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _highlightedTabIndex = null);
      });
    }
  }

  List<CompanyOption> _getAvailableCompanies(List<FinishingMaterialEntity> materials) {
    final Map<int?, String> uniqueMap = {};
    bool hasGeneral = false;
    for (final m in materials) {
      if (m.companyId != null && m.companyName != null && m.companyName!.isNotEmpty) {
        uniqueMap[m.companyId] = m.companyName!;
      } else {
        hasGeneral = true;
      }
    }
    return [
      const CompanyOption(id: -1, name: 'الكل'),
      if (hasGeneral && uniqueMap.isNotEmpty) const CompanyOption(id: null, name: 'عام'),
      ...uniqueMap.entries.map((e) => CompanyOption(id: e.key, name: e.value)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (_allSubtypes.isEmpty) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context)!;

    return AnimatedBuilder(
      animation: widget.categoryTabController,
      builder: (context, _) {
        final selectedSubtype = _allSubtypes[widget.categoryTabController.currentIndex];
        if (widget.categoryTabController.currentIndex != _lastSubtypeIndex) {
          _lastSubtypeIndex = widget.categoryTabController.currentIndex;
          _selectedCompanyId = -1;
        }

        final availableCompanies = _getAvailableCompanies(selectedSubtype.materials);
        final filteredMaterials = selectedSubtype.materials.where((m) {
          if (_selectedCompanyId == -1) return true;
          return m.companyId == _selectedCompanyId;
        }).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RoomLinearProgressBar(allSubtypes: _allSubtypes),
            const SizedBox(height: AppSpacing.md),

            FinishingSubtypeTabsRow(
              allSubtypes: _allSubtypes,
              categoryTabController: widget.categoryTabController,
              highlightedTabIndex: _highlightedTabIndex,
            ),
            const SizedBox(height: AppSpacing.lg),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Text(
                l10n.chooseTypeOf(selectedSubtype.subtypeName),
                style: TextStyle(
                  fontSize: AppFonts.headlineSmall,
                  fontWeight: FontWeight.bold,
                  color: context.colors.textPrimary,
                ),
              ),
            ),

            if (availableCompanies.length > 1) ...[
              const SizedBox(height: AppSpacing.sm),
              CompanyFilterChips(
                companies: availableCompanies,
                selectedCompanyId: _selectedCompanyId,
                onSelectCompany: (id) => setState(() => _selectedCompanyId = id),
              ),
            ],

            const SizedBox(height: AppSpacing.md),
            FinishingMaterialGridSection(
              selectedSubtype: selectedSubtype,
              filteredMaterials: filteredMaterials,
              unitRooms: widget.unitRooms,
              currentRoom: widget.currentRoom,
              categoryTabController: widget.categoryTabController,
              isReadOnly: widget.isReadOnly,
              isPackageMode: widget.isPackageMode,
              onHighlightNextTab: _triggerHighlightNextTab,
            ),
          ],
        );
      },
    );
  }
}
