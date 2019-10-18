import 'dart:html';

import '../PropertyGroup.dart';
import '../../property_mixins/CanvasPropertiesMixin.dart';

class CanvasSizeGroup extends PropertyGroup {
  // static CanvasSizeGroup get instance => _instance ?? (_instance = CanvasSizeGroup(document.querySelector("#canvasTab #size")));
  // static CanvasSizeGroup _instance;

  CanvasPropertiesMixin _properties;
  InputElement _width;
  InputElement _height;

  CanvasSizeGroup(Element div) : super(div) {
    _width = div.querySelector("#canvasWidth") as InputElement;
    _width.onInput.listen(_onInput);

    _height = div.querySelector("#canvasHeight") as InputElement;
    _height.onInput.listen(_onInput);
  }

  void _onInput(_) {
    num newWidth = num.tryParse(_width.value);
    num newHeight = num.tryParse(_height.value);

    if(newWidth == null || newHeight == null) {
      return;
    }
    
    _properties.setCanvasSize(newWidth, newHeight);
  }

  void set myCanvasProperties(CanvasPropertiesMixin properties) {
    _properties = properties;
    
    _width.value = _properties.canvasWidth.toString();
    _height.value = _properties.canvasHeight.toString();
    //_bgColor.color = _properties.backgroundColor;
  }
}