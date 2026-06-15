import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_toast.dart';
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
        if (order.status == 'completed') {
          _showCompletedOrderDetails(context, order);
        } else {
          AppToast.show(
            context,
            message: 'طلبك لا يزال قيد التنفيذ. سنقوم بإشعارك فور الانتهاء.',
            isError: false,
          );
        }
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
                SizedBox(height: 2),
                if (order.projectName.isNotEmpty)
                  Text(
                    '${order.projectName} - ${order.unitName.isNotEmpty ? order.unitName : "غير محدد"}',
                    style: TextStyle(
                      fontSize: AppFonts.labelMedium,
                      color: context.colors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                SizedBox(height: 2),
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

  void _showCompletedOrderDetails(BuildContext context, FinishingOrderEntity order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: context.colors.background,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
          ),
          child: Column(
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
                      'تفاصيل التصميم',
                      style: TextStyle(
                        fontSize: AppFonts.headlineSmall,
                        fontWeight: FontWeight.bold,
                        color: context.colors.textPrimary,
                      ),
                    ),
                    IconButton(
                      icon: Icon(FluentIcons.dismiss_24_regular, color: context.colors.textSecondary),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image Viewer
                      Container(
                        height: 300,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppRadius.xl),
                          color: context.colors.border.withValues(alpha: 0.1),
                          image: order.imageUrl.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(order.imageUrl),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: order.imageUrl.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(FluentIcons.image_24_regular, size: 48, color: context.colors.textSecondary.withValues(alpha: 0.5)),
                                    const SizedBox(height: AppSpacing.sm),
                                    Text('الصورة غير متوفرة', style: TextStyle(color: context.colors.textSecondary)),
                                  ],
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(height: AppSpacing.xxl),

                      // Details Card
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: context.colors.white,
                          borderRadius: BorderRadius.circular(AppRadius.xl),
                          border: Border.all(color: context.colors.border.withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          children: [
                            _buildDetailRow(context, 'رقم الطلب', '#${order.id}'),
                            const Divider(height: AppSpacing.xl),
                            _buildDetailRow(context, 'المشروع', order.projectName.isNotEmpty ? order.projectName : 'غير محدد'),
                            const Divider(height: AppSpacing.xl),
                            _buildDetailRow(context, 'الوحدة', order.unitName.isNotEmpty ? order.unitName : 'غير محدد'),
                            const Divider(height: AppSpacing.xl),
                            _buildDetailRow(context, 'النمط', order.style.isNotEmpty ? order.style : 'غير محدد'),
                            const Divider(height: AppSpacing.xl),
                            _buildDetailRow(context, 'التكلفة الإجمالية', '${order.totalCost.toStringAsFixed(0)} ج.م', isPrimary: true),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxxl),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value, {bool isPrimary = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: AppFonts.bodyMedium,
            color: context.colors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isPrimary ? AppFonts.bodyLarge : AppFonts.bodyMedium,
            fontWeight: FontWeight.bold,
            color: isPrimary ? context.colors.primary : context.colors.textPrimary,
          ),
        ),
      ],
    );
  }
}
