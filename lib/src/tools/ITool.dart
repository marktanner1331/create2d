import '../view/Canvas.dart';

abstract class ITool {
  Canvas _canvas;
  Canvas get canvas => _canvas;

  ITool(Canvas canvas) {
    this._canvas = canvas;
  }

  //when set to true, the tool is active
  //it receives mouse updates from the canvas such as onMouseMove
  bool _isActive = false;
  bool get isActive => _isActive;

  void onMouseDown(num x, num y) {
    _isActive = true;
  }

  void onMouseUp(num x, num y) {
    _isActive = false;
  }

  //only called if _isActive is set to true
  void onMouseMove(num x, num y);
}