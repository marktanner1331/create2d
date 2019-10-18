import 'dart:html';

import '../../property_mixins/LinePropertiesMixin.dart';
import './ContextGroup.dart';

class LineGroup extends ContextGroup {
  static LineGroup get instance =>
      _instance ??
      (_instance = LineGroup(document.querySelector("#contextTab #line")));
  static LineGroup _instance;

  LinePropertiesMixin _properties;
  InputElement _thickness;

  LineGroup(Element div) : super(div) {
    this._thickness = div.querySelector("#thickness");
    _thickness.onInput.listen(_onThicknessChanged);
  }

  void _onThicknessChanged(_) {
    if (_properties == null) {
      return;
    }

    num newThickness = num.tryParse(_thickness.value);

    if (newThickness != null) {
      _properties.thickness = newThickness;
    }
  }

  void set properties(LinePropertiesMixin value) {
    _properties = value;
  }

  @override
  void onEnter() {
    _thickness.value = _properties.thickness.toString();
  }

  @override
  void onExit() {}
}
