import 'package:apartment/core/theme/app_colors.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/core/widgets/app_toast.dart';
import 'package:apartment/core/widgets/error_state_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:shimmer/shimmer.dart';
import 'package:apartment/l10n/app_localizations.dart';

import '../../cubit/profile_cubit.dart';
import '../../cubit/profile_state.dart';
import '../../cubit/saved_designs_filter_cubit.dart';
import '../../cubit/saved_designs_filter_state.dart';
import '../saved_design_card.dart';
import '../saved_designs_filter_sheet.dart';

class SavedDesignsTabView extends StatefulWidget {
  const SavedDesignsTabView({super.key});

  @override
  State<SavedDesignsTabView> createState() => _SavedDesignsTabViewState();
}

class _SavedDesignsTabViewState extends State<SavedDesignsTabView> {
  final _searchController = TextEditingController();
  late final SavedDesignsFilterCubit _filterCubit;

  @override
  void initState() {
    super.initState();
    _filterCubit = SavedDesignsFilterCubit();
    final profileState = context.read<ProfileCubit>().state;
    if (profileState is ProfileLoaded) {
      _filterCubit.init(profileState.profile.savedDesigns);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _filterCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider.value(
      value: _filterCubit,
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            AppToast.show(context, message: state.message, isError: true);
          } else if (state is ProfileLoaded) {
            _filterCubit.init(state.profile.savedDesigns);
          }
        },
        builder: (context, profileState) {
          if (profileState is ProfileLoading || profileState is ProfileInitial) {
            return _buildLoadingState(context);
          }
          
          if (profileState is ProfileError) {
            return ErrorStateView(
              message: profileState.message,
              onRetry: () => context.read<ProfileCubit>().getProfile(),
            );
          }
          
          if (profileState is ProfileLoaded) {
            if (profileState.profile.savedDesigns.isEmpty) {
              return _buildEmptyState(context);
            }
            
            return Column(
              children: [
                _buildSearchBar(context, l10n),
                Expanded(
                  child: BlocBuilder<SavedDesignsFilterCubit, SavedDesignsFilterState>(
                    builder: (context, filterState) {
                      if (filterState.filteredDesigns.isEmpty) {
                        return Center(
                          child: Text(
                            l10n.noDesignsFound,
                            style: TextStyle(
                              fontSize: AppFonts.bodyLarge,
                              color: context.colors.textSecondary,
                            ),
                          ),
                        );
                      }
                      return ListView.separated(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        physics: const BouncingScrollPhysics(),
                        itemCount: filterState.filteredDesigns.length,
                        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
                        itemBuilder: (context, index) {
                          return SavedDesignCard(
                            design: filterState.filteredDesigns[index],
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: context.colors.border.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (val) => _filterCubit.search(val),
                decoration: InputDecoration(
                  hintText: l10n.searchDesigns,
                  hintStyle: TextStyle(color: context.colors.textSecondary),
                  prefixIcon: Icon(FluentIcons.search_24_regular, color: context.colors.textSecondary),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          GestureDetector(
            onTap: () => SavedDesignsFilterSheet.show(context, _filterCubit),
            child: Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: context.colors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Icon(
                FluentIcons.filter_24_regular,
                color: context.colors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xxxl),
            decoration: BoxDecoration(
              color: context.colors.primary.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              FluentIcons.heart_48_regular,
              size: 64,
              color: context.colors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'لا توجد تصميمات مفضلة',
            style: TextStyle(
              fontSize: AppFonts.headlineSmall,
              fontWeight: FontWeight.bold,
              color: context.colors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'لم تقم بإضافة أي تصميم للمفضلة بعد',
            style: TextStyle(
              fontSize: AppFonts.bodyLarge,
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.xl),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: context.colors.border.withValues(alpha: 0.5),
          highlightColor: context.colors.border.withValues(alpha: 0.1),
          child: Container(
            height: 110,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
          ),
        );
      },
    );
  }
}
