import 'dart:html';

import '../helpers/ColorSwatchController.dart';
import '../helpers/MostCommonValue.dart';
import './ContextController.dart';
import '../property_mixins/TextStyleMixin.dart';

class TextStyleViewController extends ContextController {
  static TextStyleViewController get instance =>
      _instance ?? (_instance = TextStyleViewController());
  static TextStyleViewController _instance;

  List<TextStyleMixin> _models;

  InputElement _textSize;
  ColorSwatchController _textColorController;

  TextStyleViewController() : super(document.querySelector("#contextTab #textStyle")) {
    _models = List();

    this._textSize = view.querySelector("#textSize");
    _textSize.onInput.listen(_onTextSizeChanged);

    _textColorController = ColorSwatchController(view.querySelector("#textColor"));
    _textColorController.onColorChanged.listen(_onTextColorChanged);
  }

  void _onTextColorChanged(_) {
    for(TextStyleMixin model in _models) {
      model.textColor = _textColorController.color;
    }

    dispatchChangeEvent();
  }

  void _onTextSizeChanged(_) {
    num newThickness = num.tryParse(_textSize.value);

    if (newThickness == null) {
      return;
    }

    for(TextStyleMixin model in _models) {
      model.textSize = newThickness;
    }

    dispatchChangeEvent();
  }

  void clearModels() => _models.clear();

  void addModel(TextStyleMixin model) => _models.add(model);

  @override
  void refreshProperties() {
    _textSize.value = mostCommonValue(_models.map((x) => x.textSize)).toString();
    _textColorController.color = mostCommonValue(_models.map((x) => x.textColor));
  }
}
