import os

def replace_in_file(path, replacements):
    with open(path, "r", encoding="utf-8") as f:
        content = f.read()

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

# File 1: contract_financial_card.dart
f1 = "lib/features/profile/presentation/widgets/contract_financial_card.dart"
rep1 = {
    "'الملخص المالي'": "l10n.financialSummary",
    "'إجمالي قيمة التعاقد'": "l10n.totalContractValue",
    "'المدفوع (مقدم + أقساط)'": "l10n.paidAmountLabel",
    "'المتبقي'": "l10n.remainingAmountLabel"
}
replace_in_file(f1, rep1)

# File 2: contract_details_card.dart
f2 = "lib/features/profile/presentation/widgets/contract_details_card.dart"
rep2 = {
    "'تفاصيل الوحدة والمشروع'": "l10n.unitAndProjectDetails",
    "'المشروع'": "l10n.projectLabel",
    "'الوحدة'": "l10n.unitLabel",
    "'تاريخ التعاقد'": "l10n.contractDateLabel",
    "'اسم المالك'": "l10n.ownerNameLabel"
}
replace_in_file(f2, rep2)

# File 3: unit_progress_screen.dart
f3 = "lib/features/profile/presentation/screens/unit_progress_screen.dart"
rep3 = {
    "'متابعة التشطيب'": "l10n.finishingProgressTitle",
    "const Text(\n          l10n.finishingProgressTitle": "Text(\n          l10n.finishingProgressTitle"
}
replace_in_file(f3, rep3)

print("Profile files updated.")
