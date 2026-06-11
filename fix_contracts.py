import os

file_path = "lib/features/custom_finishing/presentation/screens/contracts_review_screen.dart"

with open(file_path, "r", encoding="utf-8") as f:
    content = f.read()

# Add import
if "import '../../../../l10n/app_localizations.dart';" not in content:
    content = content.replace(
        "import 'package:apartment/core/theme/theme_extension.dart';",
        "import 'package:apartment/core/theme/theme_extension.dart';\nimport '../../../../l10n/app_localizations.dart';"
    )

# Add l10n in build
content = content.replace(
    "Widget build(BuildContext context) {",
    "Widget build(BuildContext context) {\n    final l10n = AppLocalizations.of(context)!;"
)

# Add l10n in _buildContractCard
content = content.replace(
    "Widget _buildContractCard({",
    "Widget _buildContractCard({\n    required BuildContext context,"
)
content = content.replace(
    "required VoidCallback onSign,\n  }) {",
    "required VoidCallback onSign,\n  }) {\n    final l10nCard = AppLocalizations.of(context)!;"
)

# Replace titles with context injection
content = content.replace(
    "_buildContractCard(\n            title: 'عقد بيع وحدة عقارية'",
    "_buildContractCard(\n            context: context,\n            title: 'عقد بيع وحدة عقارية'"
)
content = content.replace(
    "_buildContractCard(\n            title: 'عقد مقاولة تشطيب'",
    "_buildContractCard(\n            context: context,\n            title: 'عقد مقاولة تشطيب'"
)

# Replace texts
content = content.replace("'مراجعة وتوقيع العقود'", "l10n.reviewAndSignContracts")
content = content.replace("'إجمالي التكلفة النهائية'", "l10n.finalTotalCost")
content = content.replace("'ر.س'", "l10n.sar")
content = content.replace("'العقود المطلوبة للتوقيع'", "l10n.contractsRequiredForSignature")
content = content.replace("'عقد بيع وحدة عقارية'", "l10n.propertySaleContract")
content = content.replace("'تفاصيل الوحدة'", "l10n.unitDetailsDefault")
content = content.replace("'وحدة ${unit.title} بمساحة ${unit.area}م²'", "l10n.unitDetailsWithArea(unit.title, unit.area.toString())")
content = content.replace("'عقد مقاولة تشطيب'", "l10n.finishingContract")
content = content.replace("'تشطيب مخصص شامل الخامات والمصنعية'", "l10n.customFinishingComprehensive")
content = content.replace("'إتمام الحجز والدفع'", "l10n.completeBookingAndPayment")
content = content.replace("'توقيع الآن'", "l10nCard.signNow")

with open(file_path, "w", encoding="utf-8") as f:
    f.write(content)

print("Done")
