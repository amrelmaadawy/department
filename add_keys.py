import json
import os

ar_terms = "1. الحجز المبدئي يخضع للموافقة النهائية من قبل المطور.\\n2. الأسعار المذكورة هي تقديرات أولية وقد تتغير بناءً على القياسات النهائية.\\n3. عربون الحجز غير مسترد بعد مرور 14 يومًا من هذا الاتفاق.\\n4. يلتزم المشتري باستكمال الدفعة المقدمة خلال الجدول الزمني المحدد.\\n5. تعتبر جميع المخططات والمواصفات المرفقة جزءًا لا يتجزأ من هذا العقد.\\n... [المزيد من البنود القانونية]"
ar_finishing = "1. يتعهد المقاول بتنفيذ أعمال التشطيب وفقاً للمواصفات المعتمدة.\\n2. الأسعار المذكورة تشمل توريد الخامات والمصنعية معاً.\\n3. يلتزم العميل بدفع الدفعات المالية حسب نسب الإنجاز المتفق عليها.\\n4. يضمن المقاول جودة الأعمال المنفذة لمدة عام كامل من تاريخ الاستلام.\\n5. أي تعديلات على التصميم بعد بدء التنفيذ تخضع لتسعير منفصل.\\n... [المزيد من البنود القانونية]"

en_terms = "1. Initial booking is subject to developer's final approval.\\n2. Prices are estimates and may change based on final measurements.\\n3. Booking deposit is non-refundable after 14 days.\\n4. Buyer commits to completing the down payment within the specified timeline.\\n5. All attached plans and specifications are an integral part of this contract.\\n... [More Legal Terms]"
en_finishing = "1. The contractor undertakes to execute finishing works according to approved specifications.\\n2. Prices include supply of materials and labor.\\n3. Client commits to paying installments based on agreed completion percentages.\\n4. Contractor guarantees quality of work for one full year.\\n5. Any design modifications after execution starts are subject to separate pricing.\\n... [More Legal Terms]"

def add_to_arb(path, terms, finishing):
    with open(path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    data["unitContractTerms"] = terms.replace('\\n', '\n')
    data["finishingContractTerms"] = finishing.replace('\\n', '\n')
    
    with open(path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

add_to_arb('lib/l10n/app_ar.arb', ar_terms, ar_finishing)
add_to_arb('lib/l10n/app_en.arb', en_terms, en_finishing)
print("Keys added successfully.")
