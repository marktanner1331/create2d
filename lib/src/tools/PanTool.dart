import 'dart:collection';
import 'dart:html';
import 'package:stagexl/stagexl.dart' as stageXL show Point;

import './ITool.dart';
import '../view/MainWindow.dart';
import '../group_controllers/pANViewController.dart';
import '../group_controllers/ContextController.dart';

class PanTool extends ITool {
  PanTool() : super(document.querySelector("#toolbox #panTool"));

  @override
  String get tooltipText => "Pan";

  @override
  Iterable<stageXL.Point> getSnappablePoints() {
    return Iterable.empty();
  }

  @override
  HashSet<ContextController> registerAndReturnViewControllers() {
    return super.registerAndReturnViewControllers()
      ..add(PanViewController.instance);
  }

  @override
  void onEnter() {
    MainWindow.startPanningCanvas();
  }

  @override
  void onExit() {
    MainWindow.stopPanningCanvas();
  }

  @override
  void onMouseDown(Point unsnappedMousePosition, Point snappedMousePosition) {
    super.onMouseDown(unsnappedMousePosition, snappedMousePosition);
  }
  
  @override
  void onMouseMove(num x, num y) {}
}
