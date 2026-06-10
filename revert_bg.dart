import 'dart:io';

void main() {
  void replaceInFile(String path, String from, String to) {
    final file = File(path);
    if (!file.existsSync()) return;
    final content = file.readAsStringSync();
    file.writeAsStringSync(content.replaceAll(from, to));
  }

  // Revert custom_finishing_bottom_bar.dart
  replaceInFile(
    'lib/features/custom_finishing/presentation/widgets/custom_finishing_bottom_bar.dart',
    'decoration: BoxDecoration(\n        color: Colors.white,',
    'decoration: BoxDecoration(\n        color: context.colors.white,'
  );

  // Revert material_card.dart
  replaceInFile(
    'lib/features/custom_finishing/presentation/widgets/material_card.dart',
    'decoration: BoxDecoration(\n          color: Colors.white,',
    'decoration: BoxDecoration(\n          color: context.colors.white,'
  );
}
