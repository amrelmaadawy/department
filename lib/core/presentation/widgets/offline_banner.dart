import 'package:apartment/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/core/theme/app_fonts.dart';

class OfflineBanner {
  static OverlayEntry? _overlayEntry;
  static bool _isCurrentlyShowingOffline = false;

  static void showOffline(BuildContext context) {
    if (_isCurrentlyShowingOffline) return;
    final overlay = Overlay.maybeOf(context);
    if (overlay == null) return;

    _removeCurrent();
    _isCurrentlyShowingOffline = true;
    _overlayEntry = OverlayEntry(
      builder: (context) => _buildBanner(
        context,
        message: 'أنت غير متصل بالإنترنت',
        color: context.colors.error,
        icon: Icons.wifi_off_rounded,
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  static void showRestored(BuildContext context) {
    if (!_isCurrentlyShowingOffline) return; // Only show restored if we were offline
    final overlay = Overlay.maybeOf(context);
    if (overlay == null) return;

    _removeCurrent();
    _isCurrentlyShowingOffline = false;

    _overlayEntry = OverlayEntry(
      builder: (context) => _buildBanner(
        context,
        message: 'تمت استعادة الاتصال',
        color: context.colors.success,
        icon: Icons.wifi_rounded,
      ),
    );

    overlay.insert(_overlayEntry!);

    // Remove the "restored" banner after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      _removeCurrent();
    });
  }
  
  static void hide(BuildContext context) {
    _removeCurrent();
    _isCurrentlyShowingOffline = false;
  }

  static void _removeCurrent() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  static Widget _buildBanner(
    BuildContext context, {
    required String message,
    required Color color,
    required IconData icon,
  }) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 16,
      right: 16,
      child: SafeArea(
        child: Material(
          color: AppColors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: AppColors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  message,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: AppFonts.bodyMedium,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
