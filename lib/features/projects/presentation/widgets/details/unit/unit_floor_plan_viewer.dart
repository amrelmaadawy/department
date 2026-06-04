import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:apartment/core/theme/app_colors.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';

class UnitFloorPlanViewer extends StatefulWidget {
  final ProjectUnitEntity unit;
  final String heroTag;

  const UnitFloorPlanViewer({super.key, required this.unit, required this.heroTag});

  @override
  State<UnitFloorPlanViewer> createState() => _UnitFloorPlanViewerState();
}

class _UnitFloorPlanViewerState extends State<UnitFloorPlanViewer> {
  final PageController _pageController = PageController();
  late List<TransformationController> _transformationControllers;
  int _currentIndex = 0;
  bool _isZoomedIn = false;

  @override
  void initState() {
    super.initState();
    final imagesCount = widget.unit.images.isNotEmpty ? widget.unit.images.length : 1;
    _transformationControllers = List.generate(
      imagesCount,
      (index) {
        final controller = TransformationController();
        controller.addListener(_onTransformationChanged);
        return controller;
      },
    );
  }

  void _onTransformationChanged() {
    if (_transformationControllers.isEmpty) return;
    final scale = _transformationControllers[_currentIndex].value.getMaxScaleOnAxis();
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
      controller.removeListener(_onTransformationChanged);
      controller.dispose();
    }
    super.dispose();
  }

  void _zoomIn() {
    final controller = _transformationControllers[_currentIndex];
    controller.value = controller.value.clone()..scale(1.5);
  }

  void _zoomOut() {
    final controller = _transformationControllers[_currentIndex];
    final currentScale = controller.value.getMaxScaleOnAxis();
    if (currentScale > 1.0) {
      final matrix = controller.value.clone()..scale(0.66);
      if (matrix.getMaxScaleOnAxis() < 1.0) {
        controller.value = Matrix4.identity();
      } else {
        controller.value = matrix;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.unit.images.isNotEmpty ? widget.unit.images : [widget.unit.imagePath];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 280,
          margin: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                AppColors.white,
                AppColors.primary.withValues(alpha: 0.05),
              ],
              radius: 1.5,
            ),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.1), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // The image carousel
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                child: PageView.builder(
                  physics: _isZoomedIn ? const NeverScrollableScrollPhysics() : null,
                  controller: _pageController,
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
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    final isCurrentPage = index == _currentIndex;
                    Widget imageWidget = InteractiveViewer(
                      transformationController: _transformationControllers[index],
                      panEnabled: isCurrentPage,
                      scaleEnabled: isCurrentPage,
                      minScale: 1.0,
                      maxScale: 4.0,
                      child: Image.asset(
                        images[index],
                        fit: BoxFit.contain,
                      ),
                    );
                    
                    // Only apply Hero to the first image to match the tag from previous screen
                    if (index == 0) {
                      return Hero(
                        tag: widget.heroTag,
                        child: imageWidget,
                      );
                    }
                    return imageWidget;
                  },
                ),
              ),
              
              // Page Indicators
              if (images.length > 1)
                Positioned(
                  bottom: AppSpacing.md,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      images.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentIndex == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentIndex == index 
                              ? AppColors.primary 
                              : AppColors.border,
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                      ),
                    ),
                  ),
                ),

              Positioned(
                bottom: AppSpacing.md,
                left: AppSpacing.md,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(
                          color: AppColors.white.withValues(alpha: 0.5),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          _buildIconButton(FluentIcons.zoom_out_24_regular, _zoomOut),
                          const SizedBox(width: AppSpacing.xs),
                          _buildIconButton(FluentIcons.zoom_in_24_regular, _zoomIn),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Thumbnails
        if (images.length > 1)
          SizedBox(
            height: 64,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.md),
              itemBuilder: (context, index) {
                final isSelected = index == _currentIndex;
                return GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : AppColors.border,
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected 
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            )
                          ] 
                        : [],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.md - 2),
                      child: Image.asset(
                        images[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Icon(icon, size: 20, color: AppColors.primary),
        ),
      ),
    );
  }
}
