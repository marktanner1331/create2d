import 'dart:html';
import 'package:stagexl/stagexl.dart' show JointStyle;

import '../helpers/ColorSwatchController.dart';
import '../helpers/MostCommonValue.dart';
import './ContextController.dart';
import '../property_mixins/LinePropertiesMixin.dart';

class LineViewController extends ContextController {
  static LineViewController get instance =>
      _instance ?? (_instance = LineViewController());
  static LineViewController _instance;

  List<LinePropertiesMixin> _models;

  InputElement _thickness;
  ColorSwatchController _lineColorController;
  SelectElement _jointStyle;
  CheckboxInputElement _dashed;
  InputElement _dashLength;
  InputElement _dashSpacing;

  LineViewController() : super(document.querySelector("#contextTab #line")) {
    _models = List();

    this._thickness = view.querySelector("#thickness");
    _thickness.onInput.listen(_onThicknessChanged);

    _lineColorController = ColorSwatchController(view.querySelector("#lineColor"));
    _lineColorController.onColorChanged.listen(_onLineColorChanged);

    _jointStyle = view.querySelector("#jointStyle");
    _jointStyle.onChange.listen(_onJointStyleChanged);

    _dashed = view.querySelector("#dashed");
    _dashed.onInput.listen(_onDashedChanged);

    _dashLength = view.querySelector("#dashLength");
    _dashLength.onInput.listen(_onDashLengthChanged);

    _dashSpacing = view.querySelector("#dashSpacing");
    _dashSpacing.onInput.listen(_onDashSpacingChanged);
  }

  void _onDashSpacingChanged(_) {
    num newDashSpacing = num.tryParse(_dashSpacing.value);

    if (newDashSpacing == null) {
      return;
    }

    for(LinePropertiesMixin model in _models) {
      model.dashSpacing = newDashSpacing;
    }

    dispatchChangeEvent();
  }

  void _onDashLengthChanged(_) {
    num newDashLength = num.tryParse(_dashLength.value);

    if (newDashLength == null) {
      return;
    }

    for(LinePropertiesMixin model in _models) {
      model.dashLength = newDashLength;
    }

    dispatchChangeEvent();
  }

  void _onDashedChanged(_) {
    bool dashed = _dashed.checked;
    _dashLength.parent.style.display = dashed ? "" : "none";
    _dashSpacing.parent.style.display = dashed ? "" : "none";

    for(LinePropertiesMixin model in _models) {
      model.dashed = dashed;
    }

    dispatchChangeEvent();
  }

  void _onJointStyleChanged(_) {
    JointStyle jointStyle;

    switch(_jointStyle.value) {
      case "bevel":
        jointStyle = JointStyle.BEVEL;
        break;
      case "round":
        jointStyle = JointStyle.ROUND;
        break;
      case "miter":
        jointStyle = JointStyle.MITER;
        break;
      default:
        throw Exception("unknown joint style: ${_jointStyle.value}}");
    }
    
    for(LinePropertiesMixin model in _models) {
      model.jointStyle = jointStyle;
    }

    dispatchChangeEvent();
  }

  void _onLineColorChanged(_) {
    for(LinePropertiesMixin model in _models) {
      model.strokeColor = _lineColorController.color;
    }

    dispatchChangeEvent();
  }

  void _onThicknessChanged(_) {
    num newThickness = num.tryParse(_thickness.value);

    if (newThickness == null) {
      return;
    }

    for(LinePropertiesMixin model in _models) {
      model.thickness = newThickness;
    }

    dispatchChangeEvent();
  }

  @override
  void refreshProperties() {
    _thickness.value = mostCommonValue(_models.map((x) => x.thickness)).toString();
    _lineColorController.color = mostCommonValue(_models.map((x) => x.strokeColor));

    bool dashed = mostCommonValue(_models.map((x) => x.dashed));
    _dashed.checked = dashed;

    _dashLength.value = mostCommonValue(_models.map((x) => x.dashLength)).toString();
    _dashLength.parent.style.display = dashed ? "" : "none";

    _dashSpacing.value = mostCommonValue(_models.map((x) => x.dashSpacing)).toString();
    _dashSpacing.parent.style.display = dashed ? "" : "none";
  }

  void clearModels() => _models.clear();

  void addModel(LinePropertiesMixin model) => _models.add(model);
}
