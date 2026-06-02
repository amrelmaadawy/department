import 'package:apartment/features/projects/presentation/widgets/details/project_amenities_row.dart';
import 'package:apartment/features/projects/presentation/widgets/details/project_details_header.dart';
import 'package:apartment/features/projects/presentation/widgets/details/project_info_section.dart';
import 'package:apartment/features/projects/presentation/widgets/details/project_overview_tab.dart';
import 'package:apartment/features/projects/presentation/widgets/details/project_services_tab.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../home/domain/entities/project_entity.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final ProjectEntity project;
  final String heroTag;

  const ProjectDetailsScreen({
    super.key,
    required this.project,
    required this.heroTag,
  });

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          // 1. Hero Header
          ProjectDetailsHeader(
            project: widget.project,
            heroTag: widget.heroTag,
          ),

          // 2. Title & Info
          SliverToBoxAdapter(
            child: ProjectInfoSection(project: widget.project),
          ),

          // 3. Amenities
          SliverToBoxAdapter(
            child: ProjectAmenitiesRow(amenities: widget.project.amenities),
          ),

          // 4. Sticky Tab Bar
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyTabBarDelegate(
              TabBar(
                controller: _tabController,
                labelColor: AppColors.gold,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.gold,
                indicatorWeight: 3,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                  fontSize: AppFonts.bodyMedium,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Cairo',
                  fontSize: AppFonts.bodyMedium,
                ),
                tabs: [
                  Tab(text: l10n.tabOverview),
                  Tab(text: l10n.tabUnits),
                  Tab(text: l10n.tabServices),
                ],
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            // Overview Tab
            SingleChildScrollView(
              child: ProjectOverviewTab(project: widget.project),
            ),
            // Placeholder Units
            Center(
              child: Text(
                l10n.tabUnits,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ),
            // Services Tab
            SingleChildScrollView(
              child: ProjectServicesTab(services: widget.project.services),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          child: CustomButton(
            text: l10n.chooseUnit,
            onPressed: () {},
            // Use standard primary if buttonDark isn't fully defined for this style, but gold fits best
            backgroundColor: AppColors.gold,
            textColor: AppColors.white,
          ),
        ),
      ),
    );
  }
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _StickyTabBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: AppColors.background, child: _tabBar);
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) {
    return false;
  }
}
