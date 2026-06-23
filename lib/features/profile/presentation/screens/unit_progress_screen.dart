import 'package:flutter/material.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_fonts.dart';
import '../widgets/progress_timeline_tile.dart';
import 'package:apartment/core/theme/theme_extension.dart';


class UnitProgressScreen extends StatefulWidget {
  const UnitProgressScreen({super.key});

  @override
  State<UnitProgressScreen> createState() => _UnitProgressScreenState();
}

class _UnitProgressScreenState extends State<UnitProgressScreen> {
  // Mock Data: The unit is currently at phase 3 (Index 2)
  final int _currentStep = 2;

  final List<Map<String, dynamic>> _phases = [
    {
      'title': 'التأسيس والمحارة',
      'subtitle': 'تم الانتهاء من أعمال البناء والمحارة الأساسية',
      'date': '12 أكتوبر 2026',
      'images': [],
    },
    {
      'title': 'تأسيس السباكة والكهرباء',
      'subtitle': 'تم تمديد شبكات المياه والكهرباء والتكييف',
      'date': '28 أكتوبر 2026',
      'images': [],
    },
    {
      'title': 'الأرضيات والأسقف',
      'subtitle': 'جاري العمل على تركيب الرخام وأسقف الجبس بورد',
      'date': 'جاري التنفيذ',
      'images': [],
    },
    {
      'title': 'الدهانات والتشطيب النهائي',
      'subtitle': 'سيتم البدء بعد جفاف الأرضيات',
      'date': 'متوقع: 15 ديسمبر 2026',
      'images': [],
    },
    {
      'title': 'التسليم',
      'subtitle': 'تسليم الوحدة مطابقة للمواصفات',
      'date': 'متوقع: 1 يناير 2027',
      'images': [],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.white,
        elevation: 0,
        scrolledUnderElevation: 0.0,
        title:  Text(
          l10n.finishingProgressTitle,
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
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 40),
        physics: const BouncingScrollPhysics(),
        itemCount: _phases.length,
        itemBuilder: (context, index) {
          final phase = _phases[index];
          final bool isCompleted = index < _currentStep;
          final bool isActive = index == _currentStep;
          final bool isFirst = index == 0;
          final bool isLast = index == _phases.length - 1;

          return ProgressTimelineTile(
            isFirst: isFirst,
            isLast: isLast,
            isCompleted: isCompleted,
            isActive: isActive,
            phase: phase,
          );
        },
      ),
    );
  }
}
