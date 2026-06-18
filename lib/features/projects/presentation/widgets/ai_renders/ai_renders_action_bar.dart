import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/theme_extension.dart';
import '../../../../../core/widgets/app_toast.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../cubit/save_design_cubit.dart';
import '../../cubit/save_design_state.dart';

class AiRendersActionBar extends StatelessWidget {
  final int orderId;
  final String currentRenderUrl;

  const AiRendersActionBar({
    super.key,
    required this.orderId,
    required this.currentRenderUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Save Design Button
            Expanded(
              child: BlocConsumer<SaveDesignCubit, SaveDesignState>(
                listener: (context, state) {
                  if (state is SaveDesignSuccess) {
                    AppToast.showSuccess(context, 'تم حفظ التصميم بنجاح.');
                  } else if (state is SaveDesignError) {
                    AppToast.showError(context, state.message);
                  }
                },
                builder: (context, state) {
                  final isLoading = state is SaveDesignLoading;
                  return ElevatedButton.icon(
                    onPressed: isLoading
                        ? null
                        : () {
                            context.read<SaveDesignCubit>().saveDesign(
                                  orderId,
                                  currentRenderUrl,
                                );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.primary,
                      foregroundColor: context.colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
                      elevation: 0,
                    ),
                    icon: isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(FluentIcons.save_24_regular, size: 24),
                    label: Builder(
                      builder: (context) => Text(
                        isLoading
                            ? AppLocalizations.of(context)!.aiRendersSaving
                            : AppLocalizations.of(context)!.aiRendersSaveDesign,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
