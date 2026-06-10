import 'dart:io';

void main() {
  final file = File('lib/features/packages/presentation/widgets/package_card_features.dart');
  if (file.existsSync()) {
    String content = file.readAsStringSync();
    
    // Replace the BoxDecoration
    content = content.replaceFirst(
      '      decoration: BoxDecoration(\n        color: isDark ? Colors.transparent : Colors.white,\n      ),',
      '      decoration: const BoxDecoration(\n        color: Colors.transparent,\n      ),'
    );
    
    file.writeAsStringSync(content);
  }
}
