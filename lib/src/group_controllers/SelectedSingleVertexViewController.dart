import 'dart:html';
import 'package:stagexl/stagexl.dart' as stageXL;

import '../helpers/TextInputViewController.dart';
import '../view/MainWindow.dart';
import './ContextController.dart';
import '../property_mixins/SelectedVerticesMixin.dart';

class SelectedSingleVertexViewController extends ContextController {  
  static SelectedSingleVertexViewController get instance =>
      _instance ??
      (_instance = SelectedSingleVertexViewController(
          document.querySelector("#contextTab #selectedSingleVertex")));
  static SelectedSingleVertexViewController _instance;

  SelectedVerticesMixin _properties;

  TextInputViewController _x;
  TextInputViewController _y;

  SelectedSingleVertexViewController(Element div) : super(div) {
    this._x = TextInputViewController("#x", _onXChanged);
    this._y = TextInputViewController("#y", _onYChanged);
  }

  void set properties(SelectedVerticesMixin value) {
    _properties = value;
  }

  void _onXChanged(String newValue) {
    if (_properties == null) {
      return;
    }

    num newX = MainWindow.canvas.unitsToPixels(_x.value);

    if (newX != null) {
      _properties.x = newX;
    }
  }

  void _onYChanged(String newValue) {
    if (_properties == null) {
      return;
    }
    
    num newY = MainWindow.canvas.unitsToPixels(_y.value);

    if (newY != null) {
      _properties.y = newY;
    }
  }

  @override
  void refreshProperties() {
    stageXL.Rectangle rect = _properties.getBoundingBox();
    _x.value = MainWindow.canvas.pixelsToUnits(rect.left);
    _y.value = MainWindow.canvas.pixelsToUnits(rect.top);
  }
}
