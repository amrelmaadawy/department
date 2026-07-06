import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:open_filex/open_filex.dart';
import 'package:share_plus/share_plus.dart';
import 'package:printing/printing.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extension.dart';

class ContractPdfActionBottomSheet extends StatelessWidget {
  final String filePath;

  const ContractPdfActionBottomSheet({super.key, required this.filePath});

  static void show(BuildContext context, {required String filePath}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ContractPdfActionBottomSheet(filePath: filePath),
    );
  }

  Future<void> _previewPdf(BuildContext context) async {
    Navigator.pop(context);
    await OpenFilex.open(filePath);
  }

  Future<void> _sharePdf(BuildContext context) async {
    Navigator.pop(context);
    // ignore: deprecated_member_use
    await Share.shareXFiles([XFile(filePath)], text: 'نسخة العقد الخاصة بك');
  }

  Future<void> _printPdf(BuildContext context) async {
    Navigator.pop(context);
    final file = File(filePath);
    if (await file.exists()) {
      final bytes = await file.readAsBytes();
      await Printing.layoutPdf(
        onLayout: (format) async => bytes,
        name: 'contract',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.colors.textSecondary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'تم إنشاء العقد بنجاح',
            style: TextStyle(
              fontSize: AppFonts.headlineSmall,
              fontWeight: FontWeight.bold,
              color: context.colors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'اختر الإجراء الذي تود القيام به:',
            style: TextStyle(
              fontSize: AppFonts.bodyMedium,
              color: context.colors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _buildActionTile(
            context,
            icon: FluentIcons.eye_24_regular,
            title: 'معاينة العقد',
            subtitle: 'فتح وعرض ملف الـ PDF',
            onTap: () => _previewPdf(context),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildActionTile(
            context,
            icon: FluentIcons.share_24_regular,
            title: 'مشاركة / حفظ',
            subtitle: 'إرسال أو حفظ في الجهاز',
            onTap: () => _sharePdf(context),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildActionTile(
            context,
            icon: FluentIcons.print_24_regular,
            title: 'طباعة مباشرة',
            subtitle: 'إرسال إلى طابعة متصلة',
            onTap: () => _printPdf(context),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          border: Border.all(color: context.colors.border),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.colors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: context.colors.primary, size: 24),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: AppFonts.bodyLarge,
                      fontWeight: FontWeight.w600,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: AppFonts.bodySmall,
                      color: context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              FluentIcons.chevron_left_24_regular,
              color: context.colors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
