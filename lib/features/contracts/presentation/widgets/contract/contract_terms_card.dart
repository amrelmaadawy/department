import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:apartment/core/theme/app_colors.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/l10n/app_localizations.dart';

import '../../../domain/entities/contract_type.dart';

class ContractTermsCard extends StatelessWidget {
  final ContractType contractType;
  final bool isAgreed;
  final ValueChanged<bool?> onChanged;

  const ContractTermsCard({
    super.key,
    required this.contractType,
    required this.isAgreed,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: AppColors.border.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(FluentIcons.document_text_24_regular, color: AppColors.primary),
              const SizedBox(width: AppSpacing.sm),
              Text(
                l10n.contractTermsTitle,
                style: const TextStyle(
                  fontSize: AppFonts.headlineSmall,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(color: AppColors.background),
          const SizedBox(height: AppSpacing.md),
          
          Container(
            height: 150,
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: SingleChildScrollView(
              child: Text(
                contractType == ContractType.unit 
                ? '''1. الحجز المبدئي يخضع للموافقة النهائية من قبل المطور.
2. الأسعار المذكورة هي تقديرات أولية وقد تتغير بناءً على القياسات النهائية.
3. عربون الحجز غير مسترد بعد مرور 14 يومًا من هذا الاتفاق.
4. يلتزم المشتري باستكمال الدفعة المقدمة خلال الجدول الزمني المحدد.
5. تعتبر جميع المخططات والمواصفات المرفقة جزءًا لا يتجزأ من هذا العقد.
... [المزيد من البنود القانونية]'''
                : '''1. يتعهد المقاول بتنفيذ أعمال التشطيب وفقاً للمواصفات المعتمدة.
2. الأسعار المذكورة تشمل توريد الخامات والمصنعية معاً.
3. يلتزم العميل بدفع الدفعات المالية حسب نسب الإنجاز المتفق عليها.
4. يضمن المقاول جودة الأعمال المنفذة لمدة عام كامل من تاريخ الاستلام.
5. أي تعديلات على التصميم بعد بدء التنفيذ تخضع لتسعير منفصل.
... [المزيد من البنود القانونية]''',
                style: const TextStyle(
                  fontSize: AppFonts.bodySmall,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: AppSpacing.md),
          
          Row(
            children: [
              Checkbox(
                value: isAgreed,
                onChanged: onChanged,
                activeColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(!isAgreed),
                  child: Text(
                    l10n.iAgreeToTerms,
                    style: TextStyle(
                      fontSize: AppFonts.bodyMedium,
                      fontWeight: FontWeight.bold,
                      color: isAgreed ? AppColors.primary : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
