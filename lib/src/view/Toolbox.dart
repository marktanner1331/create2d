import 'package:stagexl/stagexl.dart';

import '../tools/LineTool.dart';
import '../tools/ITool.dart';
import '../widgets/ToolboxButton.dart';

import '../Styles.dart';

class Toolbox extends Sprite {
 LineTool _line;
  
  Toolbox() {
    _line = LineTool();
    _addButtonForTool(_line);

    graphics
      ..clear()
      ..beginPath()
      ..rect(0, 0, 50, 400)
      ..fillColor(Styles.panelBG)
      ..closePath();
  }

  ToolboxButton _addButtonForTool(ITool tool) {
    ToolboxButton button = ToolboxButton(tool.getIcon());
    
    button.setSize(25, 25);
    addChild(button);

    return button;
  }

  ITool get currentTool {
    return _line;
  }
}