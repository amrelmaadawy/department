import json
import os

new_keys_ar = {
    "financialSummary": "الملخص المالي",
    "totalContractValue": "إجمالي قيمة التعاقد",
    "paidAmountLabel": "المدفوع (مقدم + أقساط)",
    "remainingAmountLabel": "المتبقي",
    "unitAndProjectDetails": "تفاصيل الوحدة والمشروع",
    "projectLabel": "المشروع",
    "unitLabel": "الوحدة",
    "contractDateLabel": "تاريخ التعاقد",
    "ownerNameLabel": "اسم المالك",
    "finishingProgressTitle": "متابعة التشطيب"
}

new_keys_en = {
    "financialSummary": "Financial Summary",
    "totalContractValue": "Total Contract Value",
    "paidAmountLabel": "Paid (Down Payment + Installments)",
    "remainingAmountLabel": "Remaining",
    "unitAndProjectDetails": "Unit and Project Details",
    "projectLabel": "Project",
    "unitLabel": "Unit",
    "contractDateLabel": "Contract Date",
    "ownerNameLabel": "Owner Name",
    "finishingProgressTitle": "Finishing Progress"
}

def add_keys(path, new_keys):
    with open(path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    for k, v in new_keys.items():
        data[k] = v
            
    with open(path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

add_keys('lib/l10n/app_ar.arb', new_keys_ar)
add_keys('lib/l10n/app_en.arb', new_keys_en)

print("Profile keys added successfully.")
