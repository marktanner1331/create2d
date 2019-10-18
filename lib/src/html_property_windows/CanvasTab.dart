import 'dart:html';

import './Tab.dart';
import './property_groups/CanvasSizeGroup.dart';
import './property_groups/GridGroup.dart';
import './property_groups/SnappingGroup.dart';
import '../view/MainWindow.dart';

class CanvasTab extends Tab {
  CanvasTab(Element div) : super(div) {
    CanvasSizeGroup(div.querySelector("#size"))
      ..myCanvasProperties = MainWindow.canvas
      ..open = true;

    GridGroup(div.querySelector("#grid"))
      ..myGridProperties = MainWindow.canvas
      ..open = true;

    SnappingGroup(div.querySelector("#snapping"))
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