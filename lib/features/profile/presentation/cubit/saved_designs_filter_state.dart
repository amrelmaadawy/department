import 'package:apartment/features/projects/domain/entities/saved_design_entity.dart';
import 'package:equatable/equatable.dart';

class SavedDesignsFilterState extends Equatable {
  final List<SavedDesignEntity> originalDesigns;
  final List<SavedDesignEntity> filteredDesigns;
  final String searchQuery;
  final String? selectedProject;
  final String? selectedStyle;
  final bool isNewestFirst;

  const SavedDesignsFilterState({
    required this.originalDesigns,
    required this.filteredDesigns,
    this.searchQuery = '',
    this.selectedProject,
    this.selectedStyle,
    this.isNewestFirst = true,
  });

  SavedDesignsFilterState copyWith({
    List<SavedDesignEntity>? originalDesigns,
    List<SavedDesignEntity>? filteredDesigns,
    String? searchQuery,
    String? selectedProject,
    String? selectedStyle,
    bool? isNewestFirst,
  }) {
    return SavedDesignsFilterState(
      originalDesigns: originalDesigns ?? this.originalDesigns,
      filteredDesigns: filteredDesigns ?? this.filteredDesigns,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedProject: selectedProject, // Nullable override needs exact passing if we want to clear it, but typically we clear with special value or passing null. Let's handle clear via a method in Cubit.
      selectedStyle: selectedStyle,
      isNewestFirst: isNewestFirst ?? this.isNewestFirst,
    );
  }

  // To properly handle clearing nullable fields:
  SavedDesignsFilterState copyWithFilter({
    List<SavedDesignEntity>? originalDesigns,
    List<SavedDesignEntity>? filteredDesigns,
    String? searchQuery,
    String? selectedProject,
    bool clearProject = false,
    String? selectedStyle,
    bool clearStyle = false,
    bool? isNewestFirst,
  }) {
    return SavedDesignsFilterState(
      originalDesigns: originalDesigns ?? this.originalDesigns,
      filteredDesigns: filteredDesigns ?? this.filteredDesigns,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedProject: clearProject ? null : (selectedProject ?? this.selectedProject),
      selectedStyle: clearStyle ? null : (selectedStyle ?? this.selectedStyle),
      isNewestFirst: isNewestFirst ?? this.isNewestFirst,
    );
  }

  List<String> get availableProjects {
    return originalDesigns
        .where((d) => d.projectName.isNotEmpty)
        .map((d) => d.projectName)
        .toSet()
        .toList()
      ..sort();
  }

  List<String> get availableStyles {
    return originalDesigns
        .where((d) => d.style.isNotEmpty)
        .map((d) => d.style)
        .toSet()
        .toList()
      ..sort();
  }

  @override
  List<Object?> get props => [
        originalDesigns,
        filteredDesigns,
        searchQuery,
        selectedProject,
        selectedStyle,
        isNewestFirst,
      ];
}
