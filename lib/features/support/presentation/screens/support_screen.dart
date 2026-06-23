import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';

import '../widgets/agent_status_bar.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/typing_indicator.dart';
import 'package:apartment/core/theme/theme_extension.dart';


class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Mock Data
    final agentName = l10n.supportAgentName;
    const agentAvatar = 'https://i.pravatar.cc/150?img=1';

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            FluentIcons.chevron_right_24_regular,
            color: context.colors.textPrimary,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          l10n.supportTitle,
          style: TextStyle(
            fontSize: AppFonts.headlineSmall,
            fontWeight: FontWeight.bold,
            color: context.colors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              FluentIcons.document_question_mark_24_regular,
              color: context.colors.textSecondary,
            ),
            tooltip: l10n.faqTitle,
            onPressed: () {}, // Will open FAQ
          ),
          IconButton(
            icon: Icon(
              FluentIcons.call_24_regular,
              color: context.colors.gold,
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
                  text: 'Hello, how can I help you?',
                  time: '10:00 AM',
                  isUser: false,
                  avatarUrl: agentAvatar,
                ),

                // User Reply
                const ChatBubble(
                  text: 'I need help with my unit.',
                  time: '10:05 AM',
                  isUser: true,
                ),

                // Agent Welcome
                const ChatBubble(
                  text: 'Sure, what seems to be the problem?',
                  time: '10:06 AM',
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
                      color: context.colors.border.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      l10n.today,
                      style: TextStyle(
                        fontSize: AppFonts.labelSmall,
                        color: context.colors.textSecondary,
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
          icon: Icon(FluentIcons.chat_24_regular, color: context.colors.white),
          label: Text(
            l10n.whatsapp,
            style: TextStyle(
              fontSize: AppFonts.bodyMedium,
              fontWeight: FontWeight.bold,
              color: context.colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
