import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/theme_extension.dart';
import '../cubit/ai_renders_cubit.dart';
import '../cubit/ai_renders_state.dart';
import '../cubit/save_design_cubit.dart';
import '../cubit/share_design_cubit.dart' as import_share;
import '../cubit/download_image_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../core/network/cubit/network_cubit.dart';
import '../../../../../core/network/cubit/network_state.dart';

import '../widgets/ai_renders/ai_renders_pending_view.dart';
import '../widgets/ai_renders/ai_renders_completed_view.dart';
import '../widgets/ai_renders/ai_renders_error_view.dart';

class AiRendersScreen extends StatelessWidget {
  final int orderId;
  final List<String> projectFeatures;
  final String projectName;

  const AiRendersScreen({
    super.key,
    required this.orderId,
    this.projectFeatures = const [],
    this.projectName = '',
  });

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
          scrolledUnderElevation: 0,
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
        body: BlocListener<NetworkCubit, NetworkState>(
          listener: (context, networkState) {
            if (networkState is NetworkOnline) {
              final s = context.read<AiRendersCubit>().state;
              if (s is AiRendersError) {
                context.read<AiRendersCubit>().fetchAiRenders(orderId);
              }
            }
          },
          child: BlocBuilder<AiRendersCubit, AiRendersState>(
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
              return AiRendersPendingView(
                statusLabel: state.aiRenders.aiStatusLabel,
                projectFeatures: projectFeatures,
                projectName: projectName,
              );
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
              return AiRendersErrorView(
                message: state.message,
                onRetry: () => context.read<AiRendersCubit>().fetchAiRenders(orderId),
              );
            }
            return const SizedBox.shrink();
          },
          ),
        ),
      ),
    );
  }
}

