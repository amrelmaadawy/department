import 'package:flutter/material.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_fonts.dart';
import 'package:apartment/core/theme/theme_extension.dart';

import 'package:apartment/features/projects/domain/entities/finishing_order_entity.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/app_radius.dart';

import 'package:intl/intl.dart';

class UnitProgressScreen extends StatelessWidget {
  final FinishingOrderEntity? order;

  const UnitProgressScreen({super.key, this.order});

  String _formatDate(String isoString) {
    if (isoString.isEmpty) return 'غير متوفر';
    try {
      final date = DateTime.parse(isoString);
      return DateFormat('d MMMM yyyy', 'ar').format(date);
    } catch (e) {
      return isoString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.white,
        elevation: 0,
        scrolledUnderElevation: 0.0,
        title: Text(
          l10n.finishingProgressTitle,
          style: TextStyle(
            color: context.colors.textPrimary,
            fontSize: AppFonts.headlineSmall,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(FluentIcons.ios_arrow_rtl_24_regular, color: context.colors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: order == null
          ? Center(
              child: Text(
                'لا يوجد طلب تشطيب لهذه الوحدة.',
                style: TextStyle(
                  color: context.colors.textSecondary,
                  fontSize: AppFonts.bodyLarge,
                ),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildDetailCard(context, 'رقم الطلب', '#${order!.id}'),
                  const SizedBox(height: AppSpacing.md),
                  _buildDetailCard(context, 'الحالة', order!.statusLabel),
                  const SizedBox(height: AppSpacing.md),
                  _buildDetailCard(context, 'نوع الطلب', order!.orderTypeLabel),
                  const SizedBox(height: AppSpacing.md),
                  _buildDetailCard(context, 'حالة التصميم (AI)', order!.aiStatusLabel),
                  const SizedBox(height: AppSpacing.md),
                  _buildDetailCard(context, 'إجمالي التكلفة', '${order!.totalCost.toStringAsFixed(0)} ج.م'),
                  if (order!.paidAmount != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    _buildDetailCard(context, 'المدفوع', '${order!.paidAmount!.toStringAsFixed(0)} ج.م'),
                  ],
                  if (order!.remainingAmount != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    _buildDetailCard(context, 'المتبقي', '${order!.remainingAmount!.toStringAsFixed(0)} ج.م'),
                  ],
                  if (order!.progressPercentage != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    _buildDetailCard(context, 'نسبة الإنجاز', '${order!.progressPercentage}%'),
                  ],
                  const SizedBox(height: AppSpacing.md),
                  _buildDetailCard(context, 'تاريخ الطلب', _formatDate(order!.createdAt)),
                  if (order!.style.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    _buildDetailCard(context, 'النمط المختار', order!.style),
                  ],
                  if (order!.notes.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    _buildDetailCard(context, 'ملاحظات', order!.notes),
                  ],
                  if (order!.materials.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      'الخامات المختارة',
                      style: TextStyle(
                        color: context.colors.textPrimary,
                        fontSize: AppFonts.headlineSmall,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildMaterialsList(context, order!.materials),
                  ],
                  if (order!.rooms.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      'الغرف',
                      style: TextStyle(
                        color: context.colors.textPrimary,
                        fontSize: AppFonts.headlineSmall,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildMaterialsList(context, order!.rooms), // Use same layout for rooms for now
                  ],
                  if (order!.materials.isEmpty && order!.rooms.isEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      color: Colors.red.withValues(alpha: 0.1),
                      child: Text(
                        'مطور الباك إند: لم يتم العثور على مصفوفة materials أو rooms أو items في الـ API. المفاتيح المتاحة هي:\n${order!.rawJson.keys.join(', ')}',
                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  if (order!.images.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      'صور التشطيبات',
                      style: TextStyle(
                        color: context.colors.textPrimary,
                        fontSize: AppFonts.headlineSmall,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildImageGallery(context, order!.images),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildMaterialsList(BuildContext context, List<dynamic> materials) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: materials.map((item) {
        if (item is Map) {
          final String name = item['name']?.toString() ?? item['title']?.toString() ?? item['item']?.toString() ?? item['material_name']?.toString() ?? item['description']?.toString() ?? 'عنصر تشطيب (مفاتيح: ${item.keys.join(', ')})';
          final String category = item['category']?.toString() ?? item['type']?.toString() ?? item['subtype']?.toString() ?? item['room']?.toString() ?? '';
          final String price = item['price']?.toString() ?? item['cost']?.toString() ?? item['amount']?.toString() ?? item['final_price']?.toString() ?? item['total_price']?.toString() ?? '';
          
          return Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: context.colors.white,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: context.colors.border.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(FluentIcons.toolbox_24_regular, color: context.colors.primary, size: 24),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          color: context.colors.textPrimary,
                          fontSize: AppFonts.bodyMedium,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (category.isNotEmpty)
                        Text(
                          category,
                          style: TextStyle(
                            color: context.colors.textSecondary,
                            fontSize: AppFonts.labelSmall,
                          ),
                        ),
                    ],
                  ),
                ),
                if (price.isNotEmpty)
                  Flexible(
                    flex: 1,
                    child: Text(
                      '$price ج.م',
                      style: TextStyle(
                        color: context.colors.primary,
                        fontSize: AppFonts.bodyMedium,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                    ),
                  ),
              ],
            ),
          );
        } else if (item is String) {
          return Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: context.colors.white,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: context.colors.border.withValues(alpha: 0.3)),
            ),
            child: Text(
              item,
              style: TextStyle(
                color: context.colors.textPrimary,
                fontSize: AppFonts.bodyMedium,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      }).toList(),
    );
  }

  Widget _buildImageGallery(BuildContext context, List<String> images) {
    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final imageUrl = images[index];
          return ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: Container(
              width: 140,
              height: 140,
              color: context.colors.border.withValues(alpha: 0.2),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(
                  FluentIcons.image_off_24_regular,
                  color: context.colors.textSecondary,
                  size: 32,
                ),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      color: context.colors.primary,
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
  }
  Widget _buildDetailCard(BuildContext context, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: context.colors.border.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: context.colors.textSecondary,
              fontSize: AppFonts.bodyMedium,
              fontWeight: FontWeight.bold,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                color: context.colors.textPrimary,
                fontSize: AppFonts.bodyMedium,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
