import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ProjectServiceEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String imagePath;
  final IconData icon;

  const ProjectServiceEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.icon,
  });

  @override
  List<Object> get props => [id, title, description, imagePath, icon];
}
