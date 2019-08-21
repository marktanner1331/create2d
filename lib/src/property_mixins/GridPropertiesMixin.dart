import '../view/Grid.dart';

import '../model/GridDisplayType.dart';
import '../model/GridGeometryType.dart';

mixin GridPropertiesMixin {
  Grid get grid;

   GridDisplayType _gridDisplayType = GridDisplayType.None;
   GridDisplayType get gridDisplayType => _gridDisplayType;
   void set gridDisplayType(GridDisplayType value) {
    _gridDisplayType = value;
    _didChangeGridProperty();
  }

   GridGeometryType _gridGeometryType = GridGeometryType.Isometric;
   GridGeometryType get gridGeometryType => _gridGeometryType;
   void set gridGeometryType(GridGeometryType value) {
    _gridGeometryType = value;
    _didChangeGridProperty();
  }

   num _gridThickness = 1;
   num get gridThickness => _gridThickness;
   void set gridThickness(num value) {
    _gridThickness = value;
    _didChangeGridProperty();
  }

   int _gridColor = 0xff000000;
   int get gridColor => _gridColor;
   void set gridColor(int value) {
    _gridColor = value;
    _didChangeGridProperty();
  }
  
   num _gridStep = 50;
   num get gridStep => _gridStep;
   void set gridStep(num value) {
    _gridStep = value;
    _didChangeGridProperty();
  }

  void _didChangeGridProperty() {
    grid.refresh();
  }
}