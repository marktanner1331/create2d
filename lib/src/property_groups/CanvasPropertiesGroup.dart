import './PropertyGroup.dart';
import '../widgets/NumberFieldWithLabel.dart';
import '../widgets/ColorSwatchWithLabel.dart';
import '../widgets/RadioButtonGroup.dart';
import '../property_mixins/CanvasPropertiesMixin.dart';
import '../model/CanvasUnitType.dart';

class CanvasPropertiesGroup extends PropertyGroup {
  CanvasPropertiesMixin _properties;

  NumberFieldWithLabel _width;
  NumberFieldWithLabel _height;

  ColorSwatchWithLabel _bgColor;
  RadioButtonGroup _units;
  NumberFieldWithLabel _ppu;

  CanvasPropertiesGroup() : super("Canvas") {
    _width = NumberFieldWithLabel("Canvas Width")
      ..onValueChanged.listen(_onWidthChanged);
    addChild(_width);

    _height = NumberFieldWithLabel("Canvas Height")
      ..onValueChanged.listen(_onHeightChanged);
    addChild(_height);

    _bgColor = ColorSwatchWithLabel("Background Color")
      ..onColorChanged.listen(_onBGColorChanged);
    addChild(_bgColor);

    _units = RadioButtonGroup("Measurement Units");
    _units.addRow(CanvasUnitType.PIXEL, "Pixels");
    _units.addRow(CanvasUnitType.MM, "Millimeters");
    _units.addRow(CanvasUnitType.CM, "Centimeters");
    _units.addRow(CanvasUnitType.M, "Meters");
    _units.addRow(CanvasUnitType.KM, "Kilometers");
    _units.addRow(CanvasUnitType.INCH, "Inches");
    _units.addRow(CanvasUnitType.FOOT, "Feet");
    _units.addRow(CanvasUnitType.MILE, "Miles");
    addChild(_units);

    _ppu = NumberFieldWithLabel("Pixels Per Unit")
      ..onValueChanged.listen(_onPPUChanged);
    addChild(_ppu);

    relayout();
  }

  void set myCanvasProperties(CanvasPropertiesMixin properties) {
    _properties = properties;

    _width.value = _properties.canvasWidth;
    _height.value = _properties.canvasHeight;
    _bgColor.color = _properties.backgroundColor;
  }

   void _onPPUChanged(_) {
    
  }

  void _onWidthChanged(_) {
    _properties.setCanvasSize(_width.value, _height.value);
  }

  void _onHeightChanged(_) {
    _properties.setCanvasSize(_width.value, _height.value);
  }

  void _onBGColorChanged(_) {
    _properties.backgroundColor = _bgColor.color;
  }

  @override
  void relayout() {
    _width
      ..x = 10
      ..y = 5;

    _height
      ..x = 10
      ..y = _width.y + _width.height + 5;

    _bgColor
      ..x = 10
      ..y = _height.y + _height.height + 5;
  }
}