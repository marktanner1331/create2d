import 'dart:html';
import 'dart:js';

import './MainWindow.dart';
import '../group_controllers/ZoomViewController.dart';

class CommandPalette {
  HtmlElement _view;
  TextInputElement _input;

  CommandPalette() {
    _view = document.querySelector("#commandPalette");
    _input = _view.querySelector("input");
    _input.onKeyPress.listen(_onKeyPress);

    _initializeContext();
  }

  void _initializeContext() {
    context["zoomIn"] = MainWindow.zoomStepInAtCenter;
    context["zoomOut"] = MainWindow.zoomStepOutAtCenter;
    context["setZoom"] = ZoomViewController.setZoomCommand;
    context["getZoom"] = () => MainWindow.canvasZoom;
    context["resetZoom"] = MainWindow.resetCanvasZoomAndPosition;
    context["getMaxZoom"] = () => MainWindow.maxZoomMultiplier;
    context["setMaxZoom"] = ZoomViewController.setMaxZoomCommand;
    context["getZoomSteps"] = () => MainWindow.zoomSteps;
    context["setZoomSteps"] = ZoomViewController.setZoomStepsCommand;
  }

  void _onKeyPress(KeyboardEvent e) {
    if (e.keyCode == KeyCode.ENTER) {
      String command = _input.value;
      _runCommand(command);
    }
  }

  void _runCommand(String command) {}
}
