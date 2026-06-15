import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../../core/widgets/app_toast.dart';
import '../cubit/ai_renders_cubit.dart';
import '../cubit/ai_renders_state.dart';
import '../cubit/save_design_cubit.dart';
import '../cubit/save_design_state.dart';

class AiRendersScreen extends StatelessWidget {
  final int orderId;

  const AiRendersScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AiRendersCubit>()..fetchAiRenders(orderId),
      child: Scaffold(
        backgroundColor: context.colors.background,
        appBar: AppBar(
          backgroundColor: context.colors.background,
          elevation: 0,
          leading: IconButton(
            icon: Icon(FluentIcons.chevron_right_24_regular, color: context.colors.textPrimary),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'تصاميم الذكاء الاصطناعي',
            style: TextStyle(
              fontSize: AppFonts.headlineSmall,
              fontWeight: FontWeight.bold,
              color: context.colors.textPrimary,
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
              return _AiPendingView(statusLabel: state.aiRenders.aiStatusLabel);
            } else if (state is AiRendersCompleted) {
              return BlocProvider(
                create: (context) => sl<SaveDesignCubit>(),
                child: _AiCompletedView(
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
                        child: Text('إعادة المحاولة'),
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

class _AiPendingView extends StatelessWidget {
  final String statusLabel;

  const _AiPendingView({required this.statusLabel});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Placeholder for Lottie Animation, using an icon with glowing effect for now
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: context.colors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: context.colors.primary.withValues(alpha: 0.2),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: Icon(
                FluentIcons.sparkle_24_filled,
                size: 80,
                color: context.colors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text(
              'الذكاء الاصطناعي يعمل الآن',
              style: TextStyle(
                fontSize: AppFonts.headlineMedium,
                fontWeight: FontWeight.bold,
                color: context.colors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              statusLabel.isNotEmpty ? statusLabel : 'جاري تحليل التصميم واختيار أفضل الألوان والإضاءة...',
              style: TextStyle(
                fontSize: AppFonts.bodyLarge,
                color: context.colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: context.colors.primary,
                backgroundColor: context.colors.primary.withValues(alpha: 0.1),
                strokeCap: StrokeCap.round,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AiCompletedView extends StatefulWidget {
  final List<String> renders;
  final int orderId;

  const _AiCompletedView({
    required this.renders,
    required this.orderId,
  });

  @override
  State<_AiCompletedView> createState() => _AiCompletedViewState();
}

class _AiCompletedViewState extends State<_AiCompletedView> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  bool _isDownloading = false;

  // Future<void> _downloadImage(String url) async {
  //   if (_isDownloading) return;
  //   setState(() => _isDownloading = true);

  //   try {
  //     final response = await Dio().get(
  //       url,
  //       options: Options(responseType: ResponseType.bytes),
  //     );
      
  //     if (!await Gal.hasAccess()) {
  //       await Gal.requestAccess();
  //     }

  //     await Gal.putImageBytes(
  //       Uint8List.fromList(response.data),
  //       name: "ai_design_${DateTime.now().millisecondsSinceEpoch}",
  //     );

  //     if (mounted) {
  //       AppToast.showSuccess(context, 'تم تنزيل التصميم وحفظه في المعرض بنجاح!');
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       AppToast.showError(context, 'حدث خطأ في تحميل الصورة.');
  //     }
  //   } finally {
  //     if (mounted) {
  //       setState(() => _isDownloading = false);
  //     }
  //   }
  // }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.renders.isEmpty) {
      return Center(
        child: Text(
          'لم يتم العثور على تصاميم.',
          style: TextStyle(fontSize: AppFonts.bodyLarge, color: context.colors.textPrimary),
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                itemCount: widget.renders.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                      child: InteractiveViewer(
                        minScale: 1.0,
                        maxScale: 4.0,
                        child: Image.network(
                          widget.renders[index],
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: SizedBox(
                                width: 48,
                                height: 48,
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                      : null,
                                  strokeWidth: 3,
                                  color: context.colors.primary,
                                  backgroundColor: context.colors.primary.withValues(alpha: 0.1),
                                  strokeCap: StrokeCap.round,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) => const Center(
                            child: Icon(FluentIcons.image_off_24_regular, size: 64, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              if (widget.renders.length > 1)
                Positioned(
                  bottom: AppSpacing.xl,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      widget.renders.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentIndex == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentIndex == index ? context.colors.primary : context.colors.border,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: context.colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
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
                /* Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isDownloading ? null : () => _downloadImage(widget.renders[_currentIndex]),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: context.colors.primary,
                      side: BorderSide(color: context.colors.primary),
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
                    ),
                    icon: _isDownloading 
                        ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: context.colors.primary))
                        : const Icon(FluentIcons.arrow_download_24_regular),
                    label: Text(_isDownloading ? 'جاري...' : 'تحميل', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: AppSpacing.md), */
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
                                      widget.orderId,
                                      widget.renders[_currentIndex],
                                    );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.colors.primary,
                          foregroundColor: context.colors.white,
                          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
                          elevation: 0,
                        ),
                        icon: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(FluentIcons.save_24_regular),
                        label: Text(
                          isLoading ? 'جاري الحفظ...' : 'حفظ التصميم',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
