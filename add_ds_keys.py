import json
import os

new_keys_ar = {
    "selectUnitToDesign": "اختر الوحدة المراد تصميمها",
    "areaSquareMeters": "المساحة: {area} م²",
    "@areaSquareMeters": {
        "placeholders": {
            "area": {
                "type": "String"
            }
        }
    },
    "estimatedAreaNoUnit": "مساحة تقديرية (بدون وحدة)",
    "forInitialCostEstimateOnly": "للحصول على تقدير تكلفة مبدئي فقط",
    "availablePaths": "المسارات المتاحة",
    "browseFinishingPackages": "تصفح باقات التشطيب",
    "exploreTailoredPackages": "استكشف الباقات الجاهزة والمصممة بعناية لتناسب احتياجاتك.",
    "mySavedDesigns": "تصميماتي المحفوظة",
    "returnToSavedDesigns": "العودة لمشاهدة التصاميم التي حفظتها مسبقاً.",
    "featureComingSoon": "سيتم إضافة هذه الميزة قريباً!",
    "designLab": "معمل التصميم",
    "designStudio": "استوديو التصميم",
    "buildDreamHomeSubtitle": "دعنا نبني منزل أحلامك بأحدث تقنيات التصميم.",
    "estimatedAreaTitle": "مساحة تقديرية ({area} م²)",
    "@estimatedAreaTitle": {
        "placeholders": {
            "area": {
                "type": "String"
            }
        }
    },
    "unitTitle": "وحدة: {unit}",
    "@unitTitle": {
        "placeholders": {
            "unit": {
                "type": "String"
            }
        }
    },
    "designForTitle": "التصميم لـ: {title}",
    "@designForTitle": {
        "placeholders": {
            "title": {
                "type": "String"
            }
        }
    },
    "discoverStyleAI": "اكتشف نمطك بالذكاء الاصطناعي",
    "answerQuestionsForAI": "أجب على بعض الأسئلة وسنقوم بتوليد تصميم داخلي متكامل مخصص لذوقك.",
    "startExperience": "ابدأ التجربة",
    "aiAssistant": "مساعد الذكاء الاصطناعي",
    "aiFeatureUnderDevelopment": "هذه الميزة تحت التطوير حالياً.\\nقريباً ستتمكن من تصميم شقتك ورؤيتها بالواقع الافتراضي قبل التنفيذ!",
    "okWaitingForIt": "حسناً، بانتظار ذلك"
}

new_keys_en = {
    "selectUnitToDesign": "Select Unit to Design",
    "areaSquareMeters": "Area: {area} m²",
    "@areaSquareMeters": {
        "placeholders": {
            "area": {
                "type": "String"
            }
        }
    },
    "estimatedAreaNoUnit": "Estimated Area (No Unit)",
    "forInitialCostEstimateOnly": "For initial cost estimate only",
    "availablePaths": "Available Paths",
    "browseFinishingPackages": "Browse Finishing Packages",
    "exploreTailoredPackages": "Explore ready-made and carefully tailored packages to suit your needs.",
    "mySavedDesigns": "My Saved Designs",
    "returnToSavedDesigns": "Return to view designs you've previously saved.",
    "featureComingSoon": "This feature will be added soon!",
    "designLab": "Design Lab",
    "designStudio": "Design Studio",
    "buildDreamHomeSubtitle": "Let's build your dream home with the latest design technologies.",
    "estimatedAreaTitle": "Estimated Area ({area} m²)",
    "@estimatedAreaTitle": {
        "placeholders": {
            "area": {
                "type": "String"
            }
        }
    },
    "unitTitle": "Unit: {unit}",
    "@unitTitle": {
        "placeholders": {
            "unit": {
                "type": "String"
            }
        }
    },
    "designForTitle": "Design for: {title}",
    "@designForTitle": {
        "placeholders": {
            "title": {
                "type": "String"
            }
        }
    },
    "discoverStyleAI": "Discover your style with AI",
    "answerQuestionsForAI": "Answer a few questions and we'll generate a complete interior design customized to your taste.",
    "startExperience": "Start Experience",
    "aiAssistant": "AI Assistant",
    "aiFeatureUnderDevelopment": "This feature is currently under development.\\nSoon you will be able to design your apartment and see it in VR before execution!",
    "okWaitingForIt": "OK, waiting for it"
}

def add_keys(path, new_keys):
    with open(path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    for k, v in new_keys.items():
        if isinstance(v, str):
            data[k] = v.replace('\\n', '\n')
        else:
            data[k] = v
            
    with open(path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

add_keys('lib/l10n/app_ar.arb', new_keys_ar)
add_keys('lib/l10n/app_en.arb', new_keys_en)

print("Design Studio keys added successfully.")
