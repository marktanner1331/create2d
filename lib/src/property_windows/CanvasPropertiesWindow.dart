import './PropertyWindow.dart';
import '../property_groups/GridPropertiesGroup.dart';
import '../property_groups/SnappingPropertiesGroup.dart';
import '../property_groups/CanvasPropertiesGroup.dart';
import '../view/MainWindow.dart';

class CanvasPropertiesWindow extends PropertyWindow {
  GridPropertiesGroup _grid;
  SnappingPropertiesGroup _snapping;
  CanvasPropertiesGroup _canvas;

  CanvasPropertiesWindow() {
    _canvas = CanvasPropertiesGroup();
    _canvas.isOpen = true;
    addPropertyGroup(_canvas);

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
    _canvas.myCanvasProperties = MainWindow.canvas;
    _grid.myGridProperties = MainWindow.canvas;
    _snapping.mySnappingProperties = MainWindow.canvas;
  }

  @override
  void onExit() {
    _grid.myGridProperties = null;
  }
}