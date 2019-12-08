import 'dart:html';

import '../property_mixins/SelectedObjectsMixin.dart';
import '../view/MainWindow.dart';
import './ContextController.dart';

class SelectedViewController extends ContextController {
  static SelectedViewController get instance =>
      _instance ?? (_instance = SelectedViewController());
  static SelectedViewController _instance;

  SelectedObjectsMixin _properties;
  set properties(SelectedObjectsMixin value) => _properties = value;

  InputElement _numVertices;
  InputElement _numShapes;
  InputElement _x;
  InputElement _y;
  InputElement _width;
  InputElement _height;
  ButtonInputElement _delete;

  SelectedViewController()
      : super(document.querySelector("#contextTab #selected")) {
    this._numVertices = view.querySelector("#numVertices");

    this._numShapes = view.querySelector("#numShapes");

    this._x = view.querySelector("#x");
    _x.onInput.listen(_onXChanged);

    this._y = view.querySelector("#y");
    _y.onInput.listen(_onYChanged);

    this._width = view.querySelector("#width");
    _width.onInput.listen(_onWidthChanged);

    this._height = view.querySelector("#height");
    _height.onInput.listen(_onHeightChanged);

    _delete = view.querySelector("#delete");
    _delete.onClick.listen(_onDeleteClick);
  }

  void _onXChanged(_) {
    if (_properties == null) {
      return;
    }

    num newX = MainWindow.canvas.unitsToPixels(_x.value);

    if (newX != null) {
      _properties.x = newX;
    }

    dispatchChangeEvent();
  }

  void _onYChanged(_) {
    if (_properties == null) {
      return;
    }

    num newY = MainWindow.canvas.unitsToPixels(_y.value);

    if (newY != null) {
      _properties.y = newY;
    }

    dispatchChangeEvent();
  }

  void _onWidthChanged(_) {
    if (_properties == null) {
      return;
    }

    num newWidth = MainWindow.canvas.unitsToPixels(_width.value);

    if (newWidth != null) {
      _properties.width = newWidth;
    }

    dispatchChangeEvent();
  }

  void _onHeightChanged(_) {
    if (_properties == null) {
      return;
    }

    num newHeight = MainWindow.canvas.unitsToPixels(_height.value);

    if (newHeight != null) {
      _properties.height = newHeight;
    }

    dispatchChangeEvent();
  }

  @override
  void refreshProperties() {
    _numVertices.value = _properties.numVertices.toString();
    _numShapes.value = _properties.numShapes.toString();

    Rectangle box = _properties.getBoundingBox();

    if(_properties.numVertices > 0) {
      _x.parent.style.display = "";
      _y.parent.style.display = "";
      _delete.parent.style.display = "";

      _x.value = MainWindow.canvas.pixelsToUnits(box.left);
      _y.value = MainWindow.canvas.pixelsToUnits(box.top);
    } else {
      _x.parent.style.display = "none";
      _y.parent.style.display = "none";
      _delete.parent.style.display = "none";
    }

    if(_properties.numVertices > 1) {
      _width.parent.style.display = "";
      _height.parent.style.display = "";

      _width.value = MainWindow.canvas.pixelsToUnits(box.width);
      _height.value = MainWindow.canvas.pixelsToUnits(box.height);
    } else {
      _width.parent.style.display = "none";
      _height.parent.style.display = "none";
    }
  }

  @override
  void clearModels() {}

  void _onDeleteClick(_) {
    _properties.deleteSelectedObjects();
  }
}
