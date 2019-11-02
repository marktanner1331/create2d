import 'dart:html';

import '../helpers/ColorSwatchController.dart';
import './GroupController.dart';
import '../property_mixins/CanvasPropertiesMixin.dart';

class CanvasSizeViewController extends GroupController {
  CanvasPropertiesMixin _model;
  InputElement _width;
  InputElement _height;
  ColorSwatchController _bgColorController;

  CanvasSizeViewController(Element view) : super(view) {
    _width = view.querySelector("#canvasWidth") as InputElement;
    _width.onInput.listen(_onWidthOrHeightChange);

    _height = view.querySelector("#canvasHeight") as InputElement;
    _height.onInput.listen(_onWidthOrHeightChange);

    _bgColorController = ColorSwatchController(view.querySelector("#backgroundColor"));
    _bgColorController.onColorChanged.listen(_onBGColorChanged);
  }

  void _onBGColorChanged(_) {
    _model.backgroundColor = _bgColorController.color;
  }

  void _onWidthOrHeightChange(_) {
    num newWidth = num.tryParse(_width.value);
    num newHeight = num.tryParse(_height.value);

    if(newWidth == null || newHeight == null) {
      return;
    }
    
    _model.setCanvasSize(newWidth, newHeight);
  }

  void set model(CanvasPropertiesMixin value) {
    _model = value;
    refreshProperties();
  }

  @override
  void refreshProperties() {
    _width.value = _model.canvasWidth.toString();
    _height.value = _model.canvasHeight.toString();
    _bgColorController.color = _model.backgroundColor;
  }

  @override
  void onExit() {
    _bgColorController.onExit();
  }
}