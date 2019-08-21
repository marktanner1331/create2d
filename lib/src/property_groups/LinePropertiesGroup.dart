import './PropertyGroup.dart';
import '../widgets/NumberFieldWithLabel.dart';
import '../property_mixins/LinePropertiesMixin.dart';

class LinePropertiesGroup extends PropertyGroup {
  LinePropertiesMixin _myMixin;

  NumberFieldWithLabel _thickness;

  LinePropertiesGroup(LinePropertiesMixin myMixin) : super("Line") {
    this._myMixin = myMixin;

    _thickness = NumberFieldWithLabel("Thickness");
    _thickness.onValueChanged.listen(_onThicknessChanged);
    _thickness.value = _myMixin.thickness;
    addChild(_thickness);

    relayout();
  }

  void _onThicknessChanged(_) {
    _myMixin.thickness = _thickness.value;
  }

  @override
  void relayout() {
    _thickness
      ..x = (preferredWidth / 2) - 10 - _thickness.width
      ..y = 5;
  }
}