import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/features/home/domain/entities/project_service_entity.dart';
import 'package:flutter/material.dart';
import 'package:apartment/l10n/app_localizations.dart';

import 'project_service_card.dart';
import 'package:apartment/core/theme/theme_extension.dart';


class ProjectServicesTab extends StatelessWidget {
  final List<ProjectServiceEntity> services;

  const ProjectServicesTab({super.key, required this.services});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Section
          Text(
            l10n.ourServices,
            style: TextStyle(
              fontSize: AppFonts.headlineMedium,
              fontWeight: FontWeight.bold,
              color: context.colors.gold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            l10n.ourServicesDesc,
            style: TextStyle(
              fontSize: AppFonts.bodyMedium,
              color: context.colors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.xl),

          // Services List
          LayoutBuilder(
            builder: (context, constraints) {
              // If the screen is wide (like an iPad), show a Grid. Otherwise, a ListView.
              if (constraints.maxWidth > 600) {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: AppSpacing.lg,
                    mainAxisSpacing: AppSpacing.lg,
                    childAspectRatio:
                        0.8, // Adjust ratio so cards don't get too tall
                  ),
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    return ProjectServiceCard(
                      service: services[index],
                      index: index,
                    );
                  },
                );
              }

              // Default Mobile View
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: services.length,
                itemBuilder: (context, index) {
                  return ProjectServiceCard(
                    service: services[index],
                    index: index,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
