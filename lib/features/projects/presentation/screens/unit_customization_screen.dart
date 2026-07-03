import 'package:apartment/core/di/injection_container.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';
import 'package:apartment/features/packages/domain/entities/finishing_package_entity.dart';
import 'package:apartment/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/unit_details_cubit.dart';
import '../widgets/details/unit/unit_customization_content.dart';

class UnitCustomizationScreen extends StatefulWidget {
  final ProjectUnitEntity unit;
  final FinishingPackageEntity? selectedPackage;

  /// When true, all edit controls are hidden and the screen is read-only.
  /// Set to true when the finishing contract has already been signed.
  final bool isReadOnly;

  const UnitCustomizationScreen({
    super.key,
    required this.unit,
    this.selectedPackage,
    this.isReadOnly = false,
  });

  @override
  State<UnitCustomizationScreen> createState() => _UnitCustomizationScreenState();
}

class _UnitCustomizationScreenState extends State<UnitCustomizationScreen> {
  @override
  void initState() {
    super.initState();
    sl<ProfileCubit>().loadProfileIfNeeded();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<UnitDetailsCubit>()
        ..loadUnitDetails(int.tryParse(widget.unit.id) ?? 0, initialUnit: widget.unit),
      child: UnitCustomizationContent(
        initialUnit: widget.unit,
        selectedPackage: widget.selectedPackage,
        isReadOnly: widget.isReadOnly,
      ),
    );
  }
}
