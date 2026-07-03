import 'package:apartment/core/theme/app_colors.dart';
import 'package:apartment/core/services/security/screenshot_prevention_service.dart';
import 'dart:typed_data';

import 'package:apartment/core/theme/app_spacing.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import 'package:signature/signature.dart';

import '../widgets/contract/contract_bottom_actions.dart';
import '../widgets/contract/contract_signature_card.dart';
import '../widgets/contract/contract_summary_card.dart';

import '../../domain/entities/contract_type.dart';
import '../../domain/entities/contract_entity.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/core/widgets/app_toast.dart';
import 'package:apartment/core/routes/app_router.dart';
import 'package:apartment/core/di/injection_container.dart';
import '../cubit/contracts_cubit.dart';
import '../cubit/contracts_state.dart';
import '../cubit/contract_print_cubit.dart';
import '../cubit/contract_print_state.dart';


class ContractSigningScreen extends StatefulWidget {
  final ContractType contractType;
  final double? finishingTotal;
  final dynamic unit;
  final ContractEntity? contract;
  /// When coming from profile contracts list, pass the amount directly
  /// to avoid depending on DesignContextCubit state.
  final double? overrideTotalAmount;

  const ContractSigningScreen({
    super.key,
    required this.contractType,
    this.finishingTotal,
    this.unit,
    this.contract,
    this.overrideTotalAmount,
  });

  @override
  State<ContractSigningScreen> createState() => _ContractSigningScreenState();
}

class _ContractSigningScreenState extends State<ContractSigningScreen> {
  bool _isAgreed = false;
  late SignatureController _signatureController;
  // ignore: unused_field
  Uint8List? _capturedSignatureBytes;

  @override
  void initState() {
    super.initState();
    ScreenshotPreventionService.enable();
    _signatureController = SignatureController(
      penStrokeWidth: 3,
      penColor: AppColors.black,
      exportBackgroundColor: AppColors.white,
    );
  }

  @override
  void dispose() {
    ScreenshotPreventionService.disable();
    _signatureController.dispose();
    super.dispose();
  }

  void _toggleAgreement(bool? value) {
    if (value != null) setState(() => _isAgreed = value);
  }

  /// Extracts the numeric apartment ID from the unit passed to this screen.
  int _resolveApartmentId() {
    if (widget.unit == null) return 0;
    try {
      final id = widget.unit.id;
      return id is int ? id : int.tryParse(id.toString()) ?? 0;
    } catch (_) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // ContractPrintCubit is created here (scoped to this screen) so it is
    // always available regardless of how this route was pushed.
    // Builder provides an inner context that IS a descendant of the provider,
    // which is required for BlocListener to locate the cubit.
    return BlocProvider(
      create: (_) => sl<ContractPrintCubit>(),
      child: Builder(
        builder: (innerContext) => BlocListener<ContractPrintCubit, ContractPrintState>(
          listener: (ctx, printState) {
            if (printState is ContractPrintLoading) {
              AppToast.showInfo(ctx, 'جاري تحضير نسخة العقد...');
            } else if (printState is ContractPrintError) {
              // Sign succeeded — only the print fetch failed.
              // Pop with success so the parent screen refreshes.
              AppToast.showError(ctx, printState.message);
              innerContext.pop(true);
            } else if (printState is ContractPrintWebViewReady) {
              innerContext.push(
                AppRouter.contractWebView,
                extra: {
                  'printUrl': printState.printUrl,
                  'pdfUrl': printState.pdfUrl,
                  'contractTitle': printState.contractTitle,
                },
              ).then((_) {
                if (innerContext.mounted) innerContext.pop(true);
              });
            }
          },
          child: Scaffold(
            backgroundColor: context.colors.background,
            appBar: AppBar(
              title: Text(
                widget.contractType == ContractType.unit
                    ? l10n.contractScreenTitle
                    : l10n.finishingContract,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: context.colors.primary,
                ),
              ),
              backgroundColor: context.colors.background,
              elevation: 0,
              scrolledUnderElevation: 0,
              centerTitle: true,
              iconTheme: IconThemeData(color: context.colors.primary),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ContractSummaryCard(
                    contractType: widget.contractType,
                    finishingTotal: widget.overrideTotalAmount ??
                        (widget.contractType == ContractType.unit
                            ? null
                            : widget.finishingTotal),
                    unit: widget.unit,
                    contractNumber: widget.contract?.contractNumber,
                    contractTypeLabel: widget.contract?.typeLabel,
                    contract: widget.contract,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ContractSignatureCard(
                    controller: _signatureController,
                    isAgreed: _isAgreed,
                    contractType: widget.contractType,
                    contract: widget.contract,
                    onAgreementChanged: _toggleAgreement,
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
            bottomNavigationBar: BlocConsumer<ContractsCubit, ContractsState>(
              listener: (ctx, state) {
                if (state is ContractSignedSuccess) {
                  final aptId = _resolveApartmentId();
                  if (aptId > 0) {
                    // Trigger print_url fetch.
                    // BlocListener above handles navigation to WebView.
                    final printCubit = innerContext.read<ContractPrintCubit>();
                    if (widget.contractType == ContractType.unit) {
                      printCubit.fetchBoneContractWebView(aptId);
                    } else {
                      printCubit.fetchFinishingContractWebView(aptId);
                    }
                  } else {
                    innerContext.pop(true);
                  }
                } else if (state is SessionExpiredState) {
                  AppToast.showError(
                      ctx, 'انتهت صلاحية الجلسة، يرجى تسجيل الدخول مرة أخرى');
                  innerContext.go(AppRouter.auth);
                } else if (state is ContractsError) {
                  AppToast.showError(ctx, state.message);
                }
              },
              builder: (ctx, state) {
                final isLoading = state is ContractSigningLoading;
                return AnimatedBuilder(
                  animation: Listenable.merge([_signatureController]),
                  builder: (_, child) => ContractBottomActions(
                    isAgreed: _isAgreed,
                    signatureController: _signatureController,
                    contractType: widget.contractType,
                    price: widget.contractType == ContractType.unit
                        ? (widget.unit?.price ?? 0.0)
                        : (widget.finishingTotal ?? 0.0),
                    unit: widget.unit,
                    isLoading: isLoading,
                    onSign: (base64Signature, capturedBytes) async {
                      _capturedSignatureBytes = capturedBytes;
                      if (widget.contract != null) {
                        ctx.read<ContractsCubit>().signContract(
                          contractId: widget.contract!.id,
                          signatureBase64: base64Signature,
                        );
                      } else {
                        AppToast.showError(ctx, 'Contract data is missing');
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
