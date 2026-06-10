import 'dart:io';

void main() {
  final file = File('lib/features/projects/presentation/screens/unit_details_screen.dart');
  if (file.existsSync()) {
    var content = file.readAsStringSync();
    content = content.replaceFirst(
      'color: context.colors.primary',
      'color: context.colors.textPrimary'
    );
    file.writeAsStringSync(content);
  }
}
