import 'package:apartment/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/utils/app_bloc_observer.dart';

import 'core/constants/app_constants.dart';
import 'core/di/injection_container.dart' as di;
import 'core/routes/app_router.dart';
import 'core/localization/cubit/locale_cubit.dart';
import 'core/localization/cubit/locale_state.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/cubit/theme_cubit.dart';
import 'core/theme/cubit/theme_state.dart';
import 'core/network/cubit/network_cubit.dart';
import 'core/network/cubit/network_state.dart';
import 'core/presentation/widgets/offline_banner.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.sl<LocaleCubit>()),
        BlocProvider(create: (context) => di.sl<ThemeCubit>()),
        BlocProvider(create: (context) => di.sl<NetworkCubit>()..startMonitoring()),
      ],
      child: BlocBuilder<LocaleCubit, LocaleState>(
        builder: (context, localeState) {
          return BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, themeState) {
              return MaterialApp.router(
                title: AppConstants.appName,
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeState.themeMode,
                routerConfig: AppRouter.router,
                locale: localeState.locale,
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
                    child: BlocListener<NetworkCubit, NetworkState>(
                      listener: (context, state) {
                        int retries = 0;
                        void showBanner() {
                          final overlayContext = AppRouter.navigatorKey.currentContext;
                          if (overlayContext != null && Overlay.maybeOf(overlayContext) != null) {
                            if (state is NetworkOffline || state is NetworkNoInternet) {
                              OfflineBanner.showOffline(overlayContext);
                            } else if (state is NetworkOnline) {
                              OfflineBanner.showRestored(overlayContext);
                            }
                          } else {
                            if (retries < 5) {
                              retries++;
                              Future.delayed(const Duration(milliseconds: 500), showBanner);
                            }
                          }
                        }
                        showBanner();
                      },
                      child: child!,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
