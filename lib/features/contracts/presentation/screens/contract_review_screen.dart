import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:apartment/core/services/security/screenshot_prevention_service.dart';
import 'package:apartment/core/di/injection_container.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/core/widgets/app_toast.dart';
import 'package:apartment/l10n/app_localizations.dart';
import '../../../profile/presentation/cubit/profile_cubit.dart';
import '../../../profile/presentation/cubit/profile_state.dart';
import '../../domain/entities/contract_entity.dart';
import '../../domain/services/contract_pdf_generator.dart';
import '../widgets/contract_review_bottom_bar.dart';
import '../widgets/contract_review_pdf_preview.dart';

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
    ScreenshotPreventionService.enable();
    WidgetsBinding.instance.addPostFrameCallback((_) => _buildPdf());
  }

  @override
  void dispose() {
    ScreenshotPreventionService.disable();
    super.dispose();
  }

  Future<void> _buildPdf() async {
    try {
      final cubit = sl<ProfileCubit>();
      final user = cubit.state is ProfileLoaded ? (cubit.state as ProfileLoaded).profile.user : null;
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
    } catch (e) {
      if (mounted) AppToast.showError(context, 'خطأ في إنشاء المستند: $e');
    }
  }

  Future<void> _print() async {
    if (_isPrinting || _pdfBytes == null) return;
    setState(() => _isPrinting = true);
    try {
      final fileName = 'contract_${widget.contract.contractNumber}.pdf';
      Directory? saveDir;

      if (Platform.isAndroid) {
        // Save directly to Downloads folder on Android
        saveDir = Directory('/storage/emulated/0/Download');
        if (!await saveDir.exists()) {
          saveDir = await getExternalStorageDirectory();
        }
      } else {
        // iOS: save to app's Documents directory (accessible via Files app)
        saveDir = await getApplicationDocumentsDirectory();
      }

      final filePath = '${saveDir!.path}/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(_pdfBytes!);

      if (mounted) {
        AppToast.showSuccess(context, 'تم حفظ العقد في: $filePath');
      }
    } catch (e) {
      if (mounted) AppToast.showError(context, 'فشل في حفظ الملف');
    } finally {
      if (mounted) setState(() => _isPrinting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.white,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          l10n.contractSummary,
          style: TextStyle(fontSize: AppFonts.headlineMedium, fontWeight: FontWeight.bold, color: context.colors.primary),
        ),
        leading: IconButton(
          icon: Icon(FluentIcons.arrow_left_24_filled, color: context.colors.primary),
          onPressed: () => context.pop(true),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ContractReviewPdfPreview(
              pdfReady: _pdfReady,
              pdfBytes: _pdfBytes,
              contractNumber: widget.contract.contractNumber,
            ),
          ),
          ContractReviewBottomBar(
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
}
