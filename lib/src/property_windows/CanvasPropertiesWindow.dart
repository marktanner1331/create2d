import './PropertyWindow.dart';
import './groups/GridPropertiesGroup.dart';
import './groups/SnappingPropertiesGroup.dart';
import '../view/MainWindow.dart';

class CanvasPropertiesWindow extends PropertyWindow {
  GridPropertiesGroup _grid;
  SnappingPropertiesGroup _snapping;

  CanvasPropertiesWindow() {
    _grid = GridPropertiesGroup(preferredWidth);
    _grid.isOpen = true;
    addPropertyGroup(_grid);

    _snapping = SnappingPropertiesGroup(preferredWidth);
    _snapping.isOpen = false;
    addPropertyGroup(_snapping);
  }

  @override
  String get displayName => "Canvas";

  @override
  String get modelName => "CANVAS";

  @override
  void onEnter() {
    _grid.myGridProperties = MainWindow.currentCanvas;
    _snapping.myGridProperties = MainWindow.currentCanvas;
  }

  @override
  void onExit() {
    _grid.myGridProperties = null;
  }
}