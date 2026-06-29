import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import 'package:apartment/core/di/injection_container.dart';
import 'package:apartment/core/routes/app_router.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/l10n/app_localizations.dart';

import '../../domain/entities/contract_entity.dart';
import '../../domain/entities/contract_type.dart';
import '../cubit/contracts_cubit.dart';
import '../cubit/contracts_state.dart';
import 'contract_details_body.dart';

class ContractDetailsScreen extends StatelessWidget {
  final int contractId;

  const ContractDetailsScreen({super.key, required this.contractId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ContractsCubit>()..loadContractDetails(contractId),
      child: const _ContractDetailsView(),
    );
  }
}

class _ContractDetailsView extends StatelessWidget {
  const _ContractDetailsView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContractsCubit, ContractsState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: context.colors.background,
          body: _buildBody(context, state),
          floatingActionButton: state is ContractDetailsLoaded &&
                  state.contract.status == 'pending_signature'
              ? _buildSignFab(context, state.contract)
              : null,
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ContractsState state) {
    if (state is ContractDetailsLoading || state is ContractsInitial) {
      return _buildShimmer(context);
    }
    if (state is ContractsError) {
      return _buildError(context, state.message);
    }
    if (state is ContractDetailsLoaded) {
      return ContractDetailsBody(contract: state.contract);
    }
    return const SizedBox.shrink();
  }

  Widget _buildSignFab(BuildContext context, ContractEntity contract) {
    final contractType = contract.type.contains('finishing')
        ? ContractType.finishing
        : ContractType.unit;

    return FloatingActionButton.extended(
      onPressed: () => context.push(
        AppRouter.contractSigning,
        extra: {
          'type': contractType,
          'contract': contract,
          'overrideTotalAmount': contract.totalAmount,
        },
      ),
      backgroundColor: context.colors.gold,
      foregroundColor: context.colors.white,
      icon: const Icon(Icons.draw_rounded, size: 20),
      label: const Text(
        'وقّع الآن',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: AppFonts.bodyMedium,
        ),
      ),
    );
  }

  Widget _buildShimmer(BuildContext context) {
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

  Widget _buildError(BuildContext context, String message) {
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
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: context.colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.round),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact stat widget for the header card.
class ContractStatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ContractStatChip({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: context.colors.textSecondary),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: TextStyle(
                fontSize: AppFonts.labelMedium,
                color: context.colors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: AppFonts.bodyMedium,
            fontWeight: FontWeight.bold,
            color: context.colors.textPrimary,
          ),
        ),
      ],
    );
  }
}

String formatContractDate(String raw) {
  try {
    final date = DateTime.parse(raw);
    return DateFormat('d MMM yyyy', 'ar').format(date);
  } catch (_) {
    return raw.split('T').first;
  }
}
