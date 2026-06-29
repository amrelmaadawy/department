import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import 'package:apartment/core/di/injection_container.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/core/widgets/app_toast.dart';
import 'package:apartment/l10n/app_localizations.dart';

import '../../../profile/presentation/cubit/profile_cubit.dart';
import '../../../profile/presentation/cubit/profile_state.dart';
import '../../domain/entities/contract_entity.dart';
import '../../domain/services/contract_pdf_generator.dart';

class ContractReviewScreen extends StatefulWidget {
  final ContractEntity contract;
  final Uint8List signatureImage;

  const ContractReviewScreen({
    super.key,
    required this.contract,
    required this.signatureImage,
  });

  @override
  State<ContractReviewScreen> createState() => _ContractReviewScreenState();
}

class _ContractReviewScreenState extends State<ContractReviewScreen> {
  bool _isPrinting = false;
  bool _pdfReady = false;
  Uint8List? _pdfBytes;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _buildPdf());
  }

  Future<void> _buildPdf() async {
    try {
      final cubit = sl<ProfileCubit>();
      final user = cubit.state is ProfileLoaded
          ? (cubit.state as ProfileLoaded).profile.user
          : null;

      final bytes = await ContractPdfGenerator.generate(
        contract: widget.contract,
        signatureImage: widget.signatureImage,
        user: user,
      );

      if (mounted) {
        setState(() {
          _pdfBytes = bytes;
          _pdfReady = true;
        });
      }
    } catch (e, st) {
      debugPrint('ContractPDF Error: $e\n$st');
      if (mounted) {
        AppToast.showError(context, 'خطأ في إنشاء المستند: $e');
      }
    }
  }

  Future<void> _print() async {
    if (_isPrinting || _pdfBytes == null) return;
    setState(() => _isPrinting = true);
    try {
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => _pdfBytes!,
        name: 'contract_${widget.contract.contractNumber}.pdf',
      );
    } catch (e) {
      if (mounted) AppToast.showError(context, 'فشل في الطباعة');
    } finally {
      if (mounted) setState(() => _isPrinting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: _buildAppBar(l10n),
      body: Column(
        children: [
          Expanded(child: _buildPreview()),
          _BottomBar(
            isPrinting: _isPrinting,
            pdfReady: _pdfReady,
            onPrint: _print,
            onBack: () => context.pop(true),
            l10n: l10n,
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(AppLocalizations l10n) {
    return AppBar(
      backgroundColor: context.colors.white,
      scrolledUnderElevation: 0,
      centerTitle: true,
      title: Text(
        l10n.contractSummary,
        style: TextStyle(
          fontSize: AppFonts.headlineMedium,
          fontWeight: FontWeight.bold,
          color: context.colors.primary,
        ),
      ),
      leading: IconButton(
        icon: Icon(FluentIcons.arrow_left_24_filled,
            color: context.colors.primary),
        onPressed: () => context.pop(true),
      ),
      actions: const [SizedBox(width: 48)],
    );
  }

  Widget _buildPreview() {
    if (!_pdfReady) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: context.colors.primary,
              strokeWidth: 3,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'جاري تحضير العقد...',
              style: TextStyle(
                fontSize: AppFonts.bodyMedium,
                color: context.colors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.sm,
        right: AppSpacing.sm,
        top: AppSpacing.sm,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppRadius.lg),
          topRight: Radius.circular(AppRadius.lg),
        ),
        child: PdfPreview(
          build: (_) => _pdfBytes!,
          initialPageFormat: PdfPageFormat.a4,
          maxPageWidth: 760,
          allowPrinting: false,
          allowSharing: false,
          canChangeOrientation: false,
          canChangePageFormat: false,
          canDebug: false,
          pdfFileName: 'contract_${widget.contract.contractNumber}.pdf',
          scrollViewDecoration: BoxDecoration(
            color: context.colors.background,
          ),
        ),
      ),
    );
  }
}

// ─── Bottom Action Bar ────────────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  final bool isPrinting;
  final bool pdfReady;
  final VoidCallback onPrint;
  final VoidCallback onBack;
  final AppLocalizations l10n;

  const _BottomBar({
    required this.isPrinting,
    required this.pdfReady,
    required this.onPrint,
    required this.onBack,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: context.colors.white,
        border: Border(
          top: BorderSide(
            color: context.colors.border.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          // Back button
          OutlinedButton.icon(
            onPressed: onBack,
            style: OutlinedButton.styleFrom(
              foregroundColor: context.colors.primary,
              side: BorderSide(
                color: context.colors.primary.withValues(alpha: 0.4),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
            ),
            icon: const Icon(FluentIcons.arrow_left_24_regular, size: 18),
            label: const Text(
              'رجوع',
              style: TextStyle(
                fontSize: AppFonts.bodySmall,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          // Print button
          Expanded(
            child: ElevatedButton.icon(
              onPressed: (isPrinting || !pdfReady) ? null : onPrint,
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor:
                    context.colors.primary.withValues(alpha: 0.35),
                disabledForegroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                elevation: 0,
              ),
              icon: isPrinting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(FluentIcons.print_24_regular, size: 18),
              label: Text(
                isPrinting
                    ? 'جاري الطباعة...'
                    : !pdfReady
                        ? 'جاري التحضير...'
                        : l10n.printContract,
                style: const TextStyle(
                  fontSize: AppFonts.bodySmall,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
