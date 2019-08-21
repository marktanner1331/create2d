import 'package:stagexl/stagexl.dart';

import '../property_mixins/ContextPropertyMixin.dart';

abstract class ITool with ContextPropertyMixin {
  //when set to true, the tool is active
  //it receives mouse updates from the canvas such as onMouseMove
  bool _isActive = false;
  bool get isActive => _isActive;

  DisplayObject getIcon();

  void onMouseDown(num x, num y) {
    _isActive = true;
  }

  void onMouseUp(num x, num y) {
    _isActive = false;
  }

  //only called if _isActive is set to true
  void onMouseMove(num x, num y);
}