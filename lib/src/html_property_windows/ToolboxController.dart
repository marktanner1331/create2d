import 'dart:html';

import './Draggable.dart';
import './HTMLViewController.dart';
import '../tools/ITool.dart';
import './ContextTab.dart';
import '../view/TooltipController.dart';
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

    _addTool(LineTool(view.querySelector("#lineTool")));
    _addTool(SelectTool(view.querySelector("#selectTool")));
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

  ITool get currentTool => _currentTool;

  void set currentTool(ITool value) {
    if(_currentTool != null) {
      _currentTool.view.classes.remove("tool_button_selected");
      _currentTool.onExit();
    }
    
    _currentTool = value;
    
    _currentTool.view.classes.add("tool_button_selected");
    _currentTool.onEnter();
    
    ContextTab.currentObject = _currentTool;
  }
}