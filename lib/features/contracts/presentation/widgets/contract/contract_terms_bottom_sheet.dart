import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/contract_type.dart';
import '../../../domain/entities/contract_entity.dart';

class ContractTermsBottomSheet extends StatelessWidget {
  final ContractType contractType;
  final ContractEntity? contract;
  final bool isAgreed;
  final ValueChanged<bool> onAgreed;

  const ContractTermsBottomSheet({
    super.key,
    required this.contractType,
    this.contract,
    required this.isAgreed,
    required this.onAgreed,
  });

  static Future<void> show(
    BuildContext context, {
    required ContractType contractType,
    ContractEntity? contract,
    required bool isAgreed,
    required ValueChanged<bool> onAgreed,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ContractTermsBottomSheet(
        contractType: contractType,
        contract: contract,
        isAgreed: isAgreed,
        onAgreed: onAgreed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final hasBody = contract != null && contract!.contractBody.isNotEmpty;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: context.colors.border,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    l10n.legalTerms,
                    style: TextStyle(
                      fontSize: AppFonts.headlineMedium,
                      fontWeight: FontWeight.bold,
                      color: context.colors.textPrimary,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => context.pop(),
                  icon: Icon(FluentIcons.dismiss_24_regular, color: context.colors.textSecondary),
                ),
              ],
            ),
          ),
          const Divider(),
          
          // Terms List
          Expanded(
            child: hasBody 
                ? _buildContractBody(context, contract!.contractBody)
                : _buildFallbackTerms(context),
          ),
          
          // Bottom Actions
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: context.colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: ElevatedButton.icon(
                onPressed: () {
                  onAgreed(true);
                  context.pop();
                },
                icon: const Icon(FluentIcons.checkmark_24_regular),
                label: Text(l10n.agreeToTerms),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.primary,
                  foregroundColor: context.colors.white,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContractBody(BuildContext context, List<ContractBodyItemEntity> body) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
      physics: const BouncingScrollPhysics(),
      itemCount: body.length,
      separatorBuilder: (context, index) {
        final nextType = index < body.length - 1 ? body[index + 1].type : '';
        // Add more space before a new heading
        if (nextType == 'heading') {
          return const SizedBox(height: AppSpacing.xxl);
        }
        // Normal spacing between paragraphs and lists
        return const SizedBox(height: AppSpacing.md);
      },
      itemBuilder: (context, index) {
        final item = body[index];
        switch (item.type) {
          case 'heading':
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
              decoration: BoxDecoration(
                color: context.colors.primary.withValues(alpha: 0.05),
                border: BorderDirectional(
                  start: BorderSide(
                    color: context.colors.primary,
                    width: 4,
                  ),
                ),
              ),
              child: Text(
                item.content ?? '',
                style: TextStyle(
                  fontSize: AppFonts.headlineSmall,
                  fontWeight: FontWeight.bold,
                  color: context.colors.primary,
                ),
              ),
            );
          case 'paragraph':
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: Text(
                item.content ?? '',
                style: TextStyle(
                  fontSize: AppFonts.bodyLarge,
                  color: context.colors.textPrimary,
                  height: 1.8,
                ),
                textAlign: TextAlign.justify,
              ),
            );
          case 'list':
            if (item.items == null || item.items!.isEmpty) return const SizedBox();
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: item.items!.map((listItem) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                          child: Icon(
                            FluentIcons.square_12_regular,
                            size: 10,
                            color: context.colors.primary,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            listItem.content,
                            style: TextStyle(
                              fontSize: AppFonts.bodyLarge,
                              color: context.colors.textSecondary,
                              height: 1.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          case 'table':
            if (item.data == null) return const SizedBox();
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: _buildTable(context, item.data!),
            );
          default:
            if (item.content != null) {
              return Text(
                item.content!,
                style: TextStyle(
                  fontSize: AppFonts.bodyLarge,
                  color: context.colors.textSecondary,
                  height: 1.8,
                ),
              );
            }
            return const SizedBox();
        }
      },
    );
  }

  Widget _buildTable(BuildContext context, ContractTableDataEntity tableData) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: context.colors.border),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        children: [
          // Headers
          if (tableData.headers.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                color: context.colors.background,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.md)),
              ),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: tableData.headers.asMap().entries.map((entry) {
                    final isLast = entry.key == tableData.headers.length - 1;
                    return Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: isLast ? null : Border(left: BorderSide(color: context.colors.border)),
                        ),
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        child: Text(
                          entry.value,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: context.colors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          
          // Rows
          ...tableData.rows.map((row) {
            return Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: context.colors.border)),
              ),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: row.asMap().entries.map((entry) {
                    final isLast = entry.key == row.length - 1;
                    return Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: isLast ? null : Border(left: BorderSide(color: context.colors.border)),
                        ),
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        child: Text(
                          entry.value,
                          style: TextStyle(color: context.colors.textSecondary),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          }),
          
          // Footer
          if (tableData.footer.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                color: context.colors.background,
                border: Border(top: BorderSide(color: context.colors.border)),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(AppRadius.md)),
              ),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: tableData.footer.asMap().entries.map((entry) {
                    final isLast = entry.key == tableData.footer.length - 1;
                    return Expanded(
                      flex: entry.value.colspan > 0 ? entry.value.colspan : 1,
                      child: Container(
                        decoration: BoxDecoration(
                          border: isLast ? null : Border(left: BorderSide(color: context.colors.border)),
                        ),
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        child: Text(
                          entry.value.content,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: context.colors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFallbackTerms(BuildContext context) {
    final terms = [
      'يقر الطرفان بصحة البيانات المدونة في هذا العقد.',
      'يلتزم الطرف الثاني بسداد الدفعات في المواعيد المحددة.',
      'يحق للطرف الأول فسخ العقد في حالة إخلال الطرف الثاني بأي من البنود.',
      'يخضع هذا العقد لأنظمة وقوانين المملكة العربية السعودية.',
    ];
    
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.xl),
      physics: const BouncingScrollPhysics(),
      itemCount: terms.length,
      separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: context.colors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                FluentIcons.checkmark_12_filled,
                size: 12,
                color: context.colors.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                terms[index],
                style: TextStyle(
                  fontSize: AppFonts.bodyLarge,
                  color: context.colors.textSecondary,
                  height: 1.5,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
