import 'dart:html';

import './GroupController.dart';
import '../view/MainWindow.dart';
import '../model/GridDisplayType.dart';
import '../model/GridGeometryType.dart';
import '../property_mixins/GridPropertiesMixin.dart';
import '../helpers/ColorSwatchController.dart';

class GridViewController extends GroupController {
  GridPropertiesMixin _model;

  TextInputElement _thickness;
  TextInputElement _step;

  InputElement _displayNone;
  InputElement _displayLines;
  InputElement _displayDots;

  InputElement _geometryIsometric;
  InputElement _geometrySquare;

  ColorSwatchController _gridColorController;

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

    _gridColorController = ColorSwatchController(div.querySelector("#gridColor"));
    _gridColorController.onColorChanged.listen(_onGridColorChanged);
  }

  void _onGridColorChanged(_) {
    _model.gridColor = _gridColorController.color;
  }

  void _onGeometryChanged(_) {
    if(_geometryIsometric.checked) {
      _model.gridGeometryType = GridGeometryType.Isometric;
    } else {
      _model.gridGeometryType = GridGeometryType.Square;
    }
  }

  void _onDisplayChanged(_) {
    if(_displayNone.checked) {
      _model.gridDisplayType = GridDisplayType.None;
    } else if(_displayLines.checked) {
      _model.gridDisplayType = GridDisplayType.Lines;
    } else {
      _model.gridDisplayType = GridDisplayType.Dots;
    }
  }

  void _onThicknessChanged(_) {
    num thickness = num.tryParse(_thickness.value);

    if(thickness != null) {
      _model.gridThickness = thickness;
    }
  }

  void _onStepFocusOut(_) {
    _step.value = MainWindow.canvas.pixelsToUnits(_model.gridStep);
  }

  void _onStepChanged(_) {
    num step = MainWindow.canvas.unitsToPixels(_step.value);
    
    if(step == null) {
      return;
    }

    _model.gridStep = step;
  }

  void set model(GridPropertiesMixin value) {
    _model = value;
    refreshProperties();
  }

  @override
  void refreshProperties() {
    _thickness.value = _model.gridThickness.toString();
    _step.value = MainWindow.canvas.pixelsToUnits(_model.gridStep);

    switch(_model.gridDisplayType) {
      case GridDisplayType.None:
        _displayNone.checked = true;
        break;
      case GridDisplayType.Dots:
        _displayDots.checked = true;
        break;
      case GridDisplayType.Lines:
        _displayLines.checked = true;
        break;
      default:
        throw Error();
    }

    switch(_model.gridGeometryType) {
      case GridGeometryType.Isometric:
        _geometryIsometric.checked = true;
        break;
      case GridGeometryType.Square:
        _geometrySquare.checked = true;
        break;
      default:
        throw Error();
    }

    _gridColorController.color = _model.gridColor;
  }

  @override
  void onExit() {
    _gridColorController.onExit();
  }
}