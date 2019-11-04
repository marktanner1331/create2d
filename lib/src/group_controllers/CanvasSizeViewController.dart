import 'dart:html';

import './GroupController.dart';
import '../property_mixins/CanvasPropertiesMixin.dart';

class CanvasSizeViewController extends GroupController {
  CanvasPropertiesMixin _model;
  InputElement _width;
  InputElement _height;

  CanvasSizeViewController(Element div) : super(div) {
    _width = div.querySelector("#canvasWidth") as InputElement;
    _width.onInput.listen(_onWidthOrHeightChange);

    _height = div.querySelector("#canvasHeight") as InputElement;
    _height.onInput.listen(_onWidthOrHeightChange);
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
    //_bgColor.color = _properties.backgroundColor;
  }
}