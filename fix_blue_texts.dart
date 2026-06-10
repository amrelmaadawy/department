import 'dart:io';

void main() {
  // 1. project_info_section.dart
  final f1 = File('lib/features/projects/presentation/widgets/details/project_info_section.dart');
  if (f1.existsSync()) {
    var c1 = f1.readAsStringSync();
    c1 = c1.replaceFirst(
      'color: context.colors.primary,',
      'color: context.colors.textPrimary,'
    );
    f1.writeAsStringSync(c1);
  }

  // 2. custom_finishing_review_view.dart
  final f2 = File('lib/features/custom_finishing/presentation/widgets/review/custom_finishing_review_view.dart');
  if (f2.existsSync()) {
    var c2 = f2.readAsStringSync();
    c2 = c2.replaceFirst(
      'color: context.colors.primary,\n                  letterSpacing: -0.5,',
      'color: context.colors.textPrimary,\n                  letterSpacing: -0.5,'
    );
    f2.writeAsStringSync(c2);
  }

  // 3. unit_cost_estimation_card.dart
  final f3 = File('lib/features/projects/presentation/widgets/details/unit/unit_cost_estimation_card.dart');
  if (f3.existsSync()) {
    var c3 = f3.readAsStringSync();
    c3 = c3.replaceFirst(
      'color: context.colors.primary,\n                  ),\n                ),\n              ],\n            ),\n          ),\n\n          Divider(height: 1, color: context.colors.border),',
      'color: context.colors.textPrimary,\n                  ),\n                ),\n              ],\n            ),\n          ),\n\n          Divider(height: 1, color: context.colors.border),'
    );
    f3.writeAsStringSync(c3);
  }
}
