import 'dart:io';

void main() async {
  // 1. Add keys to app_ar.arb
  var arFile = File('lib/l10n/app_ar.arb');
  var arContent = await arFile.readAsString();
  
  if (!arContent.contains('"loginSuccess"')) {
    final newArKeys = '''  "loginSuccess": "تم تسجيل الدخول بنجاح!",
  "registerSuccess": "تم إنشاء الحساب بنجاح!"''';
    // Insert before the last closing brace
    final lastBraceIndex = arContent.lastIndexOf('}');
    arContent = arContent.substring(0, lastBraceIndex) + ',\n' + newArKeys + '\n}';
    await arFile.writeAsString(arContent);
  }

  // 2. Add keys to app_en.arb
  var enFile = File('lib/l10n/app_en.arb');
  var enContent = await enFile.readAsString();
  
  if (!enContent.contains('"loginSuccess"')) {
    final newEnKeys = '''  "loginSuccess": "Logged in Successfully!",
  "registerSuccess": "Account Created Successfully!"''';
    // Insert before the last closing brace
    final lastBraceIndex = enContent.lastIndexOf('}');
    enContent = enContent.substring(0, lastBraceIndex) + ',\n' + newEnKeys + '\n}';
    await enFile.writeAsString(enContent);
  }

  print('Success messages added.');
}
