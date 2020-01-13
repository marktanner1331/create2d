import 'dart:html';
import 'dart:js';
import 'dart:math';

import './MainWindow.dart';

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
    context["setZoom"] =
        (num value) => MainWindow.zoomInAtCenter(min(1, max(0, value)));
    context["getZoom"] = () => MainWindow.canvasZoom;
    context["resetZoom"] = MainWindow.resetCanvasZoomAndPosition;
    context["getMaxZoom"] = () => MainWindow.maxZoomMultiplier;
    context["setMaxZoom"] = _setMaxZoom;
    context["getZoomSteps"] = () => MainWindow.zoomSteps;
    context["setZoomSteps"] = (num value) {
       MainWindow.zoomSteps = value;
       MainWindow.propertyWindow.refreshCurrentTab();
    };
  }

  void _setMaxZoom(num value) {
      if (value == null || value < 1) {
        return;
      }

      num zoomMultiplier = MainWindow.zoomMultiplier;
      MainWindow.maxZoomMultiplier = value;

      //we keep track of the current zoom multiplier
      //so that the canvasZoom can be adjusted to invert changes to the maxZoomMultiplier
      //this gives the effect of the magnification not changing as the max zoom is updated
      MainWindow.setCanvasZoomFromZoomMultiplier(zoomMultiplier);

      MainWindow.propertyWindow.refreshCurrentTab();
  }

  void _onKeyPress(KeyboardEvent e) {
    if (e.keyCode == KeyCode.ENTER) {
      String command = _input.value;
      _runCommand(command);
    }
  }

  void _runCommand(String command) {}
}
