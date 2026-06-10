import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../features/design_studio/presentation/cubit/design_context_cubit.dart';
import '../../../contracts/domain/entities/contract_type.dart';
import '../cubit/custom_finishing_state.dart';
import 'package:apartment/core/theme/theme_extension.dart';


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
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.white,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          'مراجعة وتوقيع العقود',
          style: TextStyle(
            fontSize: AppFonts.headlineMedium,
            fontWeight: FontWeight.bold,
            color: context.colors.primary,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            FluentIcons.arrow_left_24_filled,
            color: context.colors.primary,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.xl),
        children: [
          // Total Amount Header
          Container(
            padding: EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [context.colors.primary, Color(0xFF1A1A1A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            child: Column(
              children: [
                Text(
                  'إجمالي التكلفة النهائية',
                  style: TextStyle(
                    fontSize: AppFonts.bodyMedium,
                    color: context.colors.textSecondary,
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
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
                      style: TextStyle(
                        fontSize: AppFonts.displayLarge,
                        fontWeight: FontWeight.w900,
                        color: context.colors.gold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'ر.س',
                      style: TextStyle(
                        fontSize: AppFonts.headlineMedium,
                        fontWeight: FontWeight.bold,
                        color: context.colors.gold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.xxl),

          // Contracts List
          Text(
            'العقود المطلوبة للتوقيع',
            style: TextStyle(
              fontSize: AppFonts.headlineMedium,
              fontWeight: FontWeight.bold,
              color: context.colors.primary,
            ),
          ),
          SizedBox(height: AppSpacing.lg),

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
          SizedBox(height: AppSpacing.md),
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

          SizedBox(height: AppSpacing.xxxl),

          CustomButton(
            text: 'إتمام الحجز والدفع',
            onPressed: (!_isUnitContractSigned || !_isFinishingContractSigned)
                ? null
                : () {
                    // Proceed to success screen
                    context.pushReplacement('/booking-success', extra: 'ORD-UNIFIED-12345');
                  },
          ),
          SizedBox(height: AppSpacing.xxl),
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
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: isSigned ? context.colors.success : context.colors.border,
          width: isSigned ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSigned
                  ? context.colors.success.withValues(alpha: 0.1)
                  : context.colors.primary.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isSigned ? FluentIcons.signature_24_filled : FluentIcons.document_24_regular,
              color: isSigned ? context.colors.success : context.colors.primary,
              size: 24,
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppFonts.headlineSmall,
                    fontWeight: FontWeight.bold,
                    color: context.colors.textPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: AppFonts.bodyMedium,
                    color: context.colors.textPrimary.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          if (isSigned)
            Icon(
              FluentIcons.checkmark_circle_24_filled,
              color: context.colors.success,
              size: 28,
            )
          else
            TextButton(
              onPressed: onSign,
              style: TextButton.styleFrom(
                foregroundColor: context.colors.gold,
              ),
              child: Text(
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
