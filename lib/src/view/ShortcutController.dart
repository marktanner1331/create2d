import 'dart:html';
import 'dart:js';

import './MainWindow.dart';
import '../tools/PanTool.dart';

class ShortcutController {
  bool shiftIsDown = false;

  //the interactive object passed in must be added to the stage at some point
  ShortcutController() {
    context["onKeyDown"] = _onKeyDown;
    context["onKeyUp"] = _onKeyUp;
  }

  bool _onKeyDown(KeyboardEvent e) {
    shiftIsDown = e.shiftKey;

    switch(e.keyCode) {
      case KeyCode.ENTER:
        if(e.ctrlKey) {
          MainWindow.resetCanvasZoomAndPosition();
        }
        break;
      case KeyCode.EQUALS:
        if(e.ctrlKey) {
          MainWindow.zoomStepInAtCenter();
        }
        break;
      case KeyCode.DASH:
        if(e.ctrlKey) {
          MainWindow.zoomStepOutAtCenter();
        }
        break;
      case KeyCode.SPACE:
        MainWindow.toolbox.temporarilySwitchToTool<PanTool>();
        //MainWindow.toolbox.panTool.startPanning();
        break;
    }

    return false;
  }

  bool _onKeyUp(KeyboardEvent e) {
    shiftIsDown = e.shiftKey;

    switch(e.keyCode) {
      case KeyCode.SPACE:
        MainWindow.toolbox.endTemporaryTool();
        break;
    }

    return false;
  }
}