import 'dart:collection';
import 'dart:html';
import 'package:stagexl/stagexl.dart' as stageXL show Point;

import './ITool.dart';
import '../view/MainWindow.dart';
import '../group_controllers/ZoomViewController.dart';
import '../group_controllers/ContextController.dart';

class ZoomTool extends ITool {
  ZoomTool() : super(document.querySelector("#toolbox #zoomTool"));

  @override
  String get tooltipText => "Zoom";

  @override
  Iterable<stageXL.Point> getSnappablePoints() {
    return Iterable.empty();
  }

  @override
  HashSet<ContextController> registerAndReturnViewControllers() {
    return super.registerAndReturnViewControllers()
      ..add(ZoomViewController.instance);
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
