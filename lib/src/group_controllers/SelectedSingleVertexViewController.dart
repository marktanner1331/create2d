import 'dart:html';

import '../view/MainWindow.dart';
import './ContextController.dart';
import '../property_mixins/SelectedSingleVertexMixin.dart';

class SelectedSingleVertexViewController extends ContextController {  
  static SelectedSingleVertexViewController get instance =>
      _instance ??
      (_instance = SelectedSingleVertexViewController(
          document.querySelector("#contextTab #selectedSingleVertex")));
  static SelectedSingleVertexViewController _instance;

  SelectedSingleVertexMixin _properties;

  InputElement _x;
  InputElement _y;

  SelectedSingleVertexViewController(Element div) : super(div) {
    this._x = div.querySelector("#x");
    _x.onInput.listen(_onXChanged);

    this._y = div.querySelector("#y");
    _y.onInput.listen(_onYChanged);
  }

  void set properties(SelectedSingleVertexMixin value) {
    _properties = value;
  }

  void _onXChanged(_) {
    if (_properties == null) {
      return;
    }

    num newX = MainWindow.canvas.unitsToPixels(_x.value);

    if (newX != null) {
      _properties.x = newX;
    }
  }

  void _onYChanged(_) {
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
    _x.value = MainWindow.canvas.pixelsToUnits(_properties.x);
    _y.value = MainWindow.canvas.pixelsToUnits(_properties.y);
  }
}
