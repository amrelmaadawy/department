import 'package:apartment/core/theme/app_colors.dart';
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
import '../cubit/contracts_cubit.dart';
import '../cubit/contracts_state.dart';


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
  Uint8List? _capturedSignatureBytes;

  @override
  void initState() {
    super.initState();
    _signatureController = SignatureController(
      penStrokeWidth: 3,
      penColor: AppColors.black,
      exportBackgroundColor: AppColors.white,
    );
  }

  @override
  void dispose() {
    _signatureController.dispose();
    super.dispose();
  }

  void _toggleAgreement(bool? value) {
    if (value != null) {
      setState(() {
        _isAgreed = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
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
              finishingTotal: widget.overrideTotalAmount ?? (widget.contractType == ContractType.unit ? null : widget.finishingTotal),
              unit: widget.unit,
              contractNumber: widget.contract?.contractNumber,
              contractTypeLabel: widget.contract?.typeLabel,
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
        listener: (context, state) {
          if (state is ContractSignedSuccess) {
            // Use the already-captured bytes — captured BEFORE the API call
            // to avoid any race condition with controller disposal.
            final signatureBytes = _capturedSignatureBytes;
            if (signatureBytes != null && signatureBytes.isNotEmpty && context.mounted) {
              context.push(
                AppRouter.contractReview,
                extra: {
                  'contract': state.contract,
                  'signatureImage': signatureBytes,
                },
              ).then((_) {
                if (context.mounted) {
                  context.pop(true);
                }
              });
            } else if (context.mounted) {
              context.pop(true);
            }
          } else if (state is ContractsError) {
            AppToast.showError(context, state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is ContractSigningLoading;
          return AnimatedBuilder(
            animation: Listenable.merge([_signatureController]),
            builder: (context, _) {
              return ContractBottomActions(
                isAgreed: _isAgreed,
                signatureController: _signatureController,
                contractType: widget.contractType,
                price: widget.contractType == ContractType.unit ? (widget.unit?.price ?? 0.0) : (widget.finishingTotal ?? 0.0),
                unit: widget.unit,
                isLoading: isLoading,
                onSign: (base64Signature, capturedBytes) async {
                  // Store the captured bytes immediately before API call
                  _capturedSignatureBytes = capturedBytes;
                  if (widget.contract != null) {
                    context.read<ContractsCubit>().signContract(
                      contractId: widget.contract!.id,
                      signatureBase64: base64Signature,
                    );
                  } else {
                    AppToast.showError(context, 'Contract data is missing');
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
