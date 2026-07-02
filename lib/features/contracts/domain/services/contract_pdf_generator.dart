import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../../core/di/injection_container.dart';
import '../../../../features/profile/domain/entities/user_entity.dart';
import '../../../../features/settings/domain/usecases/get_general_settings_usecase.dart';
import '../../../../features/settings/presentation/cubit/settings_cubit.dart';
import '../../../../features/settings/presentation/cubit/settings_state.dart';
import '../../domain/entities/contract_entity.dart';
import 'pdf/contract_pdf_body_section.dart';
import 'pdf/contract_pdf_clauses_data.dart';
import 'pdf/contract_pdf_clauses_grid.dart';
import 'pdf/contract_pdf_fonts.dart';
import 'pdf/contract_pdf_header.dart';
import 'pdf/contract_pdf_meta_box.dart';
import 'pdf/contract_pdf_signatures.dart';

class ContractPdfGenerator {
  static Future<Uint8List> generate({
    required ContractEntity contract,
    required Uint8List signatureImage,
    UserEntity? user,
  }) async {
    await ContractPdfFonts.loadFonts();

    pw.ImageProvider? signatureProvider;
    if (signatureImage.isNotEmpty) {
      try {
        signatureProvider = pw.MemoryImage(signatureImage);
      } catch (e) {
        debugPrint('Failed to decode signature image: $e');
      }
    }

    String companyName = 'شركة بروز العصرية للعقارات';
    String companyPhone = '920012345';
    String companyCr = '1010987654';
    String? logoUrl;

    final settingsState = sl<SettingsCubit>().state;
    if (settingsState is SettingsLoaded) {
      if (settingsState.settings.siteName.isNotEmpty) companyName = settingsState.settings.siteName;
      if (settingsState.settings.contactPhone.isNotEmpty) companyPhone = settingsState.settings.contactPhone;
      if (settingsState.settings.companyCr.isNotEmpty) companyCr = settingsState.settings.companyCr;
      if (settingsState.settings.siteLogo.isNotEmpty) logoUrl = settingsState.settings.siteLogo;
    }

    final settingsResult = await sl<GetGeneralSettingsUseCase>().call();
    settingsResult.fold(
      (failure) {},
      (settings) {
        if (settings.siteName.isNotEmpty) companyName = settings.siteName;
        if (settings.contactPhone.isNotEmpty) companyPhone = settings.contactPhone;
        if (settings.companyCr.isNotEmpty) companyCr = settings.companyCr;
        if (settings.siteLogo.isNotEmpty) logoUrl = settings.siteLogo;
      },
    );

    pw.ImageProvider? logoProvider;
    if (logoUrl != null && logoUrl!.isNotEmpty) {
      try {
        final dio = sl<Dio>();
        final response = await dio.get<List<int>>(
          logoUrl!,
          options: Options(responseType: ResponseType.bytes),
        );
        if (response.data != null && response.data!.isNotEmpty) {
          logoProvider = pw.MemoryImage(Uint8List.fromList(response.data!));
        }
      } catch (e) {
        debugPrint('Failed to fetch siteLogo image for PDF: $e');
      }
    }

    final pdf = pw.Document();
    final formattedDate = ContractPdfFonts.formatDate(contract.createdAt);
    final generatedAt = ContractPdfFonts.formatDate(DateTime.now().toIso8601String());

    final clauses = ContractPdfClausesData.getClauses(
      contract.type,
      unitNumber: '#${contract.apartmentId}',
      floor: 'الأول',
      location: 'المشروع السكني المعتمد',
      area: '185',
      totalAmount: ContractPdfFonts.formatNum(contract.totalAmount),
      executionDuration: contract.executionDuration.toString(),
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(14, 10, 14, 10),
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(
          base: ContractPdfFonts.regular,
          bold: ContractPdfFonts.bold,
          // NotoSansArabic covers any glyph missing from the Cairo subset (e.g. ى)
          fontFallback: [ContractPdfFonts.noto],
        ),
        // Header printed on every page
        header: (ctx) => pw.Column(
          children: [
            ContractPdfHeader.buildTopBar(
              companyNameAr: companyName,
              companyPhone: companyPhone,
              companyCr: companyCr,
              logoProvider: logoProvider,
            ),
            pw.SizedBox(height: 3),
            ContractPdfHeader.buildTitleBlock(contract.type, contract.typeLabel),
            ContractPdfMetaBox.build(
              customerName: user?.name ?? '---',
              customerPhone: user?.phone ?? '---',
              customerEmail: user?.email ?? '---',
              contractNumber: contract.contractNumber,
              formattedDate: formattedDate,
              statusLabel: contract.statusLabel,
              typeLabel: contract.typeLabel,
            ),
            pw.SizedBox(height: 4),
          ],
        ),
        // Footer with signature printed on the LAST page only
        footer: (ctx) => ctx.pagesCount == ctx.pageNumber
            ? pw.Column(
                children: [
                  pw.SizedBox(height: 6),
                  ContractPdfSignatures.buildSignatures(
                    signatureProvider: signatureProvider,
                    hasCustomerSignature: contract.hasCustomerSignature,
                  ),
                  ContractPdfSignatures.buildFooter(generatedAt),
                ],
              )
            : ContractPdfSignatures.buildFooter(generatedAt),
        // Main content flows across pages
        build: (ctx) => [
          // Body (contract text + tables)
          ...ContractPdfBodySection.build(contract.contractBody),
          pw.SizedBox(height: 4),
          // Legal clauses
          ContractPdfMetaBox.buildSectionTitle('المواد والشروط القانونية للعقد'),
          pw.SizedBox(height: 3),
          ...ContractPdfClausesGrid.build(clauses),
        ],
      ),
    );

    return pdf.save();
  }
}
