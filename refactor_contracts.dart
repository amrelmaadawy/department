import 'dart:io';

void main() async {
  var f2 = File('lib/features/custom_finishing/presentation/screens/contracts_review_screen.dart');
  var c2 = await f2.readAsString();

  if (!c2.contains("import '../../../../l10n/app_localizations.dart';")) {
      final importIndex = c2.lastIndexOf(RegExp(r'import .*;'));
      final endOfLine = c2.indexOf('\n', importIndex);
      c2 = "${c2.substring(0, endOfLine + 1)}import '../../../../l10n/app_localizations.dart';\n${c2.substring(endOfLine + 1)}";
  }

  // Insert l10n definition in build method
  if (!c2.contains('final l10n = AppLocalizations.of(context)!;')) {
      c2 = c2.replaceAll(
        'Widget build(BuildContext context) {', 
        'Widget build(BuildContext context) {\n    final l10n = AppLocalizations.of(context)!;'
      );
  }

  // Add l10n to _buildContractCard
  if (!c2.contains('final l10nCard = AppLocalizations.of(context)!;')) {
      c2 = c2.replaceAll(
        'Widget _buildContractCard({', 
        'Widget _buildContractCard({\n    required BuildContext context,'
      );
      c2 = c2.replaceAll(
        'required VoidCallback onSign,\n  }) {', 
        'required VoidCallback onSign,\n  }) {\n    final l10nCard = AppLocalizations.of(context)!;'
      );
  }

  // Also need to pass context when calling _buildContractCard
  // Do this BEFORE replacing strings
  c2 = c2.replaceAll("_buildContractCard(\n            title: 'عقد بيع وحدة عقارية'", "_buildContractCard(\n            context: context,\n            title: 'عقد بيع وحدة عقارية'");
  c2 = c2.replaceAll("_buildContractCard(\n            title: 'عقد مقاولة تشطيب'", "_buildContractCard(\n            context: context,\n            title: 'عقد مقاولة تشطيب'");

  // Now replace the strings
  c2 = c2.replaceAll("'مراجعة وتوقيع العقود'", 'l10n.reviewAndSignContracts');
  c2 = c2.replaceAll("'إجمالي التكلفة النهائية'", 'l10n.finalTotalCost');
  c2 = c2.replaceAll("'ر.س'", 'l10n.sar');
  c2 = c2.replaceAll("'العقود المطلوبة للتوقيع'", 'l10n.contractsRequiredForSignature');
  c2 = c2.replaceAll("'عقد بيع وحدة عقارية'", 'l10n.propertySaleContract');
  c2 = c2.replaceAll("'تفاصيل الوحدة'", 'l10n.unitDetailsDefault');
  c2 = c2.replaceAll("'وحدة \${unit.title} بمساحة \${unit.area}م²'", 'l10n.unitDetailsWithArea(unit.title, unit.area.toString())');
  c2 = c2.replaceAll("'عقد مقاولة تشطيب'", 'l10n.finishingContract');
  c2 = c2.replaceAll("'تشطيب مخصص شامل الخامات والمصنعية'", 'l10n.customFinishingComprehensive');
  c2 = c2.replaceAll("'إتمام الحجز والدفع'", 'l10n.completeBookingAndPayment');
  c2 = c2.replaceAll("'توقيع الآن'", 'l10nCard.signNow'); 

  await f2.writeAsString(c2);
}
