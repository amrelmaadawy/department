import 'package:flutter/material.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/theme_extension.dart';
import 'package:apartment/l10n/app_localizations.dart';

import '../widgets/ai_gallery/ai_gallery_tab_view.dart';
import '../widgets/ai_gallery/saved_designs_tab_view.dart';

class AiGalleryScreen extends StatelessWidget {
  const AiGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: context.colors.background,
        appBar: AppBar(
          title: Text(
            l10n.navDesignStudio,
            style: TextStyle(
              fontSize: AppFonts.headlineSmall,
              fontWeight: FontWeight.bold,
              color: context.colors.textPrimary,
            ),
          ),
          centerTitle: true,
          backgroundColor: context.colors.background,
          elevation: 0,
          // Removed leading icon because this is now a root navigation tab
          bottom: TabBar(
            indicatorColor: context.colors.primary,
            labelColor: context.colors.primary,
            unselectedLabelColor: context.colors.textSecondary,
            labelStyle: const TextStyle(
              fontSize: AppFonts.bodyLarge,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: AppFonts.bodyLarge,
              fontWeight: FontWeight.normal,
            ),
            tabs: [
              Tab(text: l10n.aiGalleryTitle),
              Tab(text: l10n.mySavedDesigns),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AiGalleryTabView(),
            SavedDesignsTabView(),
          ],
        ),
      ),
    );
  }
}
