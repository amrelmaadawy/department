import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import '../../../../core/widgets/app_toast.dart';

class ServerContractPrintPreviewScreen extends StatefulWidget {
  final Uint8List pdfBytes;
  final String contractTitle;

  const ServerContractPrintPreviewScreen({
    super.key,
    required this.pdfBytes,
    required this.contractTitle,
  });

  @override
  State<ServerContractPrintPreviewScreen> createState() => _ServerContractPrintPreviewScreenState();
}

class _ServerContractPrintPreviewScreenState extends State<ServerContractPrintPreviewScreen> {
  bool _isPrinting = false;

  Future<void> _printNative() async {
    if (_isPrinting) return;
    setState(() => _isPrinting = true);
    try {
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => widget.pdfBytes,
        name: '${widget.contractTitle}.pdf',
      );
    } catch (e) {
      if (mounted) AppToast.showError(context, 'فشل في فتح نافذة الطباعة');
    } finally {
      if (mounted) setState(() => _isPrinting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.white,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          widget.contractTitle,
          style: TextStyle(
            fontSize: AppFonts.headlineMedium,
            fontWeight: FontWeight.bold,
            color: context.colors.primary,
          ),
        ),
        leading: IconButton(
          icon: Icon(FluentIcons.arrow_left_24_filled, color: context.colors.primary),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                child: PdfPreview(
                  build: (_) => widget.pdfBytes,
                  initialPageFormat: PdfPageFormat.a4,
                  allowPrinting: false,
                  allowSharing: false,
                  canChangeOrientation: false,
                  canChangePageFormat: false,
                  canDebug: false,
                  onError: (context, error) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.error_outline_rounded, size: 48, color: context.colors.error),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'تعذر عرض ملف العقد',
                            style: TextStyle(fontSize: AppFonts.headlineSmall, fontWeight: FontWeight.bold, color: context.colors.textPrimary),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            error.toString().replaceAll('Exception: ', ''),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: AppFonts.bodyMedium, color: context.colors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          _buildBottomPrintBar(context),
        ],
      ),
    );
  }

  Widget _buildBottomPrintBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.white,
        border: Border(top: BorderSide(color: context.colors.border.withValues(alpha: 0.2))),
      ),
      child: ElevatedButton.icon(
        onPressed: _isPrinting ? null : _printNative,
        style: ElevatedButton.styleFrom(
          backgroundColor: context.colors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
          elevation: 0,
        ),
        icon: _isPrinting
            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
            : const Icon(FluentIcons.print_24_regular),
        label: Text(
          _isPrinting ? 'جاري الطباعة...' : 'طباعة العقد الآن',
          style: const TextStyle(fontSize: AppFonts.bodyLarge, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
