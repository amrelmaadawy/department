import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../features/design_studio/presentation/cubit/design_context_cubit.dart';
import '../../../contracts/domain/entities/contract_type.dart';
import '../cubit/custom_finishing_state.dart';

class ContractsReviewScreen extends StatefulWidget {
  final CustomFinishingState finishingState;
  const ContractsReviewScreen({super.key, required this.finishingState});

  @override
  State<ContractsReviewScreen> createState() => _ContractsReviewScreenState();
}

class _ContractsReviewScreenState extends State<ContractsReviewScreen> {
  bool _isUnitContractSigned = false;
  bool _isFinishingContractSigned = false;

  @override
  Widget build(BuildContext context) {
    final unit = sl<DesignContextCubit>().state.selectedUnit;
    final totalCost = (unit?.price ?? 0.0) + widget.finishingState.totalEstimatedCost;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          'مراجعة وتوقيع العقود',
          style: TextStyle(
            fontSize: AppFonts.headlineMedium,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            FluentIcons.arrow_left_24_filled,
            color: AppColors.primary,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: [
          // Total Amount Header
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, Color(0xFF1A1A1A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            child: Column(
              children: [
                const Text(
                  'إجمالي التكلفة النهائية',
                  style: TextStyle(
                    fontSize: AppFonts.bodyMedium,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      totalCost
                          .toStringAsFixed(0)
                          .replaceAllMapped(
                            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                            (Match m) => '${m[1]},',
                          ),
                      style: const TextStyle(
                        fontSize: AppFonts.displayLarge,
                        fontWeight: FontWeight.w900,
                        color: AppColors.gold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'ر.س',
                      style: TextStyle(
                        fontSize: AppFonts.headlineMedium,
                        fontWeight: FontWeight.bold,
                        color: AppColors.gold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),

          // Contracts List
          const Text(
            'العقود المطلوبة للتوقيع',
            style: TextStyle(
              fontSize: AppFonts.headlineMedium,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          _buildContractCard(
            title: 'عقد بيع وحدة عقارية',
            subtitle: unit != null ? 'وحدة ${unit.title} بمساحة ${unit.area}م²' : 'تفاصيل الوحدة',
            isSigned: _isUnitContractSigned,
            onSign: () async {
              final result = await context.push(
                AppRouter.contractSigning,
                extra: {
                  'type': ContractType.unit,
                },
              );
              if (result == true) {
                setState(() => _isUnitContractSigned = true);
              }
            },
          ),
          const SizedBox(height: AppSpacing.md),
          _buildContractCard(
            title: 'عقد مقاولة تشطيب',
            subtitle: 'تشطيب مخصص شامل الخامات والمصنعية',
            isSigned: _isFinishingContractSigned,
            onSign: () async {
              final result = await context.push(
                AppRouter.contractSigning,
                extra: {
                  'type': ContractType.finishing,
                  'finishingTotal': widget.finishingState.totalEstimatedCost,
                },
              );
              if (result == true) {
                setState(() => _isFinishingContractSigned = true);
              }
            },
          ),

          const SizedBox(height: AppSpacing.xxxl),

          CustomButton(
            text: 'إتمام الحجز والدفع',
            onPressed: (!_isUnitContractSigned || !_isFinishingContractSigned)
                ? null
                : () {
                    // Proceed to success screen
                    context.pushReplacement('/booking-success', extra: 'ORD-UNIFIED-12345');
                  },
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Widget _buildContractCard({
    required String title,
    required String subtitle,
    required bool isSigned,
    required VoidCallback onSign,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: isSigned ? AppColors.success : AppColors.border,
          width: isSigned ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSigned
                  ? AppColors.success.withValues(alpha: 0.1)
                  : AppColors.primary.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isSigned ? FluentIcons.signature_24_filled : FluentIcons.document_24_regular,
              color: isSigned ? AppColors.success : AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: AppFonts.headlineSmall,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: AppFonts.bodyMedium,
                    color: AppColors.textPrimary.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          if (isSigned)
            const Icon(
              FluentIcons.checkmark_circle_24_filled,
              color: AppColors.success,
              size: 28,
            )
          else
            TextButton(
              onPressed: onSign,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.gold,
              ),
              child: const Text(
                'توقيع الآن',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppFonts.bodyLarge,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
