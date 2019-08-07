import './PropertyGroup.dart';
import '../../property_mixins/GridPropertiesMixin.dart';
import '../../widgets/NumberFieldWithLabel.dart';

class GridPropertiesGroup extends PropertyGroup {
  GridPropertiesMixin _properties;

  NumberFieldWithLabel _thickness;
  NumberFieldWithLabel _step;

  GridPropertiesGroup(num preferredWidth) : super("Grid", preferredWidth) {
    _thickness = NumberFieldWithLabel()..labelText = "Thickness";
    addChild(_thickness);

    _step = NumberFieldWithLabel()..labelText = "Size";
    addChild(_step);

    relayout();
  }

  void set myGridProperties(GridPropertiesMixin properties) {
    _properties = properties;

    if (_properties == null) {
      return;
    }

    _thickness.value = _properties.gridThickness;
    _step.value = _properties.gridStep;
  }

  @override
  void relayout() {
    _thickness
      ..valueOffset = preferredWidth / 3
      ..y = 5;

    _step
      ..valueOffset = preferredWidth / 3
      ..y = _thickness.y + _thickness.height + 5;
  }
}
