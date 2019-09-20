import 'package:stagexl/stagexl.dart';

import '../tools/LineTool.dart';
import '../tools/SelectTool.dart';
import '../tools/ITool.dart';
import '../widgets/ToolboxButton.dart';
import '../helpers/DraggableController.dart';

import '../property_windows/ContextProperties.dart';

import '../Styles.dart';

class Toolbox extends Sprite {
  static Toolbox _instance;
  static Toolbox get instance => _instance;
  
  static ITool _currentTool;
  static List<ITool> _tools;
  static Map<String, ToolboxButton> _buttons;

  Sprite _titleBar;
  DraggableController _draggableController;

  TextField _titleLabel;

  num _panelWidth = 50;
  num _panelHeight = 400;

  Toolbox() {
    assert(_instance == null);
    _instance = this;

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

    _tools = List();    
    _buttons = Map();

    _addTool(LineTool());
    _addTool(SelectTool());
  }

  static void selectFirstTool() {
    currentTool = _tools.first;
  }

  void _addTool(ITool tool) {
    int column = _tools.length & 1;
    int row = (_tools.length / 2).floor();
    num deltaY = _titleLabel.height + 10;

    ToolboxButton button = ToolboxButton(tool.getIcon())
      ..setSize(25, 25)
      ..x = column * 25
      ..y = deltaY + row * 25
      ..onMouseClick.listen((_) => currentTool = tool);
    addChild(button);

    _buttons[tool.name] = button;
    _tools.add(tool);
  }

  static ITool get currentTool => _currentTool;

  static void set currentTool(ITool value) {
    if(_currentTool != null) {
      _buttons[_currentTool.name].isSelected = false;
      _currentTool.onExit();
    }

    _currentTool = value;
    _buttons[_currentTool.name].isSelected = true;
    _currentTool.onEnter();

    ContextPropertiesWindow.currentObject = _currentTool;
  }
}
