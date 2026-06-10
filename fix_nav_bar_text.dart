import 'dart:io';

void main() {
  final file = File('lib/features/layout/presentation/widgets/custom_bottom_nav_bar.dart');
  if (file.existsSync()) {
    var content = file.readAsStringSync();
    content = content.replaceFirst(
      'color: isSelected ? context.colors.primary : context.colors.textSecondary,',
      'color: isSelected ? context.colors.textPrimary : context.colors.textSecondary,'
    );
    file.writeAsStringSync(content);
  }
}
