import 'package:apartment/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/di/injection_container.dart';
import 'package:apartment/core/routes/app_router.dart';
import 'package:apartment/l10n/app_localizations.dart';

import '../../../contracts/domain/entities/contract_entity.dart';
import '../../../contracts/domain/entities/contract_type.dart';
import '../cubit/my_contracts_cubit.dart';
import '../cubit/my_contracts_state.dart';

class ProfileContractsScreen extends StatelessWidget {
  const ProfileContractsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MyContractsCubit>()..fetchContracts(),
      child: const _ProfileContractsView(),
    );
  }
}

class _ProfileContractsView extends StatelessWidget {
  const _ProfileContractsView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: context.colors.background,
      body: BlocBuilder<MyContractsCubit, MyContractsState>(
        builder: (context, state) {
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(context, l10n, state),
              if (state is MyContractsLoaded && state.contracts.isNotEmpty)
                _buildStatsHeader(context, state.contracts),
              _buildBody(context, state, l10n),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, AppLocalizations l10n, MyContractsState state) {
    return SliverAppBar(
      backgroundColor: context.colors.background,
      surfaceTintColor: AppColors.transparent,
      elevation: 0,
      pinned: true,
      centerTitle: true,
      iconTheme: IconThemeData(color: context.colors.textPrimary),
      title: Text(
        l10n.myContracts,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: AppFonts.headlineSmall,
          color: context.colors.textPrimary,
        ),
      ),
      actions: [
        if (state is MyContractsLoaded)
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.md),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: context.colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.round),
                ),
                child: Text(
                  '${state.contracts.length}',
                  style: TextStyle(
                    fontSize: AppFonts.labelMedium,
                    fontWeight: FontWeight.bold,
                    color: context.colors.primary,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStatsHeader(BuildContext context, List<ContractEntity> contracts) {
    final signed = contracts.where((c) => c.status == 'signed').length;
    final pending = contracts.length - signed;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.md,
        ),
        child: Row(
          children: [
            _StatChip(
              label: 'الكل',
              value: '${contracts.length}',
              color: context.colors.primary,
            ),
            const SizedBox(width: AppSpacing.sm),
            _StatChip(
              label: 'موقعة',
              value: '$signed',
              color: context.colors.success,
            ),
            const SizedBox(width: AppSpacing.sm),
            _StatChip(
              label: 'منتظرة',
              value: '$pending',
              color: context.colors.gold,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, MyContractsState state, AppLocalizations l10n) {
    if (state is MyContractsLoading || state is MyContractsInitial) {
      return _buildShimmer(context);
    }
    if (state is MyContractsError) {
      return _buildErrorState(context, state.message);
    }
    if (state is MyContractsLoaded) {
      if (state.contracts.isEmpty) {
        return _buildEmptyState(context, l10n);
      }
      return _buildList(context, state.contracts);
    }
    return const SliverToBoxAdapter(child: SizedBox.shrink());
  }

  Widget _buildList(BuildContext context, List<ContractEntity> contracts) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xxl,
      ),
      sliver: SliverList.separated(
        itemCount: contracts.length,
        separatorBuilder: (context, i) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (context, index) => _ContractCard(contract: contracts[index]),
      ),
    );
  }

  Widget _buildShimmer(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      sliver: SliverList.separated(
        itemCount: 4,
        separatorBuilder: (context, i) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (context, i) => _ShimmerCard(context: context),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: context.colors.primary.withValues(alpha: 0.06),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.receipt_long_outlined,
                  size: 56,
                  color: context.colors.primary.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                l10n.noContractsFound,
                style: TextStyle(
                  fontSize: AppFonts.headlineSmall,
                  fontWeight: FontWeight.bold,
                  color: context.colors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'لم تقم بإنشاء أو توقيع أي عقود حتى الآن',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppFonts.bodyMedium,
                  color: context.colors.textSecondary,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    final l10n = AppLocalizations.of(context)!;
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
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
                child: Icon(
                  Icons.cloud_off_rounded,
                  size: 56,
                  color: context.colors.error,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'عذراً، حدث خطأ',
                style: TextStyle(
                  fontSize: AppFonts.headlineSmall,
                  fontWeight: FontWeight.bold,
                  color: context.colors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                error,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: context.colors.textSecondary,
                  fontSize: AppFonts.bodyMedium,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton.icon(
                onPressed: () => context.read<MyContractsCubit>().fetchContracts(),
                icon: Icon(Icons.refresh_rounded, color: context.colors.white, size: 20),
                label: Text(
                  l10n.retryLoad,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: AppFonts.bodyLarge,
                    fontWeight: FontWeight.bold,
                    color: context.colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.md,
                  ),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.round),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Stat Chip ─────────────────────────────────────────────────────────────

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.round),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            '$value $label',
            style: TextStyle(
              fontSize: AppFonts.labelMedium,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Shimmer Card ──────────────────────────────────────────────────────────

class _ShimmerCard extends StatelessWidget {
  final BuildContext context;

  const _ShimmerCard({required this.context});

  @override
  Widget build(BuildContext _) {
    return Shimmer.fromColors(
      baseColor: context.colors.border.withValues(alpha: 0.3),
      highlightColor: context.colors.border.withValues(alpha: 0.08),
      child: Container(
        height: 155,
        decoration: BoxDecoration(
          color: context.colors.white,
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
      ),
    );
  }
}

// ─── Contract Card ─────────────────────────────────────────────────────────

class _ContractCard extends StatelessWidget {
  final ContractEntity contract;

  const _ContractCard({required this.contract});

  bool get _isSigned => contract.status == 'signed';

  @override
  Widget build(BuildContext context) {
    final accentColor = _isSigned ? context.colors.success : context.colors.gold;

    String formattedDate = '';
    try {
      final date = DateTime.parse(contract.createdAt);
      formattedDate = DateFormat('d MMM yyyy', 'ar').format(date);
    } catch (_) {
      formattedDate = contract.createdAt.split('T').first;
    }

    return Container(
      decoration: BoxDecoration(
        color: context.colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: AppColors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          onTap: () => context.push(
            AppRouter.contractDetails,
            extra: {'contractId': contract.id},
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Accent bar
              Container(width: 4, color: accentColor),

              // Card content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context, accentColor),
                      const SizedBox(height: AppSpacing.md),
                      _buildTypeRow(context),
                      const SizedBox(height: AppSpacing.md),
                      _buildFooter(context, accentColor, formattedDate),
                      if (!_isSigned) ...[
                        const SizedBox(height: AppSpacing.md),
                        _buildSignButton(context),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color accentColor) {
    return Row(
      children: [
        Expanded(
          child: Text(
            contract.contractNumber,
            style: TextStyle(
              fontSize: AppFonts.bodyMedium,
              fontWeight: FontWeight.bold,
              color: context.colors.textPrimary,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadius.round),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _isSigned ? Icons.check_circle_rounded : Icons.hourglass_bottom_rounded,
                size: 12,
                color: accentColor,
              ),
              const SizedBox(width: 4),
              Text(
                contract.statusLabel,
                style: TextStyle(
                  fontSize: AppFonts.labelSmall,
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTypeRow(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: context.colors.primary.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Icon(
            contract.type.contains('finishing')
                ? Icons.format_paint_rounded
                : Icons.home_work_rounded,
            color: context.colors.primary,
            size: 18,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            contract.typeLabel,
            style: TextStyle(
              fontSize: AppFonts.bodyMedium,
              fontWeight: FontWeight.w600,
              color: context.colors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context, Color accentColor, String formattedDate) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 14,
                color: context.colors.textSecondary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                formattedDate,
                style: TextStyle(
                  fontSize: AppFonts.labelMedium,
                  color: context.colors.textSecondary,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                NumberFormat('#,##0.00').format(contract.totalAmount),
                style: TextStyle(
                  fontSize: AppFonts.bodyLarge,
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'ر.س',
                style: TextStyle(
                  fontSize: AppFonts.labelSmall,
                  fontWeight: FontWeight.w600,
                  color: context.colors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSignButton(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _navigateToSigning(context),
        icon: const Icon(Icons.draw_rounded, size: 18),
        label: Text(
          l10n.signNow,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: AppFonts.bodyMedium,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: context.colors.gold,
          foregroundColor: context.colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
        ),
      ),
    );
  }

  void _navigateToSigning(BuildContext context) {
    final contractType = contract.type.contains('finishing')
        ? ContractType.finishing
        : ContractType.unit;

    context.push(
      AppRouter.contractSigning,
      extra: {
        'type': contractType,
        'contract': contract,
        'overrideTotalAmount': contract.totalAmount,
      },
    );
  }
}
