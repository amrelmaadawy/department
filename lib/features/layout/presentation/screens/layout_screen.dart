import 'package:apartment/features/layout/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/fade_indexed_stack.dart';
import '../cubit/layout_cubit.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LayoutCubit>(),
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
        icon: Icons.home_outlined,
        activeIcon: Icons.home,
      ),
      NavBarItem(
        label: l10n.navProjects,
        icon: Icons
            .business_outlined, // Better matching the document/building icon
        activeIcon: Icons.business,
      ),
      NavBarItem(
        label: l10n.navDesign,
        icon: Icons.architecture_outlined, // 3D/Design icon
        activeIcon: Icons.architecture,
      ),
      NavBarItem(
        label: l10n.navAccount,
        icon: Icons.person_outline,
        activeIcon: Icons.person,
      ),
    ];

    // Placeholder screens until actual features are built
    final List<Widget> screens = [
      Center(child: Text(l10n.navHome)),
      Center(child: Text(l10n.navProjects)),
      Center(child: Text(l10n.navDesign)),
      Center(child: Text(l10n.navAccount)),
    ];

    return BlocBuilder<LayoutCubit, int>(
      builder: (context, currentIndex) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: FadeIndexedStack(
            index: currentIndex, 
            children: screens,
          ),
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
