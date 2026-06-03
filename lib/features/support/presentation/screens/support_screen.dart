import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';

import '../widgets/agent_status_bar.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/typing_indicator.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Mock Data
    const agentName = 'سارة';
    const agentAvatar = 'https://i.pravatar.cc/150?img=1';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            FluentIcons.chevron_right_24_regular,
            color: AppColors.textPrimary,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          l10n.supportTitle,
          style: const TextStyle(
            fontSize: AppFonts.headlineSmall,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              FluentIcons.document_question_mark_24_regular,
              color: AppColors.textSecondary,
            ),
            tooltip: l10n.faqTitle,
            onPressed: () {}, // Will open FAQ
          ),
          IconButton(
            icon: const Icon(
              FluentIcons.call_24_regular,
              color: AppColors.gold,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: Column(
        children: [
          AgentStatusBar(agentName: agentName, agentAvatar: agentAvatar),

          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              reverse:
                  true, // Latest message at the bottom, auto-adjusts with keyboard
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              children: [
                // Extra space so the FAB doesn't hide the last message
                const SizedBox(height: 80),

                // Typing Indicator
                const TypingIndicator(avatarUrl: agentAvatar),

                // Agent Reply
                const ChatBubble(
                  text:
                      'بالتأكيد، جاري التحقق من الجدول الزمني الخاص بوحدتك مع المهندس المشرف. لحظات من فضلك.',
                  time: '10:06 ص',
                  isUser: false,
                  avatarUrl: agentAvatar,
                ),

                // User Reply
                const ChatBubble(
                  text:
                      'مرحباً سارة، أود الاستفسار عن موعد تسليم مرحلة الجبس بورد في وحدتي.',
                  time: '10:05 ص',
                  isUser: true,
                ),

                // Agent Welcome
                const ChatBubble(
                  text:
                      'أهلاً بك في خدمة عملاء التشطيبات الفاخرة.\nكيف يمكنني مساعدتك اليوم في مشروعك؟',
                  time: '10:00 ص',
                  isUser: false,
                  avatarUrl: agentAvatar,
                ),

                // Date Separator
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.border.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      l10n.today,
                      style: const TextStyle(
                        fontSize: AppFonts.labelSmall,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const ChatInputBar(),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          bottom: 70.0,
        ), // Push FAB above the ChatInputBar
        child: FloatingActionButton.extended(
          onPressed: () {},
          backgroundColor: const Color(0xFF25D366), // WhatsApp Green
          elevation: 4,
          icon: const Icon(FluentIcons.chat_24_regular, color: AppColors.white),
          label: const Text(
            'واتساب',
            style: TextStyle(
              fontSize: AppFonts.bodyMedium,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}
