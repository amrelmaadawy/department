import 'package:equatable/equatable.dart';

enum PackageTier { economic, standard, luxury, custom }

class FinishingPackageEntity extends Equatable {
  final String id;
  final PackageTier tier;
  final String title;
  final double pricePerSqm;
  final List<String> features;
  final String? badge;
  final String buttonText;
  final String? subtitle;

  const FinishingPackageEntity({
    required this.id,
    required this.tier,
    required this.title,
    required this.pricePerSqm,
    required this.features,
    this.badge,
    required this.buttonText,
    this.subtitle,
  });

  @override
  List<Object?> get props => [
    id,
    tier,
    title,
    pricePerSqm,
    features,
    badge,
    buttonText,
    subtitle,
  ];
}
