import '../view/Canvas.dart';

mixin CanvasPropertiesMixin {
  int _backgroundColor = 0xffffffff;
  int get backgroundColor => _backgroundColor;
  set backgroundColor(int value) {
    assert(this is Canvas);
    (this as Canvas).refreshCanvasBackground();
  }

  num _canvasWidth = 1000;
  num get canvasWidth => _canvasWidth;

  num _canvasHeight = 1000;
  num get canvasHeight => _canvasHeight;

  void setCanvasSize(num canvasWidth, num canvasHeight) {
    _canvasWidth = canvasWidth;
    _canvasHeight = canvasHeight;
    (this as Canvas).refreshCanvasBackground();
  }
}