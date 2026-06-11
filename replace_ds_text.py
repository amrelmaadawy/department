import os

def replace_in_file(path, replacements):
    with open(path, "r", encoding="utf-8") as f:
        content = f.read()

    # Add AppLocalizations if needed
    if "import 'package:apartment/l10n/app_localizations.dart';" not in content and "import '../../../../l10n/app_localizations.dart';" not in content:
        # Just find a good place to put it
        if "import 'package:flutter/material.dart';" in content:
            content = content.replace(
                "import 'package:flutter/material.dart';",
                "import 'package:flutter/material.dart';\nimport 'package:apartment/l10n/app_localizations.dart';"
            )

    # Make sure l10n is defined in build
    if "final l10n = AppLocalizations.of(context)!;" not in content:
        content = content.replace(
            "Widget build(BuildContext context) {",
            "Widget build(BuildContext context) {\n    final l10n = AppLocalizations.of(context)!;"
        )

    for old, new in replacements.items():
        content = content.replace(old, new)

    with open(path, "w", encoding="utf-8") as f:
        f.write(content)

# File 1: unit_selection_bottom_sheet.dart
f1 = "lib/features/design_studio/presentation/widgets/unit_selection_bottom_sheet.dart"
rep1 = {
    "'اختر الوحدة المراد تصميمها'": "l10n.selectUnitToDesign",
    "'المساحة: ${unit.area} م²'": "l10n.areaSquareMeters(unit.area)",
    "'مساحة تقديرية (بدون وحدة)'": "l10n.estimatedAreaNoUnit",
    "'للحصول على تقدير تكلفة مبدئي فقط'": "l10n.forInitialCostEstimateOnly"
}
replace_in_file(f1, rep1)

# File 2: design_studio_screen.dart
f2 = "lib/features/design_studio/presentation/screens/design_studio_screen.dart"
rep2 = {
    "title: 'تصفح باقات التشطيب'": "title: l10n.browseFinishingPackages",
    "subtitle: 'استكشف الباقات الجاهزة والمصممة بعناية لتناسب احتياجاتك.'": "subtitle: l10n.exploreTailoredPackages",
    "title: 'تصميماتي المحفوظة'": "title: l10n.mySavedDesigns",
    "subtitle: 'العودة لمشاهدة التصاميم التي حفظتها مسبقاً.'": "subtitle: l10n.returnToSavedDesigns",
    "'المسارات المتاحة'": "l10n.availablePaths",
    "'سيتم إضافة هذه الميزة قريباً!'": "l10n.featureComingSoon",
    "'معمل التصميم'": "l10n.designLab",
    "'استوديو التصميم'": "l10n.designStudio",
    "'دعنا نبني منزل أحلامك بأحدث تقنيات التصميم.'": "l10n.buildDreamHomeSubtitle",
    "isCustom ? 'مساحة تقديرية (${state.baseArea} م²)' : 'وحدة: ${state.selectedUnit?.title.split(' ')[0]}'": "isCustom ? l10n.estimatedAreaTitle(state.baseArea.toString()) : l10n.unitTitle(state.selectedUnit?.title.split(' ')[0] ?? '')",
    "'التصميم لـ: $title'": "l10n.designForTitle(title)",
    "'اكتشف نمطك بالذكاء الاصطناعي'": "l10n.discoverStyleAI",
    "'أجب على بعض الأسئلة وسنقوم بتوليد تصميم داخلي متكامل مخصص لذوقك.'": "l10n.answerQuestionsForAI",
    "'ابدأ التجربة'": "l10n.startExperience",
    "'مساعد الذكاء الاصطناعي'": "l10n.aiAssistant",
    "'هذه الميزة تحت التطوير حالياً.\\nقريباً ستتمكن من تصميم شقتك ورؤيتها بالواقع الافتراضي قبل التنفيذ!'": "l10n.aiFeatureUnderDevelopment",
    "'حسناً، بانتظار ذلك'": "l10n.okWaitingForIt"
}

# The build function in design_studio_screen.dart is `Widget build(BuildContext context) {` which is common.
# Wait, let's fix the variable substitution for 'التصميم لـ: $title' -> l10n.designForTitle(title)
# Note that string interpolation was `'التصميم لـ: $title'` not `'التصميم لـ: ' + title`. So my replace covers it if it exactly matches.
# Wait, `$title` needs to be replaced. I used the exact string.

replace_in_file(f2, rep2)

print("Design Studio files updated.")
