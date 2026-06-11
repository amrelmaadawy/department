import 'dart:io';

void main() async {
  final dir = Directory('lib/features');
  final files = await dir.list(recursive: true).toList();

  int updatedFiles = 0;

  for (var entity in files) {
    if (entity is File && entity.path.endsWith('.dart') && !entity.path.endsWith('.g.dart')) {
      String content = await entity.readAsString();
      bool changed = false;

      // Replace Colors.white -> context.colors.white
      if (content.contains('Colors.white')) {
        content = content.replaceAll('Colors.white', 'context.colors.white');
        changed = true;
      }

      // Replace AppSpacing usages
      // We will leave AppSpacing and AppFonts for later or do simple ones
      
      // If changed, make sure theme_extension is imported
      if (changed) {
        if (!content.contains('theme_extension.dart')) {
          // add import after the last import
          final importIndex = content.lastIndexOf(RegExp(r'import .*;'));
          if (importIndex != -1) {
            final endOfLine = content.indexOf('\n', importIndex);
            content = content.substring(0, endOfLine + 1) +
                "import 'package:apartment/core/theme/theme_extension.dart';\n" +
                content.substring(endOfLine + 1);
          } else {
            content = "import 'package:apartment/core/theme/theme_extension.dart';\n" + content;
          }
        }
        await entity.writeAsString(content);
        updatedFiles++;
        print('Updated: ${entity.path}');
      }
    }
  }

  print('Total files updated: $updatedFiles');
}
