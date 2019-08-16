import 'package:stagexl/stagexl.dart';

import '../tools/LineTool.dart';
import '../tools/ITool.dart';
import '../widgets/ToolboxButton.dart';
import '../helpers/DraggableController.dart';

import '../Styles.dart';

class Toolbox extends Sprite {
  Sprite _titleBar;
  DraggableController _draggableController;

  TextField _titleLabel;

  LineTool _line;

  num _panelWidth = 50;
  num _panelHeight = 400;

  Toolbox() {
    _titleBar = Sprite()..mouseCursor = MouseCursor.POINTER;
    addChild(_titleBar);

    _draggableController = DraggableController(this, _titleBar);

    _titleLabel = TextField()
      ..x = 5
      ..y = 2
      ..text = "Toolbox"
      ..textColor = Styles.panelHeadText
      ..mouseEnabled = false
      ..autoSize = TextFieldAutoSize.NONE;

    _titleLabel
      ..width = _titleLabel.textWidth
      ..height = _titleLabel.textHeight;

    addChild(_titleLabel);

    graphics
      ..clear()
      ..beginPath()
      ..rect(0, 0, _panelWidth, _panelHeight)
      ..fillColor(Styles.panelBG)
      ..closePath();

    num deltaY = _titleLabel.height + 5;

    _titleBar.graphics
      ..beginPath()
      ..rect(0, 0, _panelWidth, deltaY)
      ..fillColor(Styles.panelHeadBG)
      ..closePath();

    deltaY += 5;

    _line = LineTool();
    _addButtonForTool(_line)..y = deltaY;
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
