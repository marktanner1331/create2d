import './PropertyGroup.dart';
import '../widgets/NumberFieldWithLabel.dart';
import '../widgets/ColorSwatchWithLabel.dart';
import '../property_mixins/CanvasPropertiesMixin.dart';

class CanvasPropertiesGroup extends PropertyGroup {
  CanvasPropertiesMixin _properties;

  NumberFieldWithLabel _width;
  NumberFieldWithLabel _height;

  ColorSwatchWithLabel _bgColor;

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

    relayout();
  }

  void set myCanvasProperties(CanvasPropertiesMixin properties) {
    _properties = properties;

    _width.value = _properties.canvasWidth;
    _height.value = _properties.canvasHeight;
    _bgColor.color = _properties.backgroundColor;
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