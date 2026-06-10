import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/routes/app_router.dart';
import 'package:apartment/core/widgets/app_toast.dart';
import 'package:apartment/l10n/app_localizations.dart';
import '../../cubit/custom_finishing_cubit.dart';
import '../../cubit/custom_finishing_state.dart';
import 'package:apartment/core/theme/theme_extension.dart';

import 'cost_breakdown_card.dart';

class CustomFinishingReviewView extends StatelessWidget {
  const CustomFinishingReviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<CustomFinishingCubit, CustomFinishingState>(
      listenWhen: (previous, current) =>
          previous.bookingStatus != current.bookingStatus,
      listener: (context, state) {
        if (state.bookingStatus == BookingStatus.success) {
          context.go(AppRouter.bookingSuccess);
        } else if (state.bookingStatus == BookingStatus.failure) {
          AppToast.show(
            context,
            message: 'حدث خطأ أثناء التأكيد، يرجى المحاولة مرة أخرى.',
            isError: true,
          );
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Text(
                'مراجعة التخصيص النهائي', // Hardcoded since not in l10n yet
                style: TextStyle(
                  fontSize: AppFonts.displaySmall,
                  fontWeight: FontWeight.w900,
                  color: context.colors.primary,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                'راجع اختياراتك وتأكد من تفاصيل التكلفة قبل اعتماد العقود لضمان مطابقة التنفيذ لرغباتك.',
                style: TextStyle(
                  fontSize: AppFonts.bodyLarge,
                  color: context.colors.textPrimary.withValues(alpha: 0.6),
                  height: 1.5,
                ),
              ),

              SizedBox(height: AppSpacing.xxxl),

              // Breakdown Card
              CostBreakdownCard(state: state),

              SizedBox(height: AppSpacing.xxxl),

              // Action Buttons
              Row(
                children: [
                  // Back Button (Secondary)
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      onPressed: state.bookingStatus ==
                              BookingStatus.loading
                          ? null
                          : () {
                              // If there was a previous category, we could go back.
                              // For now, pop if possible
                              if (context.canPop()) {
                                context.pop();
                              }
                            },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        side: BorderSide(
                          color: context.colors.primary.withValues(alpha: 0.2),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.xl),
                        ),
                      ),
                      child: Icon(
                        FluentIcons.arrow_right_24_regular,
                        color: context.colors.primary,
                      ),
                    ),
                  ),

                  SizedBox(width: AppSpacing.md),

                  // Confirm Button (Primary)
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [context.colors.gold, Color(0xFFC99B40)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                        boxShadow: [
                          BoxShadow(
                            color: context.colors.gold.withValues(alpha: 0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(AppRadius.xl),
                          onTap: state.bookingStatus ==
                                  BookingStatus.loading
                              ? null
                              : () {
                                  context
                                      .read<CustomFinishingCubit>()
                                      .confirmBooking();
                                },
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: state.bookingStatus ==
                                      BookingStatus.loading
                                  ? [
                                      SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    ]
                                  : [
                                      Text(
                                        'تأكيد واستخراج العقود',
                                        style: TextStyle(
                                          fontSize: AppFonts.headlineSmall,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: AppSpacing.sm),
                                      Icon(
                                        FluentIcons.checkmark_24_filled,
                                        color: Colors.white,
                                      ),
                                    ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: AppSpacing.xl),
              
              // Helper text
              Text(
                'بالضغط على زر التأكيد، سيتم إنشاء مسودة العقد النهائي للمراجعة النهائية قبل التوقيع.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppFonts.labelLarge,
                  color: context.colors.textPrimary.withValues(alpha: 0.5),
                  height: 1.5,
                ),
              ),
              
              SizedBox(height: AppSpacing.xxl),
            ],
          ),
        );
      },
    );
  }
}
