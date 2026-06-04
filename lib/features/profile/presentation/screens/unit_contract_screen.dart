import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../projects/domain/services/contract_pdf_generator.dart';
import '../widgets/contract_details_card.dart';
import '../widgets/contract_financial_card.dart';

class UnitContractScreen extends StatefulWidget {
  const UnitContractScreen({super.key});

  @override
  State<UnitContractScreen> createState() => _UnitContractScreenState();
}

class _UnitContractScreenState extends State<UnitContractScreen> {
  // Mock Data
  final Map<String, dynamic> _contractData = {
    'projectName': 'The Pearl Resort',
    'unitName': 'فيلا 402 - إطلالة بحرية',
    'contractDate': '12 أكتوبر 2026',
    'ownerName': 'أحمد محمود العطار',
    'totalPrice': '12,500,000 ج.م',
    'paidAmount': '2,500,000 ج.م',
    'remainingAmount': '10,000,000 ج.م',
    'status': 'موثق ومعتمد',
  };

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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'تفاصيل العقد',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: AppFonts.headlineSmall,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(FluentIcons.ios_arrow_rtl_24_regular, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          children: [
            // Status Header
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(FluentIcons.shield_checkmark_24_filled, color: AppColors.success, size: 28),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  _contractData['status'],
                  style: const TextStyle(
                    fontSize: AppFonts.bodyLarge,
                    color: AppColors.success,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),
            
            // Details Card
            ContractDetailsCard(unitData: _contractData),
            const SizedBox(height: AppSpacing.xl),
            
            // Financial Card
            ContractFinancialCard(financialData: _contractData),
            const SizedBox(height: AppSpacing.xxxl),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: CustomButton(
            text: _isGeneratingPdf ? 'جاري تجهيز الملف...' : 'تحميل نسخة PDF',
            backgroundColor: AppColors.primary,
            textColor: AppColors.white,
            onPressed: _isGeneratingPdf ? null : _downloadPdf,
          ),
        ),
      ),
    );
  }
}
