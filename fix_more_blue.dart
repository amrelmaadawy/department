import 'dart:io';

void main() {
  final filesToFix = [
    'lib/features/projects/presentation/widgets/details/project_overview_tab.dart',
    'lib/features/projects/presentation/widgets/details/project_unit_card.dart',
    'lib/features/projects/presentation/widgets/details/unit/unit_overview_card.dart',
    'lib/features/projects/presentation/widgets/details/unit/unit_bottom_actions.dart',
    'lib/features/projects/presentation/widgets/details/project_service_card.dart',
  ];

  for (final filePath in filesToFix) {
    final file = File(filePath);
    if (file.existsSync()) {
      var content = file.readAsStringSync();
      // Replace only instances where context.colors.primary is used as text color.
      // Usually it's followed by a comma and newline in a TextStyle.
      // Let's just blindly replace all occurrences of `color: context.colors.primary,` 
      // where it's likely a text style. Since we know from grep that these lines are TextStyles mostly.
      content = content.replaceAll(
        'color: context.colors.primary,',
        'color: context.colors.textPrimary,'
      );
      file.writeAsStringSync(content);
      print('Fixed: \$filePath');
    }
  }
}
