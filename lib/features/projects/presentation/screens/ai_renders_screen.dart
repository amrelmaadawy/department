import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extension.dart';
import '../cubit/ai_renders_cubit.dart';
import '../cubit/ai_renders_state.dart';
import '../cubit/save_design_cubit.dart';
import '../cubit/share_design_cubit.dart' as import_share;
import '../cubit/download_image_cubit.dart';
import '../../../../../l10n/app_localizations.dart';

import '../widgets/ai_renders/ai_renders_pending_view.dart';
import '../widgets/ai_renders/ai_renders_completed_view.dart';

class AiRendersScreen extends StatelessWidget {
  final int orderId;

  const AiRendersScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<AiRendersCubit>()..fetchAiRenders(orderId)),
        BlocProvider(create: (context) => sl<DownloadImageCubit>()),
      ],
      child: Scaffold(
        backgroundColor: context.colors.background,
        appBar: AppBar(
          backgroundColor: context.colors.background,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Directionality.of(context) == TextDirection.rtl 
                ? FluentIcons.chevron_right_24_regular 
                : FluentIcons.chevron_left_24_regular, 
              color: context.colors.textPrimary,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Builder(
            builder: (context) => Text(
              AppLocalizations.of(context)!.aiRendersTitle,
              style: TextStyle(
                fontSize: AppFonts.headlineSmall,
                fontWeight: FontWeight.bold,
                color: context.colors.textPrimary,
              ),
            ),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<AiRendersCubit, AiRendersState>(
          builder: (context, state) {
            if (state is AiRendersLoading) {
              return Center(
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: context.colors.primary,
                    backgroundColor: context.colors.primary.withValues(alpha: 0.1),
                    strokeCap: StrokeCap.round,
                  ),
                ),
              );
            } else if (state is AiRendersPending) {
              return AiRendersPendingView(statusLabel: state.aiRenders.aiStatusLabel);
            } else if (state is AiRendersCompleted) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider(create: (context) => sl<SaveDesignCubit>()),
                  BlocProvider(create: (context) => sl<import_share.ShareDesignCubit>()),
                ],
                child: AiRendersCompletedView(
                  renders: state.aiRenders.aiRenders,
                  orderId: orderId,
                ),
              );
            } else if (state is AiRendersError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(FluentIcons.error_circle_24_regular, color: Colors.red, size: 64),
                      SizedBox(height: AppSpacing.md),
                      Text(
                        state.message,
                        style: TextStyle(fontSize: AppFonts.bodyLarge, color: context.colors.textPrimary),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppSpacing.lg),
                      ElevatedButton(
                        onPressed: () => context.read<AiRendersCubit>().fetchAiRenders(orderId),
                        child: Text(AppLocalizations.of(context)!.aiRendersRetry),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
