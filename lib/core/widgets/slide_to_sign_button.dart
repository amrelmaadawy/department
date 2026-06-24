import 'package:apartment/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:flutter/services.dart';

class SlideToSignButton extends StatefulWidget {
  final String text;
  final VoidCallback onSigned;
  final bool isSigned;

  const SlideToSignButton({
    super.key,
    required this.text,
    required this.onSigned,
    this.isSigned = false,
  });

  @override
  State<SlideToSignButton> createState() => _SlideToSignButtonState();
}

class _SlideToSignButtonState extends State<SlideToSignButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _dragPosition = 0.0;
  bool _isSigned = false;

  @override
  void initState() {
    super.initState();
    _isSigned = widget.isSigned;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    if (_isSigned) {
      _dragPosition = 1.0;
      _controller.value = 1.0;
    }
    _controller.addListener(() {
      setState(() {
        if (!_isSigned) {
          _dragPosition = _controller.value;
        }
      });
    });
  }

  @override
  void didUpdateWidget(covariant SlideToSignButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSigned != oldWidget.isSigned) {
      if (widget.isSigned) {
        _isSigned = true;
        _dragPosition = 1.0;
        _controller.value = 1.0;
      } else {
        _isSigned = false;
        _dragPosition = 0.0;
        _controller.value = 0.0;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails details, double maxWidth) {
    if (_isSigned) return;

    final isRTL = Directionality.of(context) == TextDirection.rtl;
    double delta = details.delta.dx / (maxWidth - 56); // 56 is thumb width

    if (isRTL) {
      delta = -delta;
    }

    setState(() {
      _dragPosition += delta;
      _dragPosition = _dragPosition.clamp(0.0, 1.0);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (_isSigned) return;

    if (_dragPosition > 0.8) {
      // Reached the end, sign it
      _controller.value = _dragPosition;
      _controller.forward().then((_) {
        setState(() {
          _isSigned = true;
          _dragPosition = 1.0;
        });
        HapticFeedback.heavyImpact();
        widget.onSigned();
      });
    } else {
      // Snap back
      _controller.value = _dragPosition;
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        const thumbSize = 56.0;
        final maxDragDistance = maxWidth - thumbSize - 8; // 8 for padding

        final trackColor = _isSigned 
            ? context.colors.success.withValues(alpha: 0.1) 
            : context.colors.background;
            
        final thumbColor = _isSigned 
            ? context.colors.success 
            : context.colors.primary;

        return Container(
          height: 64,
          decoration: BoxDecoration(
            color: trackColor,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: _isSigned ? context.colors.success.withValues(alpha: 0.5) : context.colors.border.withValues(alpha: 0.5),
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background Text
              Opacity(
                opacity: 1.0 - _dragPosition,
                child: Text(
                  widget.text,
                  style: TextStyle(
                    fontSize: AppFonts.bodyMedium,
                    fontWeight: FontWeight.bold,
                    color: context.colors.textSecondary,
                  ),
                ),
              ),
              
              // Success Text
              if (_isSigned)
                AnimatedOpacity(
                  opacity: _isSigned ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(FluentIcons.checkmark_24_filled, color: context.colors.success),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        AppLocalizations.of(context)!.signedSuccessfully,
                        style: TextStyle(
                          fontSize: AppFonts.bodyMedium,
                          fontWeight: FontWeight.bold,
                          color: context.colors.success,
                        ),
                      ),
                    ],
                  ),
                ),

              // Draggable Thumb
              Positioned(
                left: isRTL ? null : 4 + (_dragPosition * maxDragDistance),
                right: isRTL ? 4 + (_dragPosition * maxDragDistance) : null,
                child: GestureDetector(
                  onPanUpdate: (details) => _onPanUpdate(details, maxWidth),
                  onPanEnd: _onPanEnd,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: thumbSize,
                    height: thumbSize,
                    decoration: BoxDecoration(
                      color: thumbColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: thumbColor.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      _isSigned 
                          ? FluentIcons.checkmark_24_regular 
                          : (isRTL ? FluentIcons.chevron_left_24_regular : FluentIcons.chevron_right_24_regular),
                      color: context.colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
