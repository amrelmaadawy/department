import 'package:apartment/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:apartment/core/theme/app_colors.dart';
import 'package:apartment/l10n/app_localizations.dart';

import 'package:signature/signature.dart';

import '../widgets/details/contract/contract_bottom_actions.dart';
import '../widgets/details/contract/contract_signature_card.dart';
import '../widgets/details/contract/contract_summary_card.dart';
import '../widgets/details/contract/contract_terms_card.dart';

class UnitContractScreen extends StatefulWidget {
  const UnitContractScreen({super.key});

  @override
  State<UnitContractScreen> createState() => _UnitContractScreenState();
}

class _UnitContractScreenState extends State<UnitContractScreen> {
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          l10n.contractScreenTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ContractSummaryCard(),
            ContractTermsCard(
              isAgreed: _isAgreed,
              onChanged: _toggleAgreement,
            ),
            const SizedBox(height: AppSpacing.md),
            ContractSignatureCard(controller: _signatureController),
            const SizedBox(height: 24),
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
