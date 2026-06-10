import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/material_category.dart';
import '../cubit/custom_finishing_cubit.dart';
import '../cubit/custom_finishing_state.dart';
import '../widgets/finishing_category_tabs.dart';
import '../widgets/material_card.dart';
import '../widgets/custom_finishing_bottom_bar.dart';
import '../widgets/review/custom_finishing_review_view.dart';
import 'package:apartment/core/theme/theme_extension.dart';


class CustomFinishingScreen extends StatelessWidget {
  const CustomFinishingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CustomFinishingCubit()..loadMaterials(),
      child: BlocListener<CustomFinishingCubit, CustomFinishingState>(
        listenWhen: (previous, current) =>
            previous.bookingStatus != current.bookingStatus,
        listener: (context, state) {
          if (state.bookingStatus == BookingStatus.success) {
            context.push('/contracts-review', extra: state);
          }
        },
        child: const CustomFinishingView(),
      ),
    );
  }
}

class CustomFinishingView extends StatelessWidget {
  const CustomFinishingView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.white,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          l10n.customFinishing,
          style: TextStyle(
            fontSize: AppFonts.headlineMedium,
            fontWeight: FontWeight.bold,
            color: context.colors.primary,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            FluentIcons
                .arrow_left_24_filled, // Pointing opposite way as requested
            color: context.colors.primary,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sticky Tabs
          Container(
            color: context.colors.white,
            padding: EdgeInsets.only(bottom: AppSpacing.sm),
            child: const FinishingCategoryTabs(),
          ),

          Expanded(
            child: BlocBuilder<CustomFinishingCubit, CustomFinishingState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return Center(
                    child: CircularProgressIndicator(color: context.colors.gold),
                  );
                }

                if (state.currentCategory == MaterialCategory.review) {
                  return const CustomFinishingReviewView();
                }

                final currentMaterials =
                    state.availableMaterials[state.currentCategory] ?? [];
                final selectedMaterialId =
                    state.selectedMaterials[state.currentCategory]?.id;

                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.05, 0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: ListView(
                    key: ValueKey<MaterialCategory>(state.currentCategory),
                    padding: EdgeInsets.symmetric(
                      vertical: AppSpacing.xl,
                      horizontal: AppSpacing.md,
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: AppSpacing.lg,
                          right: AppSpacing.sm,
                        ),
                        child: Text(
                          _getStepTitle(state.currentCategory, l10n),
                          style: TextStyle(
                            fontSize: AppFonts.headlineMedium,
                            fontWeight: FontWeight.bold,
                            color: context.colors.primary,
                          ),
                        ),
                      ),
                      ...currentMaterials.map((material) {
                        return MaterialCard(
                          key: ValueKey<String>(material.id),
                          material: material,
                          isSelected: material.id == selectedMaterialId,
                          onTap: () {
                            context.read<CustomFinishingCubit>().selectMaterial(
                              material,
                            );
                          },
                        );
                      }),
                    ],
                  ),
                );
              },
            ),
          ),

          // Sticky Bottom Bar - Only show if not in review
          BlocBuilder<CustomFinishingCubit, CustomFinishingState>(
            buildWhen: (previous, current) =>
                previous.currentCategory != current.currentCategory,
            builder: (context, state) {
              if (state.currentCategory == MaterialCategory.review) {
                return const SizedBox.shrink();
              }
              return const CustomFinishingBottomBar();
            },
          ),
        ],
      ),
    );
  }

  String _getStepTitle(MaterialCategory category, AppLocalizations l10n) {
    switch (category) {
      case MaterialCategory.floors:
        return l10n.chooseFloorType;
      case MaterialCategory.walls:
        return l10n.chooseWallType;
      case MaterialCategory.ceilings:
        return l10n.chooseCeilingType;
      case MaterialCategory.doors:
        return l10n.chooseDoorType;
      case MaterialCategory.review:
        return l10n.reviewSelections;
    }
  }
}
