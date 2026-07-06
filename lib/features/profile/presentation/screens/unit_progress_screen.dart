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
                  const SizedBox(height: AppSpacing.sm),
                  _buildDetailCard(context, 'الحالة', order!.statusLabel),
                  const SizedBox(height: AppSpacing.sm),
                  _buildDetailCard(context, 'نوع الطلب', order!.orderTypeLabel),
                  const SizedBox(height: AppSpacing.sm),
                  _buildDetailCard(context, 'حالة التصميم (AI)', order!.aiStatusLabel),
                  const SizedBox(height: AppSpacing.sm),
                  _buildDetailCard(context, 'إجمالي التكلفة', '${order!.totalCost.toStringAsFixed(0)} ج.م'),
                  if (order!.paidAmount != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    _buildDetailCard(context, 'المدفوع', '${order!.paidAmount!.toStringAsFixed(0)} ج.م'),
                  ],
                  if (order!.remainingAmount != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    _buildDetailCard(context, 'المتبقي', '${order!.remainingAmount!.toStringAsFixed(0)} ج.م'),
                  ],
                  if (order!.progressPercentage != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    _buildDetailCard(context, 'نسبة الإنجاز', '${order!.progressPercentage}%'),
                  ],
                  const SizedBox(height: AppSpacing.sm),
                  _buildDetailCard(context, 'تاريخ الطلب', _formatDate(order!.createdAt)),
                  if (order!.style.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.sm),
                    _buildDetailCard(context, 'النمط المختار', order!.style),
                  ],
                  if (order!.notes.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.sm),
                    _buildDetailCard(context, 'ملاحظات', order!.notes),
                  ],
                  if (order!.rooms.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'التشطيبات والغرف',
                      style: TextStyle(
                        color: context.colors.textPrimary,
                        fontSize: AppFonts.headlineSmall,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ...order!.rooms.map((room) {
                      if (room is Map) {
                        return _buildGroupedRoomCard(context, room);
                      }
                      return const SizedBox.shrink();
                    }),
                  ],
                  if (order!.rooms.isEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      color: Colors.red.withValues(alpha: 0.1),
                      child: Text(
                        'مطور الباك إند: لم يتم العثور على أي تفاصيل بداخل cost_breakdown أو غرف في الـ API. المفاتيح المتاحة هي:\n${order!.rawJson.keys.join(', ')}',
                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildGroupedRoomCard(BuildContext context, Map<dynamic, dynamic> room) {
    final String roomName = room['room_name']?.toString() ?? 'غرفة';
    final String roomTotal = room['room_total']?.toString() ?? '';
    final List<dynamic> materials = room['materials'] as List<dynamic>? ?? [];
    final List<String> images = (room['images'] as List<dynamic>? ?? []).map((e) => e.toString()).toList();

    if (materials.isEmpty && images.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: context.colors.border.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Room Header
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: context.colors.primary.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
              border: Border(bottom: BorderSide(color: context.colors.border.withValues(alpha: 0.3))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(FluentIcons.conference_room_24_filled, color: context.colors.primary),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      roomName,
                      style: TextStyle(
                        color: context.colors.textPrimary,
                        fontSize: AppFonts.headlineSmall,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                if (roomTotal.isNotEmpty && roomTotal != 'null')
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: context.colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.round),
                      border: Border.all(color: context.colors.border.withValues(alpha: 0.5)),
                    ),
                    child: Text(
                      '$roomTotal ج.م',
                      style: TextStyle(
                        color: context.colors.primary,
                        fontSize: AppFonts.bodySmall,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Room Materials
          if (materials.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الخامات المختارة:',
                    style: TextStyle(
                      color: context.colors.textSecondary,
                      fontSize: AppFonts.bodyMedium,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  _buildMaterialsList(context, materials),
                ],
              ),
            ),

          // Room Images
          if (images.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.xs, AppSpacing.md, AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'صور التصميم:',
                    style: TextStyle(
                      color: context.colors.textSecondary,
                      fontSize: AppFonts.bodyMedium,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _buildImageGallery(context, images),
                ],
              ),
            ),
        ],
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
          final String imageUrl = item['image']?.toString() ?? item['image_url']?.toString() ?? item['url']?.toString() ?? '';
          
          return Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            decoration: BoxDecoration(
              color: context.colors.white,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: context.colors.border.withValues(alpha: 0.3)),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 4),
              minLeadingWidth: 48,
              leading: imageUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      child: Image.network(
                        imageUrl,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(FluentIcons.toolbox_24_regular, color: context.colors.primary, size: 28),
                      ),
                    )
                  : Icon(FluentIcons.toolbox_24_regular, color: context.colors.primary, size: 28),
              title: Text(
                name,
                style: TextStyle(
                  color: context.colors.textPrimary,
                  fontSize: AppFonts.bodyMedium,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: category.isNotEmpty
                  ? Text(
                      category,
                      style: TextStyle(
                        color: context.colors.textSecondary,
                        fontSize: AppFonts.labelSmall,
                      ),
                    )
                  : null,
              trailing: price.isNotEmpty
                  ? Text(
                      '$price ج.م',
                      style: TextStyle(
                        color: context.colors.primary,
                        fontSize: AppFonts.bodyMedium,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
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
