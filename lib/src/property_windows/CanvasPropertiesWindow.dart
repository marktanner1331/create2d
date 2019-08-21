import './PropertyWindow.dart';
import '../property_groups/GridPropertiesGroup.dart';
import '../property_groups/SnappingPropertiesGroup.dart';
import '../view/MainWindow.dart';

class CanvasPropertiesWindow extends PropertyWindow {
  GridPropertiesGroup _grid;
  SnappingPropertiesGroup _snapping;

  CanvasPropertiesWindow() {
    _grid = GridPropertiesGroup();
    _grid.isOpen = true;
    addPropertyGroup(_grid);

    _snapping = SnappingPropertiesGroup();
    _snapping.isOpen = true;
    addPropertyGroup(_snapping);
  }

  @override
  String get displayName => "Canvas";

  @override
  String get modelName => "CANVAS";

  @override
  void onEnter() {
    _grid.myGridProperties = MainWindow.canvas;
    _snapping.myGridProperties = MainWindow.canvas;
  }

  @override
  void onExit() {
    _grid.myGridProperties = null;
  }
}