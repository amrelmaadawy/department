import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extension.dart';
import '../cubit/active_journey_cubit.dart';
import '../cubit/active_journey_state.dart';
import 'active_journey_card_item.dart';

class ActiveJourneyResumeCard extends StatelessWidget {
  const ActiveJourneyResumeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ActiveJourneyCubit>(
      create: (context) => sl<ActiveJourneyCubit>()..loadActiveJourneys(),
      child: BlocBuilder<ActiveJourneyCubit, ActiveJourneyState>(
        builder: (context, state) {
          if (state is ActiveJourneyLoaded) {
            if (state.journeys.isEmpty) {
              return const SizedBox.shrink();
            }

            if (state.journeys.length == 1) {
              return ActiveJourneyCardItem(journey: state.journeys.first);
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.xs,
                  ),
                  child: Text(
                    'رحلاتك النشطة (${state.journeys.length})',
                    style: TextStyle(
                      fontSize: AppFonts.bodyLarge,
                      fontWeight: FontWeight.bold,
                      color: context.colors.textPrimary,
                    ),
                  ),
                ),
                ...state.journeys.map((j) => ActiveJourneyCardItem(journey: j)),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
