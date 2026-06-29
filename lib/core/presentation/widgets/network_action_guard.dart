import 'package:apartment/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apartment/core/network/cubit/network_cubit.dart';
import 'package:apartment/core/network/cubit/network_state.dart';
import 'package:apartment/core/widgets/app_toast.dart';

/// A wrapper widget that prevents an action from being executed if the user is offline.
/// If the user clicks the wrapped widget while offline, it shows an offline toast.
class NetworkActionGuard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onOfflineTap;
  final bool showToast;

  const NetworkActionGuard({
    super.key,
    required this.child,
    this.onOfflineTap,
    this.showToast = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NetworkCubit, NetworkState>(
      builder: (context, state) {
        final isOffline = state is NetworkOffline || state is NetworkNoInternet;

        if (!isOffline) {
          return child;
        }

        return Stack(
          alignment: Alignment.center,
          children: [
            // The wrapped widget, visually slightly dimmed
            Opacity(
              opacity: 0.6,
              child: IgnorePointer(
                ignoring: true, // Prevent the actual button's tap from firing
                child: child,
              ),
            ),
            // The intercepting layer
            Positioned.fill(
              child: Material(
                color: AppColors.transparent,
                child: InkWell(
                  splashColor: AppColors.transparent,
                  highlightColor: AppColors.transparent,
                  onTap: () {
                    if (onOfflineTap != null) {
                      onOfflineTap!();
                    } else if (showToast) {
                      AppToast.showError(
                        context,
                        'لا يوجد اتصال بالإنترنت، لا يمكن إتمام هذا الإجراء.',
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
