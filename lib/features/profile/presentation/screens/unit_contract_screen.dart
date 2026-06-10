import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../projects/domain/services/contract_pdf_generator.dart';
import '../widgets/contract_details_card.dart';
import '../widgets/contract_financial_card.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:apartment/core/theme/theme_extension.dart';


class UnitContractScreen extends StatefulWidget {
  const UnitContractScreen({super.key});

  @override
  State<UnitContractScreen> createState() => _UnitContractScreenState();
}

class _UnitContractScreenState extends State<UnitContractScreen> {


  bool _isGeneratingPdf = false;

  Future<void> _downloadPdf() async {
    setState(() => _isGeneratingPdf = true);
    try {
      // Create an empty dummy signature since it's already a finalized contract
      final emptySignature = Uint8List(0);
      final bytes = await ContractPdfGenerator.generateContractBytes(
        PdfPageFormat.a4,
        emptySignature,
      );
      await Printing.sharePdf(
        bytes: bytes,
        filename: 'Contract_Villa402.pdf',
      );
    } finally {
      setState(() => _isGeneratingPdf = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    // Mock Data
    final Map<String, dynamic> contractData = {
      'projectName': 'The Pearl Resort',
      'unitName': l10n.mockUnitName,
      'contractDate': l10n.mockContractDate,
      'ownerName': l10n.mockOwnerName,
      'totalPrice': '12,500,000 ر.س',
      'paidAmount': '2,500,000 ر.س',
      'remainingAmount': '10,000,000 ر.س',
      'status': l10n.contractStatusVerified,
    };

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          l10n.contractDetails,
          style: TextStyle(
            color: context.colors.textPrimary,
            fontSize: AppFonts.headlineSmall,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(FluentIcons.ios_arrow_rtl_24_regular, color: context.colors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Column(
          children: [
            // Status Header
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(FluentIcons.shield_checkmark_24_filled, color: context.colors.success, size: 28),
                SizedBox(width: AppSpacing.sm),
                Text(
                  contractData['status'],
                  style: TextStyle(
                    fontSize: AppFonts.bodyLarge,
                    color: context.colors.success,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.xxl),
            
            // Details Card
            ContractDetailsCard(unitData: contractData),
            SizedBox(height: AppSpacing.xl),
            
            // Financial Card
            ContractFinancialCard(financialData: contractData),
            SizedBox(height: AppSpacing.xxxl),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: CustomButton(
            text: _isGeneratingPdf ? l10n.generatingPdf : l10n.downloadPdf,
            backgroundColor: context.colors.primary,
            textColor: Colors.white,
            onPressed: _isGeneratingPdf ? null : _downloadPdf,
          ),
        ),
      ),
    );
  }
}
