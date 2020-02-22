import 'dart:async';
import 'dart:html';
import 'dart:js';

import './MainWindow.dart';
import './CommandPalette.dart';
import '../tools/PanTool.dart';

class ShortcutController {
  bool shiftIsDown = false;

  String _multiKeyCommand = "";

  Timer _multiKeyTimer;

  //the interactive object passed in must be added to the stage at some point
  ShortcutController() {
    context["onKeyDown"] = _onKeyDown;
    context["onKeyUp"] = _onKeyUp;
  }

  bool _onKeyDown(KeyboardEvent e) {
    //resetting the multi key shortcut right at the top
    //means that if the user is inside a text field
    //then everything gets cleaned
    String newMultiKeyCommand = _multiKeyCommand + e.key;
   _multiKeyCommand = "";

    if(e.target is TextInputElement) {
      return true;
    }

    shiftIsDown = e.shiftKey;

    bool didProcessShortcut = true;

    switch(e.keyCode) {
      case KeyCode.DASH:
        if(e.ctrlKey) {
          MainWindow.zoomStepOutAtCenter();
        }
        break;
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
      case KeyCode.Q:
        if(e.ctrlKey) {
          CommandPalette.show();
        }
        break;
      case KeyCode.SPACE:
        MainWindow.toolbox.temporarilySwitchToTool<PanTool>();
        break;
      default:
        didProcessShortcut = false;
    }

    //if we processed the shortcut then we shouldn't try and process it 
    //as a multi key shortcut
    if(didProcessShortcut) {
      return false;
    }

    //need to start a timer here to clear the command after a little bit
    if(_multiKeyTimer != null) {
      _multiKeyTimer.cancel();
    }

    _multiKeyTimer = Timer(Duration(seconds: 1), () {
      _multiKeyCommand = "";
    });

    //multi key shortcuts are 2 characters
    //if we have more than that then we only take the last 2
    if(newMultiKeyCommand.length > 2) {
      newMultiKeyCommand = newMultiKeyCommand.substring(newMultiKeyCommand.length - 2);
    }

    //print("newMultiKeyCommand: " + newMultiKeyCommand);

    if(MainWindow.toolbox.hasToolWithShortName(newMultiKeyCommand)) {
      MainWindow.toolbox.switchToToolWithShortName(newMultiKeyCommand);
      return false;
    }

    _multiKeyCommand = newMultiKeyCommand;

    return false;
  }

  bool _onKeyUp(KeyboardEvent e) {
    if(e.target is TextInputElement) {
      return true;
    }

    shiftIsDown = e.shiftKey;

    switch(e.keyCode) {
      case KeyCode.SPACE:
        MainWindow.toolbox.endTemporaryTool();
        break;
    }

    return false;
  }
}