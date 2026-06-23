import 'package:flutter/material.dart';
import 'package:apartment/core/widgets/app_cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/l10n/app_localizations.dart';

class FullScreenGallery extends StatefulWidget {
  final List<String> images;
  final int initialIndex;
  final String heroTagPrefix;

  const FullScreenGallery({
    super.key,
    required this.images,
    required this.initialIndex,
    required this.heroTagPrefix,
  });

  static void show(
    BuildContext context, {
    required List<String> images,
    required int initialIndex,
    required String heroTagPrefix,
  }) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black.withValues(alpha: 0.9),
        pageBuilder: (BuildContext context, _, _) {
          return FullScreenGallery(
            images: images,
            initialIndex: initialIndex,
            heroTagPrefix: heroTagPrefix,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  State<FullScreenGallery> createState() => _FullScreenGalleryState();
}

class _FullScreenGalleryState extends State<FullScreenGallery> {
  late PageController _pageController;
  late List<TransformationController> _transformationControllers;
  late int _currentIndex;
  bool _isZoomedIn = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);

    _transformationControllers = List.generate(
      widget.images.length,
      (index) {
        final controller = TransformationController();
        controller.addListener(() => _onTransformationChanged(index));
        return controller;
      },
    );
  }

  void _onTransformationChanged(int index) {
    if (_transformationControllers.isEmpty) return;
    final scale = _transformationControllers[index].value.getMaxScaleOnAxis();
    if (scale > 1.01 && !_isZoomedIn) {
      setState(() {
        _isZoomedIn = true;
      });
    } else if (scale <= 1.01 && _isZoomedIn) {
      setState(() {
        _isZoomedIn = false;
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (var controller in _transformationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // PageView for swiping
          PageView.builder(
            controller: _pageController,
            physics: _isZoomedIn ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
                for (int i = 0; i < _transformationControllers.length; i++) {
                  if (i != index) {
                    _transformationControllers[i].value = Matrix4.identity();
                  }
                }
                _isZoomedIn = _transformationControllers[index].value.getMaxScaleOnAxis() > 1.01;
              });
            },
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              final imagePath = widget.images[index];
              final isCurrentPage = index == _currentIndex;

              Widget imageWidget = InteractiveViewer(
                transformationController: _transformationControllers[index],
                panEnabled: isCurrentPage,
                scaleEnabled: isCurrentPage,
                minScale: 1.0,
                maxScale: 5.0,
                child: imagePath.startsWith('http')
                    ? AppCachedNetworkImage(
                        imageUrl: Uri.encodeFull(imagePath),
                        fit: BoxFit.contain,
                        errorWidget: (context, url, error) => const Center(
                          child: Icon(
                            FluentIcons.image_off_24_regular,
                            size: 64,
                            color: Colors.white54,
                          ),
                        ),
                      )
                    : Image.asset(
                        imagePath,
                        fit: BoxFit.contain,
                      ),
              );

              return Center(
                child: Hero(
                  tag: index == 0 ? widget.heroTagPrefix : '${widget.heroTagPrefix}_$index',
                  child: imageWidget,
                ),
              );
            },
          ),

          // Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Close button
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(FluentIcons.dismiss_24_regular, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                        tooltip: l10n.closeGallery,
                      ),
                    ),

                    // Counter
                    if (widget.images.length > 1)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          l10n.imageCountOf((_currentIndex + 1).toString(), widget.images.length.toString()),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // Page Indicator (Dots)
          if (widget.images.length > 1)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(widget.images.length, (index) {
                    final isActive = _currentIndex == index;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: isActive ? 24 : 8,
                      decoration: BoxDecoration(
                        color: isActive
                            ? context.colors.gold
                            : Colors.white.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
