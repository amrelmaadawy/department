import 'dart:io';

void main() {
  final file1 = File('lib/features/packages/presentation/widgets/package_card_styles.dart');
  if (file1.existsSync()) {
    String content = file1.readAsStringSync();
    
    // Replace getHeaderGradient
    content = content.replaceFirst(
      'static LinearGradient getHeaderGradient(PackageTier tier) {\n    switch (tier) {\n      case PackageTier.economic:\n        return const LinearGradient(\n          begin: Alignment.topLeft,\n          end: Alignment.bottomRight,\n          colors: [\n            Color(0xFFFFFFFF),\n            Color(0xFFFBF4E6), // Warm goldish white\n          ],\n        );\n      case PackageTier.standard:\n        return const LinearGradient(\n          begin: Alignment.topLeft,\n          end: Alignment.bottomRight,\n          colors: [\n            Color(0xFFFFFFFF),\n            Color(0xFFE8F0F6), // Cool icy silver\n          ],\n        );',
      '''static LinearGradient getHeaderGradient(BuildContext context, PackageTier tier) {
    switch (tier) {
      case PackageTier.economic:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.colors.white,
            Color.lerp(context.colors.white, context.colors.gold, 0.05)!, // Warm goldish tint
          ],
        );
      case PackageTier.standard:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.colors.white,
            Color.lerp(context.colors.white, context.colors.primary, 0.05)!, // Cool icy tint
          ],
        );'''
    );
    
    file1.writeAsStringSync(content);
  }

  final file2 = File('lib/features/packages/presentation/widgets/package_card.dart');
  if (file2.existsSync()) {
    String content = file2.readAsStringSync();
    
    // Pass context to getHeaderGradient
    content = content.replaceFirst(
      'gradient: PackageCardStyles.getHeaderGradient(package.tier),',
      'gradient: PackageCardStyles.getHeaderGradient(context, package.tier),'
    );
    
    file2.writeAsStringSync(content);
  }
}
