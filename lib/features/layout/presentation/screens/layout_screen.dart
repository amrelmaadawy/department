import 'package:apartment/features/home/presentation/screens/home_screen.dart';
import 'package:apartment/features/projects/presentation/screens/projects_screen.dart';
import 'package:apartment/features/profile/presentation/screens/profile_screen.dart';
import 'package:apartment/features/profile/presentation/screens/ai_gallery_screen.dart';
import 'package:apartment/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:apartment/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:apartment/features/layout/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../../core/widgets/fade_indexed_stack.dart';
import '../cubit/layout_cubit.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<LayoutCubit>()),
        BlocProvider(create: (_) => sl<ProfileCubit>()..getProfile()),
      ],
      child: const LayoutView(),
    );
  }
}

class LayoutView extends StatelessWidget {
  const LayoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Define items here to access localization
    final List<NavBarItem> navItems = [
      NavBarItem(
        label: l10n.navHome,
        icon: FluentIcons.home_24_regular,
        activeIcon: FluentIcons.home_24_filled,
      ),
      NavBarItem(
        label: l10n.navProjects,
        icon: FluentIcons.building_24_regular, // Fluent UI Building icon
        activeIcon: FluentIcons.building_24_filled,
      ),
      NavBarItem(
        label: l10n.navDesignStudio,
        icon: FluentIcons.sparkle_24_regular,
        activeIcon: FluentIcons.sparkle_24_filled,
      ),
      NavBarItem(
        label: l10n.navAccount,
        icon: FluentIcons.person_24_regular,
        activeIcon: FluentIcons.person_24_filled,
      ),
    ];

    // Placeholder screens until actual features are built
    final List<Widget> screens = [
      const HomeScreen(),
      const ProjectsScreen(),
      const AiGalleryScreen(),
      BlocProvider(
        create: (_) => sl<AuthCubit>(),
        child: const ProfileScreen(),
      ),
    ];

    return BlocBuilder<LayoutCubit, int>(
      builder: (context, currentIndex) {
        return Scaffold(
          backgroundColor: context.colors.background,
          body: FadeIndexedStack(index: currentIndex, children: screens),
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: currentIndex,
            items: navItems,
            onTap: (index) => context.read<LayoutCubit>().changeTab(index),
          ),
        );
      },
    );
  }
}
