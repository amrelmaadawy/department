import 'dart:io';

void main() {
  void replaceInFile(String path, String from, String to) {
    final file = File(path);
    if (!file.existsSync()) return;
    final content = file.readAsStringSync();
    file.writeAsStringSync(content.replaceAll(from, to));
  }

  // In custom_finishing_bottom_bar.dart
  replaceInFile(
    'lib/features/custom_finishing/presentation/widgets/custom_finishing_bottom_bar.dart',
    'color: Colors.white,',
    'color: context.colors.white,'
  );

  // In material_card.dart
  replaceInFile(
    'lib/features/custom_finishing/presentation/widgets/material_card.dart',
    'color: Colors.white,',
    'color: context.colors.white,'
  );
}
