import 'dart:io';

void main() {
  final file = File('lib/features/custom_finishing/presentation/widgets/review/custom_finishing_review_view.dart');
  if (!file.existsSync()) return;
  
  String content = file.readAsStringSync();
  
  // Replace CircularProgressIndicator color
  content = content.replaceFirst(
    'color: context.colors.white,\n                                strokeWidth: 2,',
    'color: Colors.white,\n                                strokeWidth: 2,'
  );
  
  // Replace Text color
  content = content.replaceFirst(
    'fontWeight: FontWeight.bold,\n                                color: context.colors.white,',
    'fontWeight: FontWeight.bold,\n                                color: Colors.white,'
  );
  
  // Replace Icon color
  content = content.replaceFirst(
    'FluentIcons.checkmark_24_filled,\n                              color: context.colors.white,',
    'FluentIcons.checkmark_24_filled,\n                              color: Colors.white,'
  );
  
  file.writeAsStringSync(content);
}
