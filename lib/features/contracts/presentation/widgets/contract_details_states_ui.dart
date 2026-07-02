import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/contracts_cubit.dart';

class ContractDetailsShimmerView extends StatelessWidget {
  const ContractDetailsShimmerView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: context.colors.background,
          iconTheme: IconThemeData(color: context.colors.textPrimary),
          pinned: true,
        ),
        SliverPadding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          sliver: SliverList.separated(
            itemCount: 6,
            separatorBuilder: (_, i) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, i) => Shimmer.fromColors(
              baseColor: context.colors.border.withValues(alpha: 0.3),
              highlightColor: context.colors.border.withValues(alpha: 0.08),
              child: Container(
                height: i == 0 ? 130 : 60,
                decoration: BoxDecoration(
                  color: context.colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ContractDetailsErrorView extends StatelessWidget {
  final String message;

  const ContractDetailsErrorView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: context.colors.error.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.cloud_off_rounded, size: 56, color: context.colors.error),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'تعذر تحميل العقد',
              style: TextStyle(
                fontSize: AppFonts.headlineSmall,
                fontWeight: FontWeight.bold,
                color: context.colors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: context.colors.textSecondary, fontSize: AppFonts.bodyMedium),
            ),
            const SizedBox(height: AppSpacing.xl),
            ElevatedButton.icon(
              onPressed: () => context.read<ContractsCubit>().loadContractDetails(0),
              icon: Icon(Icons.refresh_rounded, color: context.colors.white),
              label: Text(
                AppLocalizations.of(context)!.retryLoad,
                style: TextStyle(fontFamily: 'Cairo', color: context.colors.white, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.round)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
