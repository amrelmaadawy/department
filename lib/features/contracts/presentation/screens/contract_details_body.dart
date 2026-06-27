import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/theme_extension.dart';

import '../../domain/entities/contract_entity.dart';
import 'contract_details_screen.dart' show ContractStatChip, formatContractDate;

/// Renders the full scrollable body of the contract details screen.
/// Split from ContractDetailsScreen to respect the 150-line file limit.
class ContractDetailsBody extends StatelessWidget {
  final ContractEntity contract;

  const ContractDetailsBody({super.key, required this.contract});

  bool get _isSigned => contract.status == 'signed';
  Color _accentColor(BuildContext context) =>
      _isSigned ? context.colors.success : context.colors.gold;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        _buildAppBar(context),
        SliverToBoxAdapter(child: _buildHeaderCard(context)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.sm,
            ),
            child: Text(
              'نص العقد',
              style: TextStyle(
                fontSize: AppFonts.headlineMedium,
                fontWeight: FontWeight.bold,
                color: context.colors.textPrimary,
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xxxl,
          ),
          sliver: SliverList.builder(
            itemCount: contract.contractBody.length,
            itemBuilder: (context, index) =>
                _buildBodyItem(context, contract.contractBody[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: context.colors.background,
      surfaceTintColor: Colors.transparent,
      iconTheme: IconThemeData(color: context.colors.textPrimary),
      pinned: true,
      centerTitle: true,
      title: Column(
        children: [
          Text(
            contract.contractNumber,
            style: TextStyle(
              fontSize: AppFonts.bodyMedium,
              fontWeight: FontWeight.bold,
              color: context.colors.textPrimary,
              letterSpacing: 0.5,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 2),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: _accentColor(context).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.round),
            ),
            child: Text(
              contract.statusLabel,
              style: TextStyle(
                fontSize: AppFonts.labelSmall,
                fontWeight: FontWeight.bold,
                color: _accentColor(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    final accent = _accentColor(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 0,
      ),
      decoration: BoxDecoration(
        color: context.colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border(right: BorderSide(color: accent, width: 4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              contract.typeLabel,
              style: TextStyle(
                fontSize: AppFonts.headlineSmall,
                fontWeight: FontWeight.bold,
                color: context.colors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: context.colors.background,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'إجمالي العقد',
                    style: TextStyle(
                      fontSize: AppFonts.bodyMedium,
                      color: context.colors.textSecondary,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        NumberFormat('#,##0.00').format(contract.totalAmount),
                        style: TextStyle(
                          fontSize: AppFonts.headlineMedium,
                          fontWeight: FontWeight.bold,
                          color: accent,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        'ر.س',
                        style: TextStyle(
                          fontSize: AppFonts.labelMedium,
                          color: context.colors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: ContractStatChip(
                    icon: Icons.calendar_today_outlined,
                    label: 'تاريخ العقد',
                    value: formatContractDate(contract.createdAt),
                  ),
                ),
                Expanded(
                  child: ContractStatChip(
                    icon: Icons.timelapse_rounded,
                    label: 'مدة التنفيذ',
                    value: '${contract.executionDuration} شهر',
                  ),
                ),
                if (contract.signedAt != null)
                  Expanded(
                    child: ContractStatChip(
                      icon: Icons.verified_rounded,
                      label: 'تاريخ التوقيع',
                      value: formatContractDate(contract.signedAt!),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyItem(BuildContext context, ContractBodyItemEntity item) {
    switch (item.type) {
      case 'title':
        return _ContractTitleItem(content: item.content ?? '');
      case 'paragraph':
        return _ContractParagraphItem(content: item.content ?? '');
      case 'list':
        return _ContractListGroup(items: item.items ?? []);
      case 'table':
        if (item.data != null) return _ContractTableItem(data: item.data!);
        return const SizedBox.shrink();
      default:
        return const SizedBox.shrink();
    }
  }
}

// ─── Body Item Widgets ──────────────────────────────────────────────────────

class _ContractTitleItem extends StatelessWidget {
  final String content;
  const _ContractTitleItem({required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.lg, bottom: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            content,
            style: TextStyle(
              fontSize: AppFonts.bodyLarge,
              fontWeight: FontWeight.bold,
              color: context.colors.gold,
              height: 1.6,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Container(
            height: 2,
            width: 40,
            decoration: BoxDecoration(
              color: context.colors.gold.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(AppRadius.round),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContractParagraphItem extends StatelessWidget {
  final String content;
  const _ContractParagraphItem({required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Text(
        content,
        style: TextStyle(
          fontSize: AppFonts.bodyMedium,
          color: context.colors.textPrimary,
          height: 1.9,
        ),
        textAlign: TextAlign.justify,
      ),
    );
  }
}

class _ContractListGroup extends StatelessWidget {
  final List<ContractListItemEntity> items;
  const _ContractListGroup({required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map((item) {
          final isBullet = item.type == 'list_item';
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isBullet)
                  Padding(
                    padding: const EdgeInsets.only(top: 6, left: AppSpacing.sm),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: context.colors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: isBullet ? AppSpacing.sm : 0),
                    child: Text(
                      item.content,
                      style: TextStyle(
                        fontSize: AppFonts.bodyMedium,
                        color: isBullet
                            ? context.colors.textPrimary
                            : context.colors.textSecondary,
                        height: 1.7,
                        fontStyle: isBullet ? FontStyle.normal : FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ContractTableItem extends StatelessWidget {
  final ContractTableDataEntity data;
  const _ContractTableItem({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: context.colors.border.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          children: [
            // Headers row
            Container(
              decoration: BoxDecoration(
                color: context.colors.primary.withValues(alpha: 0.08),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadius.lg),
                ),
              ),
              child: Row(
                children: data.headers.map((header) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.sm,
                        horizontal: AppSpacing.xs,
                      ),
                      child: Text(
                        header,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: AppFonts.labelSmall,
                          fontWeight: FontWeight.bold,
                          color: context.colors.primary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            // Data rows
            ...data.rows.asMap().entries.map((entry) {
              final isEven = entry.key.isEven;
              return Container(
                color: isEven
                    ? Colors.transparent
                    : context.colors.background.withValues(alpha: 0.5),
                child: Row(
                  children: entry.value.map((cell) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.sm,
                          horizontal: AppSpacing.xs,
                        ),
                        child: Text(
                          cell,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: AppFonts.labelMedium,
                            color: context.colors.textPrimary,
                            height: 1.4,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            }),
            // Divider before footer
            Divider(
              height: 1,
              thickness: 1,
              color: context.colors.border.withValues(alpha: 0.3),
            ),
            // Footer rows
            ...data.footer.map((footerItem) {
              return Container(
                color: context.colors.gold.withValues(alpha: 0.06),
                child: Row(
                  children: [
                    Expanded(
                      flex: footerItem.colspan,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.sm,
                          horizontal: AppSpacing.xs,
                        ),
                        child: Text(
                          footerItem.content,
                          textAlign: footerItem.colspan > 1
                              ? TextAlign.right
                              : TextAlign.center,
                          style: TextStyle(
                            fontSize: AppFonts.labelMedium,
                            fontWeight: FontWeight.bold,
                            color: footerItem.colspan == 1
                                ? context.colors.gold
                                : context.colors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
