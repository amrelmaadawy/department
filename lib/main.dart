import 'package:apartment/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/utils/app_bloc_observer.dart';

import 'core/constants/app_constants.dart';
import 'core/di/injection_container.dart' as di;
import 'core/routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();

  Bloc.observer = AppBlocObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Cairo'),
      routerConfig: AppRouter.router,
      locale: const Locale('ar'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) {
        // Global Responsive Text Scaler
        // This calculates the device width compared to a standard 390px phone screen.
        final mediaQuery = MediaQuery.of(context);
        final screenWidth = mediaQuery.size.width;

        // Scale factor: ensures text grows on tablets but doesn't get ridiculously large,
        // and shrinks on extremely small phones so it doesn't overflow.
        final double textScale = (screenWidth / 390.0).clamp(0.85, 1.4);

        return MediaQuery(
          data: mediaQuery.copyWith(textScaler: TextScaler.linear(textScale)),
          child: child!,
        );
      },
    );
  }
}
