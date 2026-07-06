import 'package:flutter/material.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:apartment/features/contracts/domain/entities/apartment_finishing_order_entity.dart';
import 'order_selection_card.dart';

class RoomOrdersSection extends StatelessWidget {
  final ApartmentFinishingOrderRoomEntity room;
  final int? selectedOrderId;
  final Function(int) onOrderSelected;

  const RoomOrdersSection({
    super.key,
    required this.room,
    required this.selectedOrderId,
    required this.onOrderSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (room.orders.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Row(
            children: [
              Icon(FluentIcons.conference_room_24_regular, color: context.colors.primary, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Text(
                room.roomName,
                style: TextStyle(
                  fontSize: AppFonts.headlineSmall,
                  fontWeight: FontWeight.bold,
                  color: context.colors.textPrimary,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: context.colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${room.orders.length} طلبات', // Use localization properly if available
                  style: TextStyle(
                    fontSize: AppFonts.bodySmall,
                    color: context.colors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 200, // Reduced height since price is removed
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            itemCount: room.orders.length,
            itemBuilder: (context, index) {
              final order = room.orders[index];
              return OrderSelectionCard(
                order: order,
                fallbackRoomName: room.roomName,
                isSelected: order.id == selectedOrderId,
                onTap: () => onOrderSelected(order.id),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}
