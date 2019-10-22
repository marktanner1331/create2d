import 'dart:html';

import './ContextController.dart';
import '../property_mixins/LinePropertiesMixin.dart';

class LineViewController extends ContextController {
  static LineViewController get instance =>
      _instance ??
      (_instance = LineViewController(document.querySelector("#contextTab #line")));
  static LineViewController _instance;

  LinePropertiesMixin _properties;
  InputElement _thickness;

  LineViewController(Element div) : super(div) {
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
