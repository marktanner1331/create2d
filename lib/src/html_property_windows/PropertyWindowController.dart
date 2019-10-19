import 'dart:html';

import './CanvasTab.dart';
import './ContextTab.dart';
import './Draggable.dart';
import './TabController.dart';
import './HTMLViewController.dart';

class PropertyWindowController with HTMLViewController {
  final Element view;

  PropertyWindowController(this.view) {
    Draggable(view, view.querySelector(".title_bar"));

    TabController()
      ..addTab(view.querySelector("#canvasTabButton"), view.querySelector("#canvasTab"))
      ..addTab(view.querySelector("#contextTabButton"), view.querySelector("#contextTab"));

    CanvasTab(view.querySelector("#canvasTab"));
    ContextTab(view.querySelector("#contextTab"));
  }
}