import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:apartment/core/routes/app_router.dart';
import 'project_unit_card.dart';

class ProjectUnitsTab extends StatefulWidget {
  final List<ProjectUnitEntity> units;

  const ProjectUnitsTab({super.key, required this.units});

  @override
  State<ProjectUnitsTab> createState() => _ProjectUnitsTabState();
}

class _ProjectUnitsTabState extends State<ProjectUnitsTab> {
  String? _selectedUnitId;

  @override
  Widget build(BuildContext context) {
    if (widget.units.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            'لا توجد وحدات متاحة حالياً',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Units List / Grid
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOutCubic,
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 600) {
                  // Tablet View
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: AppSpacing.md,
                          mainAxisSpacing: AppSpacing.md,
                          childAspectRatio: 2.5, // Wide card ratio
                        ),
                    itemCount: widget.units.length,
                    itemBuilder: (context, index) {
                      final unit = widget.units[index];
                      return ProjectUnitCard(
                        key: ValueKey(unit.id),
                        unit: unit,
                        index: index,
                        isSelected: _selectedUnitId == unit.id,
                        onTap: () {
                          setState(() {
                            _selectedUnitId = unit.id;
                          });
                          Future.delayed(const Duration(milliseconds: 150), () {
                            if (context.mounted) {
                              context.push(
                                AppRouter.unitDetails,
                                extra: {
                                  'unit': unit,
                                  'heroTag': 'unit_${unit.id}',
                                },
                              );
                            }
                          });
                        },
                      );
                    },
                  );
                }

                // Mobile View
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.units.length,
                  itemBuilder: (context, index) {
                    final unit = widget.units[index];
                    return ProjectUnitCard(
                      key: ValueKey(unit.id),
                      unit: unit,
                      index: index,
                      isSelected: _selectedUnitId == unit.id,
                      onTap: () {
                        setState(() {
                          _selectedUnitId = unit.id;
                        });
                        Future.delayed(const Duration(milliseconds: 150), () {
                          if (context.mounted) {
                            context.push(
                              AppRouter.unitDetails,
                              extra: {
                                'unit': unit,
                                'heroTag': 'unit_${unit.id}',
                              },
                            );
                          }
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
        SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}
