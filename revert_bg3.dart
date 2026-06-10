import 'dart:io';

void main() {
  final bottomBar = File('lib/features/custom_finishing/presentation/widgets/custom_finishing_bottom_bar.dart');
  if (bottomBar.existsSync()) {
    String content = bottomBar.readAsStringSync();
    content = content.replaceFirst(
      RegExp(r'decoration:\s*BoxDecoration\(\s*color:\s*Colors\.white,'),
      'decoration: BoxDecoration(\n        color: context.colors.white,'
    );
    bottomBar.writeAsStringSync(content);
  }

  final materialCard = File('lib/features/custom_finishing/presentation/widgets/material_card.dart');
  if (materialCard.existsSync()) {
    String content = materialCard.readAsStringSync();
    content = content.replaceFirst(
      RegExp(r'decoration:\s*BoxDecoration\(\s*color:\s*Colors\.white,'),
      'decoration: BoxDecoration(\n          color: context.colors.white,'
    );
    materialCard.writeAsStringSync(content);
  }
}
