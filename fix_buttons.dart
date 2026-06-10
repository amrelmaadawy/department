import 'dart:io';

void main() {
  final files = [
    'lib/features/projects/presentation/widgets/details/project_service_card.dart',
    'lib/features/profile/presentation/screens/unit_contract_screen.dart',
    'lib/features/contracts/presentation/screens/contract_preview_screen.dart',
    'lib/features/contracts/presentation/widgets/contract/contract_bottom_actions.dart',
    'lib/core/widgets/error_state_view.dart',
  ];
  
  for (var path in files) {
    final file = File(path);
    if (!file.existsSync()) continue;
    
    String content = file.readAsStringSync();
    
    // Replace textColor: context.colors.white with textColor: Colors.white
    content = content.replaceAll(
      'textColor: context.colors.white',
      'textColor: Colors.white'
    );
    
    file.writeAsStringSync(content);
  }
}
