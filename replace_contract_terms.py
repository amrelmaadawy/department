import os

file_path = "lib/features/contracts/presentation/widgets/contract/contract_terms_card.dart"

with open(file_path, "r", encoding="utf-8") as f:
    content = f.read()

# Add AppLocalizations
if "import '../../../../../l10n/app_localizations.dart';" not in content:
    content = content.replace(
        "import '../../../../../core/theme/app_fonts.dart';",
        "import '../../../../../core/theme/app_fonts.dart';\nimport '../../../../../l10n/app_localizations.dart';"
    )

content = content.replace(
    "Widget build(BuildContext context) {",
    "Widget build(BuildContext context) {\n    final l10n = AppLocalizations.of(context)!;"
)

# Replace terms texts
content = content.replace(
    "'''1. الحجز المبدئي يخضع للموافقة النهائية من قبل المطور.\n2. الأسعار المذكورة هي تقديرات أولية وقد تتغير بناءً على القياسات النهائية.\n3. عربون الحجز غير مسترد بعد مرور 14 يومًا من هذا الاتفاق.\n4. يلتزم المشتري باستكمال الدفعة المقدمة خلال الجدول الزمني المحدد.\n5. تعتبر جميع المخططات والمواصفات المرفقة جزءًا لا يتجزأ من هذا العقد.\n... [المزيد من البنود القانونية]'''",
    "l10n.unitContractTerms"
)

content = content.replace(
    "'''1. يتعهد المقاول بتنفيذ أعمال التشطيب وفقاً للمواصفات المعتمدة.\n2. الأسعار المذكورة تشمل توريد الخامات والمصنعية معاً.\n3. يلتزم العميل بدفع الدفعات المالية حسب نسب الإنجاز المتفق عليها.\n4. يضمن المقاول جودة الأعمال المنفذة لمدة عام كامل من تاريخ الاستلام.\n5. أي تعديلات على التصميم بعد بدء التنفيذ تخضع لتسعير منفصل.\n... [المزيد من البنود القانونية]'''",
    "l10n.finishingContractTerms"
)

with open(file_path, "w", encoding="utf-8") as f:
    f.write(content)

print("Contract terms UI updated.")
