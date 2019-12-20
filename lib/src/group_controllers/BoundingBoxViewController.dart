import 'dart:html';
import 'package:stagexl/stagexl.dart' show JointStyle;

import '../helpers/ColorSwatchController.dart';
import '../helpers/MostCommonValue.dart';
import './ContextController.dart';
import '../property_mixins/BoundingBoxMixin.dart';

class BoundingBoxViewController extends ContextController {
  static BoundingBoxViewController get instance =>
      _instance ?? (_instance = BoundingBoxViewController());
  static BoundingBoxViewController _instance;

  List<BoundingBoxMixin> _models;

  CheckboxInputElement _visible;
  InputElement _thickness;
  ColorSwatchController _lineColorController;
  SelectElement _jointStyle;
  CheckboxInputElement _dashed;
  InputElement _dashLength;
  InputElement _dashSpacing;

  BoundingBoxViewController()
      : super(document.querySelector("#contextTab #boundingBox")) {
    _models = List();

    _visible = view.querySelector("#dashed");
    _visible.onInput.listen(_onVisibleChanged);

    this._thickness = view.querySelector("#thickness");
    _thickness.onInput.listen(_onThicknessChanged);

    _lineColorController =
        ColorSwatchController(view.querySelector("#lineColor"));
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

    for (BoundingBoxMixin model in _models) {
      model.boundingBoxDashSpacing = newDashSpacing;
    }

    dispatchChangeEvent();
  }

  void _onDashLengthChanged(_) {
    num newDashLength = num.tryParse(_dashLength.value);

    if (newDashLength == null) {
      return;
    }

    for (BoundingBoxMixin model in _models) {
      model.boundingBoxDashLength = newDashLength;
    }

    dispatchChangeEvent();
  }

  void _onVisibleChanged(_) {
    bool visible = _visible.checked;

    for (BoundingBoxMixin model in _models) {
      model.boundingBoxVisible = visible;
    }

    _refreshBoundingBoxVisibility();

    dispatchChangeEvent();
  }

  void _refreshBoundingBoxVisibility() {
    bool dashed = _dashed.checked;
    bool visible = _visible.checked;

    _thickness.parent.style.display = visible ? "" : "none";
    _lineColorController.view.parent.style.display = visible ? "" : "none";
    _jointStyle.parent.style.display = visible ? "" : "none";
    _dashed.parent.style.display = visible ? "" : "none";

    _dashLength.parent.style.display = visible && dashed ? "" : "none";
    _dashSpacing.parent.style.display = visible && dashed ? "" : "none";
  }

  void _onDashedChanged(_) {
    bool dashed = _dashed.checked;
    bool visible = _visible.checked;

    _dashLength.parent.style.display = visible && dashed ? "" : "none";
    _dashSpacing.parent.style.display = visible && dashed ? "" : "none";

    for (BoundingBoxMixin model in _models) {
      model.boundingBoxDashed = dashed;
    }

    dispatchChangeEvent();
  }

  void _onJointStyleChanged(_) {
    JointStyle jointStyle;

    switch (_jointStyle.value) {
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

    for (BoundingBoxMixin model in _models) {
      model.boundingBoxJointStyle = jointStyle;
    }

    dispatchChangeEvent();
  }

  void _onLineColorChanged(_) {
    for (BoundingBoxMixin model in _models) {
      model.boundingBoxStrokeColor = _lineColorController.color;
    }

    dispatchChangeEvent();
  }

  void _onThicknessChanged(_) {
    num newThickness = num.tryParse(_thickness.value);

    if (newThickness == null) {
      return;
    }

    for (BoundingBoxMixin model in _models) {
      model.boundingBoxThickness = newThickness;
    }

    dispatchChangeEvent();
  }

  @override
  void refreshProperties() {
    _thickness.value =
        mostCommonValue(_models.map((x) => x.boundingBoxThickness)).toString();
    _lineColorController.color =
        mostCommonValue(_models.map((x) => x.boundingBoxStrokeColor));

    _dashed.checked = mostCommonValue(_models.map((x) => x.boundingBoxDashed));

    _dashLength.value =
        mostCommonValue(_models.map((x) => x.boundingBoxDashLength)).toString();

    _dashSpacing.value =
        mostCommonValue(_models.map((x) => x.boundingBoxDashSpacing))
            .toString();

    _visible.checked =
        mostCommonValue(_models.map((x) => x.boundingBoxVisible));

    _refreshBoundingBoxVisibility();
  }

  void clearModels() => _models.clear();

  void addModel(BoundingBoxMixin model) => _models.add(model);
}
