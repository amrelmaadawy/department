import 'package:apartment/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:apartment/l10n/app_localizations.dart';

import 'package:signature/signature.dart';

import '../widgets/contract/contract_bottom_actions.dart';
import '../widgets/contract/contract_signature_card.dart';
import '../widgets/contract/contract_summary_card.dart';
import '../widgets/contract/contract_terms_card.dart';
import '../../domain/entities/contract_type.dart';
import 'package:apartment/core/theme/theme_extension.dart';


class ContractSigningScreen extends StatefulWidget {
  final ContractType contractType;
  final double? finishingTotal;
  
  const ContractSigningScreen({
    super.key, 
    required this.contractType,
    this.finishingTotal,
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
            ),
            ContractTermsCard(
              contractType: widget.contractType,
              isAgreed: _isAgreed,
              onChanged: _toggleAgreement,
            ),
            SizedBox(height: AppSpacing.md),
            ContractSignatureCard(controller: _signatureController),
            SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: AnimatedBuilder(
        animation: Listenable.merge([_signatureController]),
        builder: (context, _) {
          return ContractBottomActions(
            isAgreed: _isAgreed,
            signatureController: _signatureController,
          );
        },
      ),
    );
  }
}
