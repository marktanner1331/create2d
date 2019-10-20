import 'package:stagexl/stagexl.dart';
import 'dart:html' as html;

import '../property_mixins/ContextPropertyMixin.dart';

abstract class ITool with ContextPropertyMixin {
  final html.Element view;

  ITool(this.view);

  //when set to true, the tool is active
  //it receives mouse updates from the canvas such as onMouseMove
  bool _isActive = false;
  bool get isActive => _isActive;
  
  void onMouseDown(Point unsnappedMousePosition, Point snappedMousePosition) {
    _isActive = true;
  }

  void onMouseUp(num x, num y) {
    _isActive = false;
  }

  //only called if _isActive is set to true
  void onMouseMove(num x, num y);

  void onEnter();
  void onExit();

  String get tooltipText;
}