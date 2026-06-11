import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import 'package:apartment/core/theme/theme_extension.dart';


class ProfileHeader extends StatelessWidget {
  final String userName;
  final String userType;
  final String avatarUrl;

  const ProfileHeader({
    super.key,
    required this.userName,
    required this.userType,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
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
                padding: EdgeInsets.all(3), // Border width
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [context.colors.gold, Color(0xFFE5B962)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: context.colors.gold.withValues(alpha: 0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Container(
                  padding: EdgeInsets.all(2), // Inner gap
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.colors.primary,
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: context.colors.white,
                    backgroundImage: avatarUrl.isNotEmpty
                        ? (avatarUrl.startsWith('http')
                            ? NetworkImage(avatarUrl) as ImageProvider
                            : AssetImage(avatarUrl))
                        : null,
                    child: avatarUrl.isEmpty
                        ? Icon(
                            Icons.person,
                            size: 50,
                            color: context.colors.textSecondary,
                          )
                        : null,
                  ),
                ),
              ),

              SizedBox(height: AppSpacing.md),

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

              SizedBox(height: AppSpacing.sm),

              // Premium Badge
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [context.colors.gold, Color(0xFFC99B40)],
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
                    SizedBox(width: AppSpacing.xs),
                    Text(
                      userType,
                      style: TextStyle(
                        fontSize: AppFonts.labelMedium,
                        fontWeight: FontWeight.bold,
                        color: context.colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
