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
  SelectElement _font;
  CheckboxInputElement _bold;
  CheckboxInputElement _italic;
  CheckboxInputElement _underline;

  TextStyleViewController() : super(document.querySelector("#contextTab #textStyle")) {
    _models = List();

    this._textSize = view.querySelector("#textSize");
    _textSize.onInput.listen(_onTextSizeChanged);

    _textColorController = ColorSwatchController(view.querySelector("#textColor"));
    _textColorController.onColorChanged.listen(_onTextColorChanged);

    _font = view.querySelector("#font");
    _font.onChange.listen(_onFontChanged);

    _bold = view.querySelector("#bold");
    _bold.onInput.listen(_onBoldChanged);

    _italic = view.querySelector("#italic");
    _italic.onInput.listen(_onItalicChanged);

    _underline = view.querySelector("#underline");
    _underline.onInput.listen(_onUnderlineChanged);
  }

  void _onFontChanged(_) {
    for(TextStyleMixin model in _models) {
      model.font = _font.value;
    }

    dispatchChangeEvent();
  }

  void _onBoldChanged(_) {
    for(TextStyleMixin model in _models) {
      model.bold = _bold.checked;
    }

    dispatchChangeEvent();
  }

  void _onItalicChanged(_) {
    for(TextStyleMixin model in _models) {
      model.italic = _italic.checked;
    }

    dispatchChangeEvent();
  }

  void _onUnderlineChanged(_) {
    for(TextStyleMixin model in _models) {
      model.underline = _underline.checked;
    }

    dispatchChangeEvent();
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
