import 'dart:io';

void main() async {
  // 1. booking_order_details.dart
  var f1 = File('lib/features/custom_finishing/presentation/screens/widgets/booking_order_details.dart');
  var c1 = await f1.readAsString();
  c1 = c1.replaceAll("Text('تم نسخ رقم الطلب بنجاح')", 'Text(AppLocalizations.of(context)!.orderNumberCopiedSuccessfully)');
  await f1.writeAsString(c1);
}
