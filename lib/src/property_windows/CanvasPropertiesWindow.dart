import './PropertyWindow.dart';
import './groups/GridPropertiesGroup.dart';
import '../view/MainWindow.dart';

class CanvasPropertiesWindow extends PropertyWindow {
  GridPropertiesGroup _grid;

  CanvasPropertiesWindow() {
    _grid = GridPropertiesGroup(preferredWidth);
    _grid.isOpen = true;
    addPropertyGroup(_grid);
  }

  @override
  String get displayName => "Canvas";

  @override
  String get modelName => "CANVAS";

  @override
  void onEnter() {
    _grid.myGridProperties = MainWindow.currentCanvas;
  }

  @override
  void onExit() {
    _grid.myGridProperties = null;
  }
}