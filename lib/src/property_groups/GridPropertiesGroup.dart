import './PropertyGroup.dart';
import '../property_mixins/GridPropertiesMixin.dart';
import '../model/GridDisplayType.dart';
import '../model/GridGeometryType.dart';

import '../widgets/NumberFieldWithLabel.dart';
import '../widgets/RadioButtonGroup.dart';

class GridPropertiesGroup extends PropertyGroup {
  GridPropertiesMixin _properties;

  NumberFieldWithLabel _thickness;
  NumberFieldWithLabel _step;

  RadioButtonGroup _displayType;
  RadioButtonGroup _geometryType;

  GridPropertiesGroup() : super("Grid") {
    _thickness = NumberFieldWithLabel("Thickness");
    _thickness.onValueChanged.listen(_onThicknessChanged);
    addChild(_thickness);

    _step = NumberFieldWithLabel("Size");
    _step.onValueChanged.listen(_onStepChanged);
    addChild(_step);

    _displayType = RadioButtonGroup("Display")
      ..addRow(GridDisplayType.None, "None")
      ..addRow(GridDisplayType.Lines, "Lines")
      ..addRow(GridDisplayType.Dots, "Dots");
    _displayType
      ..onSelectionChanged.listen(_onDisplayTypeChanged);
    addChild(_displayType);

    _geometryType = RadioButtonGroup("Geometry")
      ..addRow(GridGeometryType.Isometric, "Isometric")
      ..addRow(GridGeometryType.Square, "Square");
    _geometryType
      ..onSelectionChanged.listen(_onGeometryTypeChanged);
    addChild(_geometryType);
    
    relayout();
  }

  void _onThicknessChanged(_) {
    _properties.gridThickness = _thickness.value;
  }

  void _onStepChanged(_) {
    _properties.gridStep = _step.value;
  }

  void _onDisplayTypeChanged(_) {
    assert(_displayType.selectedModelValue is GridDisplayType);
    _properties.gridDisplayType = _displayType.selectedModelValue as GridDisplayType;
  }

  void _onGeometryTypeChanged(_) {
    assert(_geometryType.selectedModelValue is GridGeometryType);
    _properties.gridGeometryType = _geometryType.selectedModelValue as GridGeometryType;
  } 

  void set myGridProperties(GridPropertiesMixin properties) {
    _properties = properties;

    if (_properties == null) {
      return;
    }

    _thickness.value = _properties.gridThickness;
    _step.value = _properties.gridStep;
    _displayType.switchToRow(_properties.gridDisplayType);
    _geometryType.switchToRow(_properties.gridGeometryType);
  }

  @override
  void relayout() {
    _thickness
      ..x = (preferredWidth / 2) - 10 - _thickness.width
      ..y = 5;

    _step
      ..x = (preferredWidth / 2) - 10 - _step.width
      ..y = _thickness.y + _thickness.height + 5;

      _displayType
        ..x = (preferredWidth / 2) + 10
        ..y = 5;

      _geometryType
        ..x = (preferredWidth / 2) + 10
        ..y = _displayType.y + _displayType.height + 5;
  }
}
