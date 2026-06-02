import 'package:equatable/equatable.dart';

class ProjectEntity extends Equatable {
  final String id;
  final String name;
  final String location;
  final double startingPrice;
  final String imagePath;

  const ProjectEntity({
    required this.id,
    required this.name,
    required this.location,
    required this.startingPrice,
    required this.imagePath,
  });

  @override
  List<Object?> get props => [id, name, location, startingPrice, imagePath];
}
