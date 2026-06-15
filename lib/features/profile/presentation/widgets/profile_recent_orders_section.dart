import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../projects/domain/entities/finishing_order_entity.dart';

class ProfileRecentOrdersSection extends StatelessWidget {
  final List<FinishingOrderEntity> recentOrders;

  const ProfileRecentOrdersSection({super.key, required this.recentOrders});

  @override
  Widget build(BuildContext context) {
    if (recentOrders.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'أحدث الطلبات',
                style: TextStyle(
                  fontSize: AppFonts.bodyLarge,
                  fontWeight: FontWeight.bold,
                  color: context.colors.textPrimary.withValues(alpha: 0.6),
                ),
              ),
              /*
              TextButton(
                onPressed: () {},
                child: Text(
                  'عرض الكل',
                  style: TextStyle(
                    color: context.colors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              */
            ],
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 140,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            scrollDirection: Axis.horizontal,
            itemCount: recentOrders.length,
            separatorBuilder: (context, index) => SizedBox(width: AppSpacing.md),
            itemBuilder: (context, index) {
              final order = recentOrders[index];
              return _buildOrderCard(context, order);
            },
          ),
        ),
        SizedBox(height: AppSpacing.xxl),
      ],
    );
  }

  Widget _buildOrderCard(BuildContext context, FinishingOrderEntity order) {
    // Determine status color
    Color statusColor = context.colors.primary;
    if (order.status == 'completed') {
      statusColor = Colors.green;
    } else if (order.status == 'pending') {
      statusColor = Colors.orange;
    }

    return GestureDetector(
      onTap: () {
        // context.push('/my-units'); // Navigate to details if needed
      },
      child: Container(
        width: 260,
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: context.colors.white,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 20,
              spreadRadius: -5,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: context.colors.border.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Text(
                    order.statusLabel,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: AppFonts.labelSmall,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '#${order.id}',
                  style: TextStyle(
                    color: context.colors.textSecondary,
                    fontSize: AppFonts.labelSmall,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.orderTypeLabel,
                  style: TextStyle(
                    fontSize: AppFonts.bodyMedium,
                    fontWeight: FontWeight.bold,
                    color: context.colors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  'النمط: ${order.style.isEmpty ? 'غير محدد' : order.style}',
                  style: TextStyle(
                    fontSize: AppFonts.labelMedium,
                    color: context.colors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'التكلفة الإجمالية',
                  style: TextStyle(
                    fontSize: AppFonts.labelSmall,
                    color: context.colors.textSecondary,
                  ),
                ),
                Text(
                  '${order.totalCost.toStringAsFixed(0)} ج.م',
                  style: TextStyle(
                    fontSize: AppFonts.bodyLarge,
                    fontWeight: FontWeight.bold,
                    color: context.colors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
