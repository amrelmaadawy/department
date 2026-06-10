import 'dart:io';

void main() {
  final file1 = File('lib/features/design_studio/presentation/screens/design_studio_screen.dart');
  if (file1.existsSync()) {
    String content = file1.readAsStringSync();
    // Replace specific lines safely
    content = content.replaceFirst('color: context.colors.white,\n                                fontSize: AppFonts.bodySmall,', 'color: Colors.white,\n                                fontSize: AppFonts.bodySmall,');
    content = content.replaceFirst('color: context.colors.white,\n                      fontSize: AppFonts.displayMedium,', 'color: Colors.white,\n                      fontSize: AppFonts.displayMedium,');
    content = content.replaceFirst('color: context.colors.white.withValues(alpha: 0.8),\n                      fontSize: AppFonts.bodyLarge,', 'color: Colors.white.withValues(alpha: 0.8),\n                      fontSize: AppFonts.bodyLarge,');
    
    // Bottom sheet trigger
    content = content.replaceFirst('color: context.colors.white.withValues(alpha: 0.1),\n              border: Border.all(color: context.colors.white.withValues(alpha: 0.3)),', 'color: Colors.white.withValues(alpha: 0.1),\n              border: Border.all(color: Colors.white.withValues(alpha: 0.3)),');
    content = content.replaceFirst('isCustom ? FluentIcons.ruler_16_regular : FluentIcons.building_16_regular,\n                  color: context.colors.white,', 'isCustom ? FluentIcons.ruler_16_regular : FluentIcons.building_16_regular,\n                  color: Colors.white,');
    content = content.replaceFirst('\'التصميم لـ: \$title\',\n                  style: TextStyle(\n                    color: context.colors.white,', '\'التصميم لـ: \$title\',\n                  style: TextStyle(\n                    color: Colors.white,');
    content = content.replaceFirst('Icon(FluentIcons.chevron_down_16_regular, color: context.colors.white', 'Icon(FluentIcons.chevron_down_16_regular, color: Colors.white');
    
    file1.writeAsStringSync(content);
  }

  final file2 = File('lib/features/onboarding/presentation/screens/onboarding_screen.dart');
  if (file2.existsSync()) {
    String content = file2.readAsStringSync();
    
    // Subtitle
    content = content.replaceFirst('color: context.colors.white,\n                                fontSize: AppFonts.bodyMedium,\n                                height: 1.5,', 'color: Colors.white,\n                                fontSize: AppFonts.bodyMedium,\n                                height: 1.5,');
    
    // Skip Button
    content = content.replaceFirst('foregroundColor: context.colors.white,\n                  ),\n                  child: Text(\n                    l10n.skip,', 'foregroundColor: Colors.white,\n                  ),\n                  child: Text(\n                    l10n.skip,');
    
    // Next/Start Text
    content = content.replaceFirst('color: context.colors.white,\n                                              fontSize: AppFonts.bodyMedium,\n                                              fontWeight: FontWeight.bold,', 'color: Colors.white,\n                                              fontSize: AppFonts.bodyMedium,\n                                              fontWeight: FontWeight.bold,');
    
    // Icon
    content = content.replaceFirst('color: context.colors.white,\n                                            size: 20,', 'color: Colors.white,\n                                            size: 20,');

    file2.writeAsStringSync(content);
  }
}
