import 'dart:html';

import '../helpers/Draggable.dart';
import '../helpers/HTMLViewController.dart';
import '../property_windows/ContextTab.dart';
import '../view/TooltipController.dart';
import './ITool.dart';
import './LineTool.dart';
import './SelectTool.dart';
import './ZoomTool.dart';
import './PanTool.dart';
import './TextTool.dart';

class ToolboxController with HTMLViewController {
  final Element view;

  //holds a reference to temporarily selected tools
  //see temporarilySwitchToTool() for more
  ITool _tempTool;

  ITool _currentTool;

  List<ITool> _tools = List();

  SelectTool _selectTool;
  SelectTool get selectTool => _selectTool;

  PanTool _panTool;
  PanTool get panTool => _panTool;

  ToolboxController(this.view) {
    Draggable(view, view.querySelector(".title_bar"));

    for(Element button in view.getElementsByClassName("tool_button")) {
      button.onClick.listen(_onButtonClick);
    }

    _addTool(LineTool());
    _addTool(_selectTool = SelectTool());
    _addTool(TextTool());
    _addTool(PanTool());
    _addTool(ZoomTool());
  }

  void temporarilySwitchToTool<T extends ITool>() {
    if(currentTool is T) {
      return;
    }

    currentTool.onSuspend();

    _tempTool = _findTool<T>();

    _tempTool.onEnter();
    _tempTool.view.classes.add("tool_button_selected");
  }

  bool hasToolWithShortName(String shortName) {
    shortName = shortName.toLowerCase();
    return _tools.any((x) => x.shortName.toLowerCase() == shortName);
  }

  void endTemporaryTool() {
    if(_tempTool == null) {
      return;
    }

    _tempTool.onExit();
    _tempTool.view.classes.remove("tool_button_selected");
    _tempTool = null;

    _currentTool.onResume();
  }

  ITool _findTool<T extends ITool>() {
    for(ITool tool in _tools) {
      if(tool is T) {
        return tool;
      }
    }
  }

  void _addTool(ITool tool) {
    _tools.add(tool);
    TooltipController.addHTMLTooltip(tool.view, tool.tooltipText);
  }

  void _onButtonClick(MouseEvent e) {
    String id =  (e.currentTarget as Element).id;
    currentTool = _tools.firstWhere((tool) => tool.view.id == id);
  }

  void selectFirstTool() {
    currentTool = _tools.first;
  }

  void switchToToolWithShortName(String shortName) {
    shortName = shortName.toLowerCase();

    if(currentTool.shortName.toLowerCase() == shortName) {
      return;
    }

    for(ITool tool in _tools) {
      if(tool.shortName.toLowerCase() == shortName) {
        currentTool = tool;
        break;
      }
    }
  }

  void switchToTool<T extends ITool>() {
    if(currentTool is T) {
      return;
    }

    for(ITool tool in _tools) {
      if(tool is T) {
        currentTool = tool;
        break;
      }
    }
  }

  ITool get currentTool => _tempTool ?? _currentTool;

  void set currentTool(ITool value) {
    if(_currentTool != null) {
      _currentTool.view.classes.remove("tool_button_selected");
      _currentTool.onExit();
    }
    
    _currentTool = value;
    
    _currentTool.view.classes.add("tool_button_selected");
    _currentTool.onEnter();

    _tempTool = null;
    
    ContextTab.refreshContext();
  }
}