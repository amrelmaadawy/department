import 'package:apartment/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:apartment/l10n/app_localizations.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';

import '../../../../domain/entities/customer_render_entity.dart';
import '../../../../../../core/presentation/widgets/network_action_guard.dart';
import 'room_customer_renders_carousel.dart';
import '../../../cubit/unit_details_cubit.dart';

class RoomDesignsBottomSheet extends StatelessWidget {
  final String roomName;
  final int roomId;
  final String unitId;
  final List<CustomerRenderEntity> renders;
  final VoidCallback onNewDesignPressed;

  const RoomDesignsBottomSheet({
    super.key,
    required this.roomName,
    required this.roomId,
    required this.unitId,
    required this.renders,
    required this.onNewDesignPressed,
  });

  static Future<void> show({
    required BuildContext context,
    required String roomName,
    required int roomId,
    required String unitId,
    required List<CustomerRenderEntity> renders,
    required VoidCallback onNewDesignPressed,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (bottomSheetContext) => BlocProvider.value(
        value: context.read<UnitDetailsCubit>(), // Pass the cubit to the bottom sheet context
        child: RoomDesignsBottomSheet(
          roomName: roomName,
          roomId: roomId,
          unitId: unitId,
          renders: renders,
          onNewDesignPressed: onNewDesignPressed,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle Bar
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.lg),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.colors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.roomDesigns,
                  style: TextStyle(
                    fontSize: AppFonts.headlineMedium,
                    fontWeight: FontWeight.bold,
                    color: context.colors.textPrimary,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(FluentIcons.dismiss_24_regular, color: context.colors.textSecondary),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppSpacing.md),
          
          // Carousel
          BlocSelector<UnitDetailsCubit, UnitDetailsState, List<CustomerRenderEntity>>(
            selector: (state) {
              if (state is UnitDetailsLoaded) {
                final roomRenders = state.customerRenders.where((r) => r.id == roomId).toList();
                if (roomRenders.isNotEmpty) {
                  return roomRenders.first.renders;
                }
              }
              return renders; // fallback
            },
            builder: (context, latestRenders) {
              return RoomCustomerRendersCarousel(
                renders: latestRenders,
                roomName: roomName,
                onFavoriteToggled: (render) {
                  context.read<UnitDetailsCubit>().toggleRenderFavorite(
                    int.tryParse(unitId) ?? 0,
                    roomId,
                    render.url,
                  );
                },
              );
            },
          ),
          
          const SizedBox(height: AppSpacing.xl),
          
          // New Design Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: NetworkActionGuard(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context); // Close sheet
                  onNewDesignPressed(); // Trigger new design in main page
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.primary.withValues(alpha: 0.1),
                  foregroundColor: context.colors.primary,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    side: BorderSide(color: context.colors.primary.withValues(alpha: 0.2)),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(FluentIcons.sparkle_24_filled, size: 20),
                label: Text(
                  l10n.createNewDesign,
                  style: const TextStyle(
                    fontSize: AppFonts.bodyMedium,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
