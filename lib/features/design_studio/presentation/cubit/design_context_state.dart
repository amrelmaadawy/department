import 'package:equatable/equatable.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';

class DesignContextState extends Equatable {
  final ProjectUnitEntity? selectedUnit;
  final double baseArea;
  final bool isSyncing;
  final bool isOffline;
  final bool draftRestored;
  final String? syncMessage;
  final DateTime? lastUpdatedAt;
  final Map<String, dynamic> activeDraftData;

  const DesignContextState({
    this.selectedUnit,
    this.baseArea = 100.0,
    this.isSyncing = false,
    this.isOffline = false,
    this.draftRestored = false,
    this.syncMessage,
    this.lastUpdatedAt,
    this.activeDraftData = const {},
  });

  DesignContextState copyWith({
    ProjectUnitEntity? selectedUnit,
    double? baseArea,
    bool clearUnit = false,
    bool? isSyncing,
    bool? isOffline,
    bool? draftRestored,
    String? syncMessage,
    bool clearSyncMessage = false,
    DateTime? lastUpdatedAt,
    Map<String, dynamic>? activeDraftData,
  }) {
    return DesignContextState(
      selectedUnit: clearUnit ? null : (selectedUnit ?? this.selectedUnit),
      baseArea: baseArea ?? this.baseArea,
      isSyncing: isSyncing ?? this.isSyncing,
      isOffline: isOffline ?? this.isOffline,
      draftRestored: draftRestored ?? this.draftRestored,
      syncMessage: clearSyncMessage ? null : (syncMessage ?? this.syncMessage),
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      activeDraftData: activeDraftData ?? this.activeDraftData,
    );
  }

  bool get isCustomArea => selectedUnit == null;

  @override
  List<Object?> get props => [
        selectedUnit,
        baseArea,
        isSyncing,
        isOffline,
        draftRestored,
        syncMessage,
        lastUpdatedAt,
        activeDraftData,
      ];
}
