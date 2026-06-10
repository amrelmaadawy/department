import 'dart:io';

void main() {
  final path = 'lib/features/custom_finishing/presentation/screens/widgets/booking_order_details.dart';
  final file = File(path);
  if (!file.existsSync()) return;
  
  String content = file.readAsStringSync();
  
  // Replace the specific text block using Regex to ignore exact spaces/newlines
  content = content.replaceAllMapped(
    RegExp(r'Text\(\s*l10n\.expectedVisitDate,\s*style:\s*TextStyle\(\s*fontSize:\s*AppFonts\.bodyMedium,\s*color:\s*context\.colors\.textPrimary\.withValues\(\s*alpha:\s*0\.7,\s*\),\s*\),\s*\),\s*Text\(\s*expectedDateStr'),
    (match) => 'Expanded(\n                child: Text(\n                  l10n.expectedVisitDate,\n                  style: TextStyle(\n                    fontSize: AppFonts.bodyMedium,\n                    color: context.colors.textPrimary.withValues(\n                      alpha: 0.7,\n                    ),\n                  ),\n                ),\n              ),\n              SizedBox(width: AppSpacing.sm),\n              Text(\n                expectedDateStr'
  );

  file.writeAsStringSync(content);
}
