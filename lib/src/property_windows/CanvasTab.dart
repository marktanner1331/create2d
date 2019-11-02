import 'dart:html';

import './Tab.dart';
import '../group_controllers/CanvasSizeViewController.dart';
import '../group_controllers/GridViewController.dart';
import '../group_controllers/SnappingViewController.dart';
import '../group_controllers/UnitsViewController.dart';
import '../group_controllers/GroupController.dart';
import '../view/MainWindow.dart';

class CanvasTab extends Tab {
  List<GroupController> _controllers;

  CanvasTab(Element div) : super(div) {
    _controllers = List();

    _controllers.add(CanvasSizeViewController(div.querySelector("#size"))
      ..model = MainWindow.canvas
      ..open = true);

    _controllers.add(GridViewController(div.querySelector("#grid"))
      ..model = MainWindow.canvas
      ..open = true);

    _controllers.add(SnappingViewController(div.querySelector("#snapping"))
      ..model = MainWindow.canvas
      ..open = true);

    _controllers.add(UnitsViewController(div.querySelector("#units"))
      ..model = MainWindow.canvas
      ..open = true
      ..onUnitsChanged.listen(_onUnitsChanged));
  }

  void _onUnitsChanged(_) {
    for(GroupController controller in _controllers) {
      controller.refreshProperties();
    }
  }

  @override
  void onEnter() {
    for(GroupController controller in _controllers) {
      controller.onEnter();
    }
  }

  @override
  void onExit() {
    for(GroupController controller in _controllers) {
      controller.onExit();
    }
  }
}
