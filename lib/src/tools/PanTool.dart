import 'dart:html';
import 'package:stagexl/stagexl.dart' as stageXL show Point;

import './ITool.dart';
import '../view/MainWindow.dart';

class ZoomTool extends ITool {
  ZoomTool() : super(document.querySelector("#toolbox #zoomTool"));

  @override
  String get tooltipText => "Zoom";

  @override
  Iterable<stageXL.Point> getSnappablePoints() {
    return Iterable.empty();
  }

  @override
  void onEnter() {
  }

  @override
  void onExit() {
  }

  @override
  void onMouseDown(Point unsnappedMousePosition, Point snappedMousePosition) {
    super.onMouseDown(unsnappedMousePosition, snappedMousePosition);
    MainWindow.zoomInAtPoint(unsnappedMousePosition);
  }

  @override
  void onMouseMove(num x, num y) {}
}
