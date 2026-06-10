import 'dart:io';

void main() {
  final file = File('lib/features/packages/presentation/widgets/package_card_styles.dart');
  if (file.existsSync()) {
    List<String> lines = file.readAsLinesSync();
    
    // Replace lines 39 to 59
    lines.removeRange(39, 60);
    
    lines.insertAll(39, [
      '  static LinearGradient getHeaderGradient(BuildContext context, PackageTier tier) {',
      '    switch (tier) {',
      '      case PackageTier.economic:',
      '        return LinearGradient(',
      '          begin: Alignment.topLeft,',
      '          end: Alignment.bottomRight,',
      '          colors: [',
      '            context.colors.white,',
      '            Color.lerp(context.colors.white, context.colors.gold, 0.05)!,',
      '          ],',
      '        );',
      '      case PackageTier.standard:',
      '        return LinearGradient(',
      '          begin: Alignment.topLeft,',
      '          end: Alignment.bottomRight,',
      '          colors: [',
      '            context.colors.white,',
      '            Color.lerp(context.colors.white, context.colors.primary, 0.05)!,',
      '          ],',
      '        );'
    ]);
    
    file.writeAsStringSync(lines.join('\n'));
  }
}
