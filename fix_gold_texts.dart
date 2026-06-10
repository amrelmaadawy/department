import 'dart:io';

void main() {
  void replaceInFile(String path, String from, String to) {
    final file = File(path);
    if (!file.existsSync()) return;
    final content = file.readAsStringSync();
    file.writeAsStringSync(content.replaceAll(from, to));
  }

  // 1. project_units_tab.dart
  replaceInFile(
    'lib/features/projects/presentation/widgets/details/project_units_tab.dart',
    'color: isSelected ? context.colors.white : context.colors.textPrimary,',
    'color: isSelected ? Colors.white : context.colors.textPrimary,'
  );

  // 2. finishing_category_tabs.dart
  replaceInFile(
    'lib/features/custom_finishing/presentation/widgets/finishing_category_tabs.dart',
    'color: isSelected\n                          ? context.colors.white\n                          : context.colors.textPrimary.withValues(alpha: 0.6),',
    'color: isSelected\n                          ? Colors.white\n                          : context.colors.textPrimary.withValues(alpha: 0.6),'
  );

  // 3. booking_success_actions.dart
  replaceInFile(
    'lib/features/custom_finishing/presentation/screens/widgets/booking_success_actions.dart',
    'color: context.colors.white,',
    'color: Colors.white,'
  );

  // 4. custom_finishing_bottom_bar.dart
  replaceInFile(
    'lib/features/custom_finishing/presentation/widgets/custom_finishing_bottom_bar.dart',
    'color: context.colors.white,',
    'color: Colors.white,'
  );

  // 5. material_card.dart
  replaceInFile(
    'lib/features/custom_finishing/presentation/widgets/material_card.dart',
    'color: context.colors.white,',
    'color: Colors.white,'
  );
  
  // Also check material_card.dart for other usages
  replaceInFile(
    'lib/features/custom_finishing/presentation/widgets/material_card.dart',
    'color: context.colors.white.withValues(alpha: 0.2)',
    'color: Colors.white.withValues(alpha: 0.2)'
  );
}
