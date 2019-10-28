import 'dart:html';

import './GroupController.dart';
import '../model/GridDisplayType.dart';
import '../model/GridGeometryType.dart';
import '../property_mixins/GridPropertiesMixin.dart';

class GridViewController extends GroupController {
  GridPropertiesMixin _properties;

  TextInputElement _thickness;
  TextInputElement _step;

  InputElement _displayNone;
  InputElement _displayLines;
  InputElement _displayDots;

  InputElement _geometryIsometric;
  InputElement _geometrySquare;

  GridViewController(Element div) : super(div) {
    _thickness = div.querySelector("#gridThickness") as InputElement;
    _thickness.onInput.listen(_onThicknessChanged);

    _step = div.querySelector("#gridStep") as InputElement;
    _step.addEventListener("focusout", _onStepFocusOut);
    _step.onInput.listen(_onStepChanged);

    _displayNone = div.querySelector("#none");
    _displayNone.onInput.listen(_onDisplayChanged);
    
    _displayLines = div.querySelector("#lines");
    _displayLines.onInput.listen(_onDisplayChanged);

    _displayDots = div.querySelector("#dots");
    _displayDots.onInput.listen(_onDisplayChanged);

    _geometryIsometric = div.querySelector("#isometric");
    _geometryIsometric.onInput.listen(_onGeometryChanged);

    _geometrySquare = div.querySelector("#square");
    _geometrySquare.onInput.listen(_onGeometryChanged);
  }

  void _onGeometryChanged(_) {
    if(_geometryIsometric.checked) {
      _properties.gridGeometryType = GridGeometryType.Isometric;
    } else {
      _properties.gridGeometryType = GridGeometryType.Square;
    }
  }

  void _onDisplayChanged(_) {
    if(_displayNone.checked) {
      _properties.gridDisplayType = GridDisplayType.None;
    } else if(_displayLines.checked) {
      _properties.gridDisplayType = GridDisplayType.Lines;
    } else {
      _properties.gridDisplayType = GridDisplayType.Dots;
    }
  }

  void _onThicknessChanged(_) {
    num thickness = num.tryParse(_thickness.value);

    if(thickness != null) {
      _properties.gridThickness = thickness;
    }
  }

  void _onStepFocusOut(_) {
    _step.value = _properties.gridStep.toString();
  }

  void _onStepChanged(_) {
    num step = num.tryParse(_step.value);
    
    if(step == null) {
      return;
    }

    _properties.gridStep = step;
  }

  void set myGridProperties(GridPropertiesMixin properties) {
    _properties = properties;
    
    _thickness.value = _properties.gridThickness.toString();
    _step.value = _properties.gridStep.toString();

    switch(_properties.gridDisplayType) {
      case GridDisplayType.None:
        _displayNone.checked = true;
        break;
      case GridDisplayType.Dots:
        _displayDots.checked = true;
        break;
      case GridDisplayType.Lines:
        _displayLines.checked = true;
        break;
    }

    switch(_properties.gridGeometryType) {
      case GridGeometryType.Isometric:
        _geometryIsometric.checked = true;
        break;
      case GridGeometryType.Square:
        _geometrySquare.checked = true;
        break;
    }
  }
}