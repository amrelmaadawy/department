import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:apartment/core/di/injection_container.dart';
import 'package:apartment/core/routes/app_router.dart';

import '../../../features/profile/presentation/cubit/profile_cubit.dart';
import '../../../features/profile/presentation/screens/profile_screen.dart';
import '../../../features/profile/presentation/screens/app_settings_screen.dart';

import '../../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../../features/profile/presentation/screens/security_screen.dart';
import '../../../features/profile/presentation/screens/my_units_screen.dart';
import '../../../features/profile/presentation/screens/unit_contract_screen.dart';
import '../../../features/profile/presentation/screens/unit_progress_screen.dart';
import '../../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../../features/support/presentation/screens/support_screen.dart';
import '../../../features/profile/presentation/screens/profile_contracts_screen.dart';

class ProfileRoutes {
  static final List<RouteBase> routes = [
    GoRoute(
      path: AppRouter.profile,
      builder: (context, state) => BlocProvider(
        create: (_) => sl<AuthCubit>(),
        child: const ProfileScreen(),
      ),
    ),
    GoRoute(
      path: AppRouter.myUnits,
      builder: (context, state) => BlocProvider(
        create: (_) => sl<ProfileCubit>()..loadProfileIfNeeded(),
        child: const MyUnitsScreen(),
      ),
    ),


    GoRoute(
      path: AppRouter.unitProgress,
      builder: (context, state) => const UnitProgressScreen(),
    ),
    GoRoute(
      path: AppRouter.unitContract,
      builder: (context, state) => const UnitContractScreen(),
    ),
    GoRoute(
      path: AppRouter.editProfile,
      builder: (context, state) => BlocProvider(
        create: (_) => sl<ProfileCubit>()..getProfile(),
        child: const EditProfileScreen(),
      ),
    ),
    GoRoute(
      path: AppRouter.security,
      builder: (context, state) => const SecurityScreen(),
    ),
    GoRoute(
      path: AppRouter.appSettings,
      builder: (context, state) => const AppSettingsScreen(),
    ),
    GoRoute(
      path: AppRouter.support,
      builder: (context, state) => const SupportScreen(),
    ),
    GoRoute(
      path: AppRouter.myContracts,
      builder: (context, state) => const ProfileContractsScreen(),
    ),
  ];
}
