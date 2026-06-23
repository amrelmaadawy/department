import 'package:flutter/material.dart';
import 'package:apartment/core/widgets/app_cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import 'package:apartment/core/theme/theme_extension.dart';

class ProfileHeader extends StatelessWidget {
  final String userName;
  final String userType;
  final String? avatarUrl;
  final int aiCredits;

  const ProfileHeader({
    super.key,
    required this.userName,
    required this.userType,
    required this.avatarUrl,
    this.aiCredits = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        top: AppSpacing.xxxl * 1.5,
        bottom: AppSpacing.xxxl * 1.5, // Extra space for the floating card
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.colors.primary,
            context.colors.primary.withValues(alpha: 0.85),
            const Color(0xFF1E242B), // Very dark slate
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppRadius.xl * 1.5),
          bottomRight: Radius.circular(AppRadius.xl * 1.5),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Background glowing orbs
          Positioned(
            top: -50,
            right: -20,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.colors.gold.withValues(alpha: 0.15),
                boxShadow: [
                  BoxShadow(
                    color: context.colors.gold.withValues(alpha: 0.15),
                    blurRadius: 60,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: -20,
            left: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.colors.white.withValues(alpha: 0.05),
                boxShadow: [
                  BoxShadow(
                    color: context.colors.white.withValues(alpha: 0.05),
                    blurRadius: 50,
                    spreadRadius: 10,
                  ),
                ],
              ),
            ),
          ),

          // Foreground Content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Avatar with glowing golden border
              Container(
                width: 116,
                height: 116,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      context.colors.gold,
                      context.colors.gold.withValues(alpha: 0.5),
                      context.colors.gold,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: context.colors.gold.withValues(alpha: 0.25),
                      blurRadius: 24,
                      spreadRadius: 4,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3.0), // Border width
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.colors.primary,
                      border: Border.all(
                        color: context.colors.primary.withValues(alpha: 0.8),
                        width: 3,
                      ),
                    ),
                    child: ClipOval(
                      child: (avatarUrl != null && avatarUrl!.isNotEmpty)
                          ? (avatarUrl!.startsWith('http')
                              ? AppCachedNetworkImage(
                                  imageUrl: avatarUrl!,
                                  fit: BoxFit.cover,
                                  errorWidget: (_, _, _) => _buildFallbackAvatar(context),
                                )
                              : Image.asset(
                                  avatarUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_,_, _) => _buildFallbackAvatar(context),
                                ))
                          : _buildFallbackAvatar(context),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // User Name
              Text(
                userName,
                style: TextStyle(
                  fontSize: AppFonts.headlineMedium,
                  fontWeight: FontWeight.bold,
                  color: context.colors.white,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              // Premium Badge & AI Credits
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [context.colors.gold, const Color(0xFFC99B40)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  boxShadow: [
                    BoxShadow(
                      color: context.colors.gold.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      FluentIcons.premium_24_filled,
                      color: context.colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      userType,
                      style: TextStyle(
                        fontSize: AppFonts.labelMedium,
                        fontWeight: FontWeight.bold,
                        color: context.colors.white,
                      ),
                    ),
                    if (aiCredits > 0) ...[
                      const SizedBox(width: AppSpacing.md),
                      Container(
                        width: 1,
                        height: 16,
                        color: context.colors.white.withValues(alpha: 0.3),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Icon(
                        FluentIcons.sparkle_24_filled,
                        color: context.colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        '$aiCredits رصيد AI',
                        style: TextStyle(
                          fontSize: AppFonts.labelMedium,
                          fontWeight: FontWeight.bold,
                          color: context.colors.white,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackAvatar(BuildContext context) {
    return Container(
      color: context.colors.background,
      child: Center(
        child: Icon(
          FluentIcons.person_48_filled,
          color: context.colors.textSecondary.withValues(alpha: 0.5),
          size: 56,
        ),
      ),
    );
  }
}
