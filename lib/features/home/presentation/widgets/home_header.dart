import 'package:apartment/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../profile/presentation/cubit/profile_cubit.dart';
import '../../../profile/presentation/cubit/profile_state.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<ProfileCubit>()..getProfile(),
      child: const HomeHeaderView(),
    );
  }
}

class HomeHeaderView extends StatelessWidget {
  const HomeHeaderView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        String userName = '...';
        String? avatarUrl;
        String? userCity;

        if (state is ProfileLoaded) {
          final fullName = state.profile.user.name;
          // Extract first name for the greeting
          userName = fullName.isNotEmpty ? fullName.split(' ').first : '...';
          
          if (state.profile.user.avatarUrl != null && state.profile.user.avatarUrl!.isNotEmpty) {
            avatarUrl = state.profile.user.avatarUrl!;
          }

          if (state.profile.user.address != null && state.profile.user.address!.isNotEmpty) {
            userCity = state.profile.user.address;
          }
        }

        // Determine time-based greeting
        final hour = DateTime.now().hour;
        String greeting = 'مرحباً بك';
        IconData timeIcon = FluentIcons.hand_wave_24_regular;
        Color timeColor = context.colors.primary;

        if (hour >= 5 && hour < 12) {
          greeting = 'صباح الخير';
          timeIcon = FluentIcons.weather_sunny_24_regular;
          timeColor = const Color(0xFFFDB813); // Sun yellow/gold
        } else {
          greeting = 'مساء الخير';
          timeIcon = FluentIcons.weather_moon_24_regular;
          timeColor = const Color(0xFF7B68EE); // Moon purple/blue
        }

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              // Start Edge: Premium Avatar
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      context.colors.gold,
                      context.colors.gold.withValues(alpha: 0.3),
                      context.colors.gold,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: context.colors.gold.withValues(alpha: 0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.colors.background,
                      border: Border.all(
                        color: context.colors.background,
                        width: 2.5,
                      ),
                    ),
                    child: ClipOval(
                      child: avatarUrl != null && avatarUrl.isNotEmpty
                          ? (avatarUrl.startsWith('http')
                              ? Image.network(
                                  avatarUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => _buildHomeFallbackAvatar(context),
                                )
                              : Image.asset(
                                  avatarUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => _buildHomeFallbackAvatar(context),
                                ))
                          : _buildHomeFallbackAvatar(context),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              
              // User Info & Greeting
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Greeting Row
                    Row(
                      children: [
                        Text(
                          greeting,
                          style: TextStyle(
                            color: context.colors.textSecondary,
                            fontSize: AppFonts.bodySmall,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          timeIcon,
                          color: timeColor,
                          size: 14,
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    // User Name
                    Text(
                      userName,
                      style: TextStyle(
                        color: context.colors.textPrimary,
                        fontSize: AppFonts.headlineSmall,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Location (if available)
                    if (userCity != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            FluentIcons.location_12_regular,
                            color: context.colors.gold,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            userCity,
                            style: TextStyle(
                              color: context.colors.textSecondary,
                              fontSize: AppFonts.labelMedium,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // End Edge: Empty for now or can add a notification bell later
            ],
          ),
        );
      },
    );
  }

  Widget _buildHomeFallbackAvatar(BuildContext context) {
    return Container(
      color: context.colors.background,
      child: Center(
        child: Icon(
          FluentIcons.person_24_filled,
          color: context.colors.textSecondary.withValues(alpha: 0.5),
          size: 28,
        ),
      ),
    );
  }
}