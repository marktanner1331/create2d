import 'dart:html';

import '../helpers/MostCommonValue.dart';
import './ContextController.dart';
import '../property_mixins/LinePropertiesMixin.dart';

class LineViewController extends ContextController {
  static LineViewController get instance =>
      _instance ?? (_instance = LineViewController());
  static LineViewController _instance;

  List<LinePropertiesMixin> _models;
  InputElement _thickness;

  LineViewController() : super(document.querySelector("#contextTab #line")) {
    _models = List();

    this._thickness = view.querySelector("#thickness");
    _thickness.onInput.listen(_onThicknessChanged);
  }

  void _onThicknessChanged(_) {
    num newThickness = num.tryParse(_thickness.value);

    if (newThickness == null) {
      return;
    }

    for(LinePropertiesMixin model in _models) {
      model.thickness = newThickness;
    }
  }

  @override
  void refreshProperties() {
    _thickness.value = mostCommonValue(_models.map((x) => x.thickness)).toString();
  }

  void clearModels() => _models.clear();

  void addModel(LinePropertiesMixin model) => _models.add(model);
}
