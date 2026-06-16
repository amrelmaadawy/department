import 'dart:io';

void main() async {
  // 1. Add keys to app_ar.arb
  var arFile = File('lib/l10n/app_ar.arb');
  var arContent = await arFile.readAsString();
  
  if (!arContent.contains('"unitContractTerms"')) {
    final newArKeys = '''  "unitContractTerms": "1. الحجز المبدئي يخضع للموافقة النهائية من قبل المطور.\\n2. الأسعار المذكورة هي تقديرات أولية وقد تتغير بناءً على القياسات النهائية.\\n3. عربون الحجز غير مسترد بعد مرور 14 يومًا من هذا الاتفاق.\\n4. يلتزم المشتري باستكمال الدفعة المقدمة خلال الجدول الزمني المحدد.\\n5. تعتبر جميع المخططات والمواصفات المرفقة جزءًا لا يتجزأ من هذا العقد.\\n... [المزيد من البنود القانونية]",
  "finishingContractTerms": "1. يتعهد المقاول بتنفيذ أعمال التشطيب وفقاً للمواصفات المعتمدة.\\n2. الأسعار المذكورة تشمل توريد الخامات والمصنعية معاً.\\n3. يلتزم العميل بدفع الدفعات المالية حسب نسب الإنجاز المتفق عليها.\\n4. يضمن المقاول جودة الأعمال المنفذة لمدة عام كامل من تاريخ الاستلام.\\n5. أي تعديلات على التصميم بعد بدء التنفيذ تخضع لتسعير منفصل.\\n... [المزيد من البنود القانونية]",
''';
    // Insert before the last closing brace
    final lastBraceIndex = arContent.lastIndexOf('}');
    arContent = '${arContent.substring(0, lastBraceIndex)},\n$newArKeys\n}';
    // Fix potential trailing commas
    arContent = arContent.replaceAll(',,', ',');
    await arFile.writeAsString(arContent);
  }

  // 2. Add keys to app_en.arb
  var enFile = File('lib/l10n/app_en.arb');
  var enContent = await enFile.readAsString();
  
  if (!enContent.contains('"unitContractTerms"')) {
    final newEnKeys = '''  "unitContractTerms": "1. Initial booking is subject to developer's final approval.\\n2. Prices are estimates and may change based on final measurements.\\n3. Booking deposit is non-refundable after 14 days.\\n4. Buyer commits to completing the down payment within the specified timeline.\\n5. All attached plans and specifications are an integral part of this contract.\\n... [More Legal Terms]",
  "finishingContractTerms": "1. The contractor undertakes to execute finishing works according to approved specifications.\\n2. Prices include supply of materials and labor.\\n3. Client commits to paying installments based on agreed completion percentages.\\n4. Contractor guarantees quality of work for one full year.\\n5. Any design modifications after execution starts are subject to separate pricing.\\n... [More Legal Terms]",
''';
    final lastBraceIndex = enContent.lastIndexOf('}');
    enContent = '${enContent.substring(0, lastBraceIndex)},\n$newEnKeys\n}';
    enContent = enContent.replaceAll(',,', ',');
    await enFile.writeAsString(enContent);
  }
}
