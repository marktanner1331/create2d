import 'dart:html';

import './Tab.dart';
import '../group_controllers/CanvasSizeViewController.dart';
import '../group_controllers/GridViewController.dart';
import '../group_controllers/SnappingViewController.dart';
import '../view/MainWindow.dart';

class CanvasTab extends Tab {
  CanvasTab(Element div) : super(div) {
    CanvasSizeViewController(div.querySelector("#size"))
      ..myCanvasProperties = MainWindow.canvas
      ..open = true;

    GridViewController(div.querySelector("#grid"))
      ..myGridProperties = MainWindow.canvas
      ..open = true;

    SnappingViewController(div.querySelector("#snapping"))
      ..mySnappingProperties = MainWindow.canvas
      ..open = true;
  }

  @override
  void onEnter() {
  }

  @override
  void onExit() {
  }
}