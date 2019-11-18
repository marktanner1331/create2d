import 'dart:html';

import '../view/MainWindow.dart';
import './ContextController.dart';
import '../property_mixins/SelectedVerticesMixin.dart';

class SelectedMultipleVerticesViewController extends ContextController {
  static SelectedMultipleVerticesViewController get instance =>
      _instance ?? (_instance = SelectedMultipleVerticesViewController());
  static SelectedMultipleVerticesViewController _instance;

  SelectedVerticesMixin _properties;

  InputElement _numVertices;
  InputElement _x;
  InputElement _y;
  InputElement _width;
  InputElement _height;

  SelectedMultipleVerticesViewController()
      : super(document.querySelector("#contextTab #selectedMultipleVertices")) {

    this._numVertices = view.querySelector("#numVertices");

    this._x = view.querySelector("#x");
    _x.onInput.listen(_onXChanged);

    this._y = view.querySelector("#y");
    _y.onInput.listen(_onYChanged);

    this._width = view.querySelector("#width");
    _width.onInput.listen(_onWidthChanged);

    this._height = view.querySelector("#height");
    _height.onInput.listen(_onHeightChanged);
  }

  void set properties(SelectedVerticesMixin value) {
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

  void _onWidthChanged(_) {
    if (_properties == null) {
      return;
    }

    num newWidth = MainWindow.canvas.unitsToPixels(_width.value);

    if (newWidth != null) {
      _properties.width = newWidth;
    }
  }

  void _onHeightChanged(_) {
    if (_properties == null) {
      return;
    }

    num newHeight = MainWindow.canvas.unitsToPixels(_height.value);

    if (newHeight != null) {
      _properties.height = newHeight;
    }
  }

  @override
  void refreshProperties() {
    _numVertices.value = _properties.numVertices.toString();

    Rectangle box = _properties.getBoundingBox();
    _x.value = MainWindow.canvas.pixelsToUnits(box.left);
    _y.value = MainWindow.canvas.pixelsToUnits(box.top);
    _width.value = MainWindow.canvas.pixelsToUnits(box.width);
    _height.value = MainWindow.canvas.pixelsToUnits(box.height);
  }
}
