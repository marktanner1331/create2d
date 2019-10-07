import '../view/Canvas.dart';
import '../model/CanvasUnitType.dart';

mixin CanvasPropertiesMixin {
  Canvas get myCanvas;

  int _backgroundColor = 0xffffffff;
  int get backgroundColor => _backgroundColor;
  set backgroundColor(int value) {
    _backgroundColor = value;

    myCanvas.refreshCanvasBackground();
  }

  num _canvasWidth = 1000;
  num get canvasWidth => _canvasWidth;

  num _canvasHeight = 1000;
  num get canvasHeight => _canvasHeight;

  num _dpi = 72;
  num get dpi => _dpi;

  CanvasUnitType _units = CanvasUnitType.PIXEL;
  CanvasUnitType get units => _units;

  bool _maintainAspectRatio = true;
  bool get maintainAspectRatio => _maintainAspectRatio;

  bool _scaleContent = true;
  bool get scaleContent => _scaleContent;

  void setCanvasSize(num canvasWidth, num canvasHeight) {
    _canvasWidth = canvasWidth;
    _canvasHeight = canvasHeight;

    myCanvas.refreshCanvasBackground();
  }
}