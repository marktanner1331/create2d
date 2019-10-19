import 'dart:html';

import './Draggable.dart';
import './HTMLViewController.dart';
import '../tools/ITool.dart';
import './ContextTab.dart';

import '../tools/LineTool.dart';
import '../tools/SelectTool.dart';

class ToolboxController with HTMLViewController {
  final Element view;

  ITool _currentTool;
  List<ITool> _tools = List();

  ToolboxController(this.view) {
    Draggable(view, view.querySelector(".title_bar"));

    for(Element button in view.getElementsByClassName("tool_button")) {
      button.onClick.listen(_onButtonClick);
    }

    _tools.add(LineTool());
    _tools.add(SelectTool());
  }

  void _onButtonClick(MouseEvent e) {
    String id =  (e.currentTarget as Element).id;
    currentTool = _tools.firstWhere((tool) => tool.id == id);
  }

  void selectFirstTool() {
    currentTool = _tools.first;
  }

  ITool get currentTool => _currentTool;

  void set currentTool(ITool value) {
    if(_currentTool != null) {
      view.querySelector("#" + _currentTool.id).classes.remove("tool_button_selected");
      _currentTool.onExit();
    }
    
    _currentTool = value;
    
    view.querySelector("#" + _currentTool.id).classes.add("tool_button_selected");
    _currentTool.onEnter();
    
    ContextTab.currentObject = _currentTool;
  }
}