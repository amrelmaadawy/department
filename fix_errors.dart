import 'dart:io';

void main() async {
  final dir = Directory('lib/features');
  final files = await dir.list(recursive: true).toList();

  for (var entity in files) {
    if (entity is File && entity.path.endsWith('.dart')) {
      String content = await entity.readAsString();
      bool changed = false;

      // Fix const context.colors.white -> context.colors.white and remove const if possible
      // Actually, it's easier to just remove 'const ' when it precedes 'context.colors'
      if (content.contains('const context.colors')) {
        content = content.replaceAll('const context.colors', 'context.colors');
        changed = true;
      }
      
      // Fix Appcontext.colors -> AppColors
      if (content.contains('Appcontext.colors')) {
        content = content.replaceAll('Appcontext.colors', 'AppColors');
        changed = true;
      }

      // Sometimes removing const from context.colors might leave an invalid const parent.
      // For instance: const Icon(..., color: context.colors.white) -> Icon(..., color: context.colors.white)
      final regex = RegExp(r'const\s+([A-Za-z0-9_]+)\([^)]*context\.colors\.[a-zA-Z]+');
      while (regex.hasMatch(content)) {
        content = content.replaceFirstMapped(regex, (match) {
          return match.group(0)!.replaceFirst('const ', '');
        });
        changed = true;
      }

      if (changed) {
        await entity.writeAsString(content);
        print('Fixed constants in: ${entity.path}');
      }
    }
  }
}
