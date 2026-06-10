import 'dart:io';

void main() {
  final file = File('lib/features/packages/presentation/widgets/package_card_header.dart');
  if (file.existsSync()) {
    String content = file.readAsStringSync();
    content = content.replaceFirst(
      '              bottom: BorderSide(\n                color: isDark\n                    ? Colors.white.withValues(alpha: 0.1)\n                    : Colors.black.withValues(alpha: 0.05),\n                width: 1,\n              ),',
      '              bottom: BorderSide(\n                color: context.colors.textPrimary.withValues(alpha: 0.1),\n                width: 1,\n              ),'
    );
    file.writeAsStringSync(content);
  }
}
