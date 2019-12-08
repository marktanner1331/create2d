import 'dart:html' as html;
import 'package:meta/meta.dart';
import 'package:stagexl/stagexl.dart' show Point;

import '../property_mixins/IHavePropertyMixins.dart';

abstract class ITool extends IHavePropertyMixins {
  final html.Element view;

  bool _isActive = false;

  //when set to true, the tool is active
  //it receives mouse updates from the canvas such as onMouseMove
  ITool(this.view);
  bool get isActive => _isActive;
  
  String get tooltipText;

  void contextPropertiesHaveChanged();

  //only called if _isActive is set to true
  Iterable<Point> getSnappablePoints();

  void onEnter();
  void onExit();

  @mustCallSuper
 void onMouseDown(Point unsnappedMousePosition, Point snappedMousePosition) {
    _isActive = true;
  } 

  void onMouseMove(num x, num y);

  void onMouseUp(num x, num y) {
    _isActive = false;
  }
}