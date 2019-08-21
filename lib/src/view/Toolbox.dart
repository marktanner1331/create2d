import 'package:stagexl/stagexl.dart';

import '../tools/LineTool.dart';
import '../tools/ITool.dart';
import '../widgets/ToolboxButton.dart';
import '../helpers/DraggableController.dart';

import '../property_windows/ContextProperties.dart';

import '../Styles.dart';

class Toolbox extends Sprite {
  static Toolbox _instance;
  static Toolbox get instance => _instance;
  static ITool _currentTool;
  static Map<String, ToolboxButton> _buttons;

  static LineTool _line;

  Sprite _titleBar;
  DraggableController _draggableController;

  TextField _titleLabel;

  num _panelWidth = 50;
  num _panelHeight = 400;

  Toolbox() {
    assert(_instance == null);
    _instance = this;

    _buttons = Map();

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

  static void selectFirstTool() {
    currentTool = _line;
  }

  ToolboxButton _addButtonForTool(ITool tool) {
    ToolboxButton button = ToolboxButton(tool.getIcon());
    
    button.setSize(25, 25);
    addChild(button);

    _buttons[tool.name] = button;

    return button;
  }

  static ITool get currentTool => _currentTool;

  static void set currentTool(ITool value) {
    if(_currentTool != null) {
      _buttons[_currentTool.name].isSelected = false;
    }

    _currentTool = value;
    _buttons[_currentTool.name].isSelected = true;

    ContextPropertiesWindow.currentObject = _currentTool;
  }
}
