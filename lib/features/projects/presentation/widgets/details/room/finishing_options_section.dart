import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/theme_extension.dart';
import '../../../../../home/domain/entities/finishing_category_entity.dart';
import 'finishing_material_card.dart';

class FinishingOptionsSection extends StatelessWidget {
  final List<FinishingCategoryEntity> options;

  const FinishingOptionsSection({super.key, required this.options});

  @override
  Widget build(BuildContext context) {
    if (options.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: context.colors.textPrimary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Text(
                'خيارات التشطيب المتاحة',
                style: TextStyle(
                  fontSize: AppFonts.headlineSmall,
                  fontWeight: FontWeight.bold,
                  color: context.colors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: options.length,
            separatorBuilder: (context, index) => SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              return _buildCategoryAccordion(context, options[index], index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryAccordion(BuildContext context, FinishingCategoryEntity category, int index) {
    return _PremiumAccordion(
      category: category,
      initiallyExpanded: index == 0,
    );
  }
}

class _PremiumAccordion extends StatefulWidget {
  final FinishingCategoryEntity category;
  final bool initiallyExpanded;

  const _PremiumAccordion({
    required this.category,
    this.initiallyExpanded = false,
  });

  @override
  State<_PremiumAccordion> createState() => _PremiumAccordionState();
}

class _PremiumAccordionState extends State<_PremiumAccordion> with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  late AnimationController _controller;
  late Animation<double> _iconTurns;
  late Animation<double> _heightFactor;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _heightFactor = _controller.drive(CurveTween(curve: Curves.easeInOutCubic));
    _iconTurns = _controller.drive(Tween<double>(begin: 0.0, end: 0.5)
        .chain(CurveTween(curve: Curves.easeInOutCubic)));

    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
      decoration: BoxDecoration(
        color: context.colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: _isExpanded ? context.colors.primary.withValues(alpha: 0.3) : context.colors.border,
          width: _isExpanded ? 1.5 : 1.0,
        ),
        boxShadow: _isExpanded
            ? [
                BoxShadow(
                  color: context.colors.primary.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ]
            : [],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: _handleTap,
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.category.categoryName,
                      style: TextStyle(
                        fontSize: AppFonts.bodyLarge,
                        fontWeight: FontWeight.bold,
                        color: _isExpanded ? context.colors.primary : context.colors.textPrimary,
                      ),
                    ),
                  ),
                  RotationTransition(
                    turns: _iconTurns,
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: _isExpanded ? context.colors.primary : context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizeTransition(
            sizeFactor: _heightFactor,
            axisAlignment: -1.0,
            child: Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.md,
                right: AppSpacing.md,
                bottom: AppSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.category.subtypes.map((subtype) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (subtype.subtypeName.isNotEmpty && subtype.subtypeName != widget.category.categoryName)
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm, top: AppSpacing.xs),
                          child: Text(
                            subtype.subtypeName,
                            style: TextStyle(
                              fontSize: AppFonts.bodyMedium,
                              fontWeight: FontWeight.w600,
                              color: context.colors.textSecondary,
                            ),
                          ),
                        ),
                      ...subtype.materials.map((material) => FinishingMaterialCard(material: material)),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
