import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';

import '../../../../../home/domain/entities/finishing_subtype_entity.dart';

class SubtypeTabItem extends StatefulWidget {
  final FinishingSubtypeEntity subtype;
  final bool isSelected;
  final bool isCompleted;
  final bool isHighlighted;
  final VoidCallback onTap;

  const SubtypeTabItem({
    super.key,
    required this.subtype,
    required this.isSelected,
    required this.isCompleted,
    this.isHighlighted = false,
    required this.onTap,
  });

  @override
  State<SubtypeTabItem> createState() => _SubtypeTabItemState();
}

class _SubtypeTabItemState extends State<SubtypeTabItem> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    if (widget.isHighlighted) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(SubtypeTabItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isHighlighted != oldWidget.isHighlighted) {
      if (widget.isHighlighted) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.animateTo(0.0, duration: const Duration(milliseconds: 200));
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: widget.isHighlighted 
                ? context.colors.gold.withValues(alpha: 0.2)
                : widget.isSelected ? context.colors.gold.withValues(alpha: 0.1) : context.colors.background,
            borderRadius: BorderRadius.circular(AppRadius.round),
            border: Border.all(
              color: widget.isHighlighted || widget.isSelected ? context.colors.gold : context.colors.border,
              width: widget.isHighlighted ? 2.0 : 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.isCompleted) ...[
                Icon(
                  FluentIcons.checkmark_circle_16_filled,
                  size: 18,
                  color: widget.isSelected || widget.isHighlighted ? context.colors.gold : context.colors.primary,
                ),
                const SizedBox(width: AppSpacing.sm),
              ],
              Text(
                widget.subtype.subtypeName,
                style: TextStyle(
                  fontSize: AppFonts.bodyMedium,
                  fontWeight: widget.isSelected || widget.isHighlighted ? FontWeight.bold : FontWeight.w600,
                  color: widget.isSelected || widget.isHighlighted ? context.colors.gold : context.colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
