import 'package:flutter/material.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/theme_extension.dart';
import '../../../../../l10n/app_localizations.dart';

import 'ai_renders_page_view.dart';
import 'ai_renders_action_bar.dart';

class AiRendersCompletedView extends StatefulWidget {
  final List<String> renders;
  final int orderId;

  const AiRendersCompletedView({
    super.key,
    required this.renders,
    required this.orderId,
  });

  @override
  State<AiRendersCompletedView> createState() => _AiRendersCompletedViewState();
}

class _AiRendersCompletedViewState extends State<AiRendersCompletedView> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.renders.isEmpty) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.aiRendersNoDesigns,
          style: TextStyle(fontSize: AppFonts.bodyLarge, color: context.colors.textPrimary),
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: AiRendersPageView(
            renders: widget.renders,
            pageController: _pageController,
            currentIndex: _currentIndex,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
          ),
        ),
        AiRendersActionBar(
          orderId: widget.orderId,
          currentRenderUrl: widget.renders[_currentIndex],
        ),
      ],
    );
  }
}
