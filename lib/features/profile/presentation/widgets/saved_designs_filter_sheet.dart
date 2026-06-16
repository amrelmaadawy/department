import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../../../l10n/app_localizations.dart';
import '../cubit/saved_designs_filter_cubit.dart';
import '../cubit/saved_designs_filter_state.dart';

class SavedDesignsFilterSheet extends StatelessWidget {
  const SavedDesignsFilterSheet({super.key});

  static void show(BuildContext context, SavedDesignsFilterCubit cubit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return BlocProvider.value(
          value: cubit,
          child: const SavedDesignsFilterSheet(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      child: BlocBuilder<SavedDesignsFilterCubit, SavedDesignsFilterState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.lg),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: context.colors.border,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                ),
              ),
              
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.filterByProject, // Using a generic title like 'Filters' could be better but let's reuse keys or add a generic title
                      style: TextStyle(
                        fontSize: AppFonts.headlineSmall,
                        fontWeight: FontWeight.bold,
                        color: context.colors.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<SavedDesignsFilterCubit>().clearAllFilters();
                      },
                      child: Text(
                        l10n.clearFilters,
                        style: TextStyle(
                          color: context.colors.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Sort Section
                      _buildSectionTitle(context, l10n.sortBy),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          Expanded(
                            child: _buildChoiceChip(
                              context,
                              label: l10n.newestFirst,
                              isSelected: state.isNewestFirst,
                              onSelected: (_) => context.read<SavedDesignsFilterCubit>().setSortOrder(true),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: _buildChoiceChip(
                              context,
                              label: l10n.oldestFirst,
                              isSelected: !state.isNewestFirst,
                              onSelected: (_) => context.read<SavedDesignsFilterCubit>().setSortOrder(false),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xxl),

                      // Projects Section
                      if (state.availableProjects.isNotEmpty) ...[
                        _buildSectionTitle(context, l10n.filterByProject),
                        const SizedBox(height: AppSpacing.md),
                        Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.sm,
                          children: state.availableProjects.map((project) {
                            return _buildChoiceChip(
                              context,
                              label: project,
                              isSelected: state.selectedProject == project,
                              onSelected: (_) => context.read<SavedDesignsFilterCubit>().toggleProjectFilter(project),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                      ],

                      // Styles Section
                      if (state.availableStyles.isNotEmpty) ...[
                        _buildSectionTitle(context, l10n.filterByStyle),
                        const SizedBox(height: AppSpacing.md),
                        Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.sm,
                          children: state.availableStyles.map((style) {
                            return _buildChoiceChip(
                              context,
                              label: style,
                              isSelected: state.selectedStyle == style,
                              onSelected: (_) => context.read<SavedDesignsFilterCubit>().toggleStyleFilter(style),
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              
              // Apply Button
              Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.primary,
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                  ),
                  child: Text(
                    l10n.applyFilters,
                    style: const TextStyle(
                      fontSize: AppFonts.bodyLarge,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: AppFonts.bodyLarge,
        fontWeight: FontWeight.bold,
        color: context.colors.textPrimary,
      ),
    );
  }

  Widget _buildChoiceChip(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required Function(bool) onSelected,
  }) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : context.colors.textPrimary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      backgroundColor: context.colors.border.withValues(alpha: 0.2),
      selectedColor: context.colors.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(
          color: isSelected ? context.colors.primary : Colors.transparent,
        ),
      ),
      showCheckmark: false,
    );
  }
}
