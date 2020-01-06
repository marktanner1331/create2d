import 'dart:html';
import 'package:stagexl/stagexl.dart' as stageXL show Point;

import './ITool.dart';
import '../view/MainWindow.dart';

class PanTool extends ITool {
  PanTool() : super(document.querySelector("#toolbox #panTool"));

  @override
  String get tooltipText => "Pan";

  @override
  Iterable<stageXL.Point> getSnappablePoints() {
    return Iterable.empty();
  }

  @override
  void onEnter() {
  }

  @override
  void onExit() {
    MainWindow.stopPanningCanvas();
  }

  @override
  void onMouseDown(Point unsnappedMousePosition, Point snappedMousePosition) {
    super.onMouseDown(unsnappedMousePosition, snappedMousePosition);
    startPanning();
  }

  void startPanning() =>  MainWindow.startPanningCanvas();

  @override
  void onMouseMove(num x, num y) {}
}
