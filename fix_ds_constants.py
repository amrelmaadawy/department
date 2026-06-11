import os

# Fix unit_selection_bottom_sheet.dart
f1 = "lib/features/design_studio/presentation/widgets/unit_selection_bottom_sheet.dart"
with open(f1, "r", encoding="utf-8") as f:
    c1 = f.read()

c1 = c1.replace("l10n.areaSquareMeters(unit.area)", "l10n.areaSquareMeters(unit.area.toString())")

with open(f1, "w", encoding="utf-8") as f:
    f.write(c1)

# Fix design_studio_screen.dart
f2 = "lib/features/design_studio/presentation/screens/design_studio_screen.dart"
with open(f2, "r", encoding="utf-8") as f:
    c2 = f.read()

# I will just remove the 'const' keyword that precedes the localized texts
c2 = c2.replace("const Text(\n                              l10n.designLab", "Text(\n                              l10n.designLab")
c2 = c2.replace("const Text(\n                    l10n.designStudio", "Text(\n                    l10n.designStudio")
c2 = c2.replace("const Text(\n                    l10n.buildDreamHomeSubtitle", "Text(\n                    l10n.buildDreamHomeSubtitle")
c2 = c2.replace("const SnackBar(content: Text(l10n.featureComingSoon))", "SnackBar(content: Text(l10n.featureComingSoon))")
c2 = c2.replace("const Text(\n                  l10n.discoverStyleAI", "Text(\n                  l10n.discoverStyleAI")
c2 = c2.replace("const Text(\n                  l10n.answerQuestionsForAI", "Text(\n                  l10n.answerQuestionsForAI")
c2 = c2.replace("const Text(\n                      l10n.startExperience", "Text(\n                      l10n.startExperience")
c2 = c2.replace("const Text(\n              l10n.aiAssistant", "Text(\n              l10n.aiAssistant")
c2 = c2.replace("const Text(\n              l10n.aiFeatureUnderDevelopment", "Text(\n              l10n.aiFeatureUnderDevelopment")
c2 = c2.replace("const Text(\n                  l10n.okWaitingForIt", "Text(\n                  l10n.okWaitingForIt")

with open(f2, "w", encoding="utf-8") as f:
    f.write(c2)

print("Fixed constants and type errors.")
