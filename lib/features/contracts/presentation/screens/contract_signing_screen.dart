import 'package:apartment/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import 'package:signature/signature.dart';

import '../widgets/contract/contract_bottom_actions.dart';
import '../widgets/contract/contract_signature_card.dart';
import '../widgets/contract/contract_summary_card.dart';
import '../widgets/contract/contract_terms_card.dart';
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
  
  const ContractSigningScreen({
    super.key, 
    required this.contractType,
    this.finishingTotal,
    this.unit,
    this.contract,
  });

  @override
  State<ContractSigningScreen> createState() => _ContractSigningScreenState();
}

class _ContractSigningScreenState extends State<ContractSigningScreen> {
  bool _isAgreed = false;
  late SignatureController _signatureController;

  @override
  void initState() {
    super.initState();
    _signatureController = SignatureController(
      penStrokeWidth: 3,
      penColor: Colors.black,
      exportBackgroundColor: Colors.transparent,
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
              finishingTotal: widget.finishingTotal,
              unit: widget.unit,
            ),
            ContractTermsCard(
              contractType: widget.contractType,
              contract: widget.contract,
              isAgreed: _isAgreed,
              onChanged: _toggleAgreement,
            ),
            const SizedBox(height: AppSpacing.md),
            ContractSignatureCard(controller: _signatureController),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: BlocConsumer<ContractsCubit, ContractsState>(
        listener: (context, state) async {
          if (state is ContractSignedSuccess) {
            // Get the signature image bytes
            final signatureImage = await _signatureController.toPngBytes();
            if (signatureImage != null && context.mounted) {
              // Navigate to Preview Screen to show the local PDF
              final result = await context.push(
                AppRouter.contractPreview, 
                extra: {
                  'signatureImage': signatureImage, 
                  'contract': state.contract,
                }
              );
              if (result == true && context.mounted) {
                // If user confirmed in preview screen, pop back to review screen or go to success
                context.pop(true);
              }
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
                onSign: (base64Signature) async {
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
