import 'dart:html' show KeyCode;
import 'package:stagexl/stagexl.dart';

import './MainWindow.dart';
import '../tools/PanTool.dart';

class ShortcutController {
  bool shiftIsDown = false;

  //the interactive object passed in must be added to the stage at some point
  ShortcutController(InteractiveObject interactiveObject) {
    interactiveObject.onKeyDown.listen(_onKeyDown);
    interactiveObject.onKeyUp.listen(_onKeyUp);

    if(interactiveObject.stage != null) {
      interactiveObject.stage.focus = interactiveObject;
    }

    interactiveObject.onAddedToStage.listen((_) {
      interactiveObject.stage.focus = interactiveObject;
    });
  }

  void _onKeyDown(KeyboardEvent e) {
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
      case KeyCode.NUM_MINUS:
        if(e.ctrlKey) {
          MainWindow.zoomStepOutAtCenter();
        }
        break;
      case KeyCode.SPACE:
        MainWindow.toolbox.temporarilySwitchToTool<PanTool>();
        //MainWindow.toolbox.panTool.startPanning();
        break;
    }
  }

  void _onKeyUp(KeyboardEvent e) {
    shiftIsDown = e.shiftKey;

    switch(e.keyCode) {
      case KeyCode.SPACE:
        MainWindow.toolbox.endTemporaryTool();
        break;
    }
  }
}