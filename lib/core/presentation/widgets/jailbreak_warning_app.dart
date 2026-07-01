import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JailbreakWarningApp extends StatelessWidget {
  const JailbreakWarningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.security, size: 80, color: Colors.red),
                const SizedBox(height: 24),
                const Text(
                  'غير مسموح بالوصول',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  'لا يمكن تشغيل التطبيق على أجهزة معدّلة أو مكسورة الحماية '
                  'لضمان أمان بياناتك.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => SystemNavigator.pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('إغلاق التطبيق'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
