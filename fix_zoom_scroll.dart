import 'dart:io';

void main() {
  final viewerFile = File('lib/features/projects/presentation/widgets/details/unit/unit_floor_plan_viewer.dart');
  var viewerContent = viewerFile.readAsStringSync();

  viewerContent = viewerContent.replaceFirst(
    'const UnitFloorPlanViewer({super.key, required this.unit, required this.heroTag});',
    'final ValueChanged<bool>? onZoomChanged;\n\n  const UnitFloorPlanViewer({super.key, required this.unit, required this.heroTag, this.onZoomChanged});'
  );

  viewerContent = viewerContent.replaceFirst(
    'setState(() {\n        _isZoomedIn = true;\n      });',
    'setState(() {\n        _isZoomedIn = true;\n      });\n      widget.onZoomChanged?.call(true);'
  );

  viewerContent = viewerContent.replaceFirst(
    'setState(() {\n        _isZoomedIn = false;\n      });',
    'setState(() {\n        _isZoomedIn = false;\n      });\n      widget.onZoomChanged?.call(false);'
  );

  viewerContent = viewerContent.replaceFirst(
    '_isZoomedIn = _transformationControllers[index].value.getMaxScaleOnAxis() > 1.01;',
    '_isZoomedIn = _transformationControllers[index].value.getMaxScaleOnAxis() > 1.01;\n                      widget.onZoomChanged?.call(_isZoomedIn);'
  );

  viewerFile.writeAsStringSync(viewerContent);


  final screenFile = File('lib/features/projects/presentation/screens/unit_details_screen.dart');
  var screenContent = screenFile.readAsStringSync();

  screenContent = screenContent.replaceFirst(
    'class UnitDetailsScreen extends StatelessWidget {',
    'class UnitDetailsScreen extends StatefulWidget {'
  );

  screenContent = screenContent.replaceFirst(
    '  const UnitDetailsScreen({\n    super.key,\n    required this.unit,\n    required this.heroTag,\n  });\n\n  @override\n  Widget build(BuildContext context) {',
    '  const UnitDetailsScreen({\n    super.key,\n    required this.unit,\n    required this.heroTag,\n  });\n\n  @override\n  State<UnitDetailsScreen> createState() => _UnitDetailsScreenState();\n}\n\nclass _UnitDetailsScreenState extends State<UnitDetailsScreen> {\n  bool _isImageZoomed = false;\n\n  @override\n  Widget build(BuildContext context) {'
  );

  screenContent = screenContent.replaceFirst(
    'body: SingleChildScrollView(',
    'body: SingleChildScrollView(\n        physics: _isImageZoomed ? const NeverScrollableScrollPhysics() : null,'
  );

  // Safely replace unit: unit with unit: widget.unit
  screenContent = screenContent.replaceAll(
    'unit: unit',
    'unit: widget.unit'
  );
  
  screenContent = screenContent.replaceAll(
    'heroTag: heroTag',
    'heroTag: widget.heroTag'
  );
  
  screenContent = screenContent.replaceFirst(
    'UnitFloorPlanViewer(unit: widget.unit, heroTag: widget.heroTag)',
    'UnitFloorPlanViewer(\n              unit: widget.unit,\n              heroTag: widget.heroTag,\n              onZoomChanged: (isZoomed) {\n                setState(() {\n                  _isImageZoomed = isZoomed;\n                });\n              },\n            )'
  );

  screenFile.writeAsStringSync(screenContent);
}
