import 'package:apartment/features/projects/domain/entities/saved_design_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'saved_designs_filter_state.dart';

class SavedDesignsFilterCubit extends Cubit<SavedDesignsFilterState> {
  SavedDesignsFilterCubit()
      : super(const SavedDesignsFilterState(
          originalDesigns: [],
          filteredDesigns: [],
        ));

  void init(List<SavedDesignEntity> designs) {
    emit(state.copyWithFilter(
      originalDesigns: designs,
      filteredDesigns: _applyFilters(
        designs,
        state.searchQuery,
        state.selectedProject,
        state.selectedStyle,
        state.isNewestFirst,
      ),
    ));
  }

  void search(String query) {
    final newFiltered = _applyFilters(
      state.originalDesigns,
      query,
      state.selectedProject,
      state.selectedStyle,
      state.isNewestFirst,
    );
    emit(state.copyWithFilter(
      searchQuery: query,
      filteredDesigns: newFiltered,
    ));
  }

  void toggleProjectFilter(String project) {
    final isSelected = state.selectedProject == project;
    final newFiltered = _applyFilters(
      state.originalDesigns,
      state.searchQuery,
      isSelected ? null : project,
      state.selectedStyle,
      state.isNewestFirst,
    );
    emit(state.copyWithFilter(
      selectedProject: isSelected ? null : project,
      clearProject: isSelected,
      filteredDesigns: newFiltered,
    ));
  }

  void toggleStyleFilter(String style) {
    final isSelected = state.selectedStyle == style;
    final newFiltered = _applyFilters(
      state.originalDesigns,
      state.searchQuery,
      state.selectedProject,
      isSelected ? null : style,
      state.isNewestFirst,
    );
    emit(state.copyWithFilter(
      selectedStyle: isSelected ? null : style,
      clearStyle: isSelected,
      filteredDesigns: newFiltered,
    ));
  }

  void setSortOrder(bool isNewestFirst) {
    if (state.isNewestFirst == isNewestFirst) return;
    final newFiltered = _applyFilters(
      state.originalDesigns,
      state.searchQuery,
      state.selectedProject,
      state.selectedStyle,
      isNewestFirst,
    );
    emit(state.copyWithFilter(
      isNewestFirst: isNewestFirst,
      filteredDesigns: newFiltered,
    ));
  }

  void clearAllFilters() {
    final newFiltered = _applyFilters(
      state.originalDesigns,
      '',
      null,
      null,
      true,
    );
    emit(state.copyWithFilter(
      searchQuery: '',
      selectedProject: null,
      clearProject: true,
      selectedStyle: null,
      clearStyle: true,
      isNewestFirst: true,
      filteredDesigns: newFiltered,
    ));
  }

  List<SavedDesignEntity> _applyFilters(
    List<SavedDesignEntity> source,
    String query,
    String? project,
    String? style,
    bool isNewestFirst,
  ) {
    var result = List<SavedDesignEntity>.from(source);

    // Search
    if (query.trim().isNotEmpty) {
      final q = query.toLowerCase();
      result = result.where((d) {
        return d.name.toLowerCase().contains(q) ||
            d.projectName.toLowerCase().contains(q) ||
            d.unitName.toLowerCase().contains(q);
      }).toList();
    }

    // Project
    if (project != null && project.isNotEmpty) {
      result = result.where((d) => d.projectName == project).toList();
    }

    // Style
    if (style != null && style.isNotEmpty) {
      result = result.where((d) => d.style == style).toList();
    }

    // Sort (Fallback to id if createdAt is missing)
    result.sort((a, b) {
      final dateA = a.createdAt;
      final dateB = b.createdAt;
      if (dateA != null && dateB != null) {
        return isNewestFirst ? dateB.compareTo(dateA) : dateA.compareTo(dateB);
      }
      return isNewestFirst ? b.id.compareTo(a.id) : a.id.compareTo(b.id);
    });

    return result;
  }
}
