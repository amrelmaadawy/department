import 'dart:io';

void main() {
  final files = [
    'lib/features/projects/presentation/screens/projects_screen.dart',
  ];
  
  for (var path in files) {
    final file = File(path);
    if (!file.existsSync()) continue;
    
    String content = file.readAsStringSync();
    
    content = content.replaceAllMapped(
      RegExp(r'return Shimmer\.fromColors\(\s*baseColor:\s*Colors\.grey\[300\]!,\s*highlightColor:\s*Colors\.grey\[100\]!,'),
      (match) => 'final isDark = Theme.of(context).brightness == Brightness.dark;\n        return Shimmer.fromColors(\n          baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,\n          highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,'
    );
    
    file.writeAsStringSync(content);
  }
}
