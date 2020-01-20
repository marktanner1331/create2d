import 'dart:html';
import 'dart:js';

import './MainWindow.dart';
import '../group_controllers/ZoomViewController.dart';
import '../group_controllers/CanvasSizeViewController.dart';
import '../helpers/AutoComplete.dart';

class CommandPalette {
  static HtmlElement _view;
  static TextInputElement _input;
  static DivElement _suggestedCommands;

  static AutoComplete _autoComplete;

  //a list of all registered command names and their parameters
  static Map<String, String> _commandToParameters;

  CommandPalette() {
    _autoComplete = AutoComplete();
    _commandToParameters = Map();

    _view = document.querySelector("#commandPalette");

    _input = _view.querySelector("input");
    _input.onKeyDown.listen(_onKeyPress);
    _input.onInput.listen(_onInputChanged);
    _input.addEventListener("focusout", (_) => _hide());

     _suggestedCommands = _view.querySelector("#suggestedCommands");

    _initializeContext();
  }

  static void _onInputChanged(_) {
    String command = _input.value;
    command = _removeParametersFromCommand(command);
    _refreshSuggestedCommandsWithPartial(command);
  }

  static void _initializeContext() {
    _addCommand("zoomIn", "()", MainWindow.zoomStepInAtCenter);
    _addCommand("zoomOut", "()", MainWindow.zoomStepOutAtCenter);
    _addCommand("setZoom", "(value:Number)", ZoomViewController.setZoomCommand);
    _addCommand("getZoom", "()", () => MainWindow.canvasZoom);
    _addCommand("resetZoom", "()", MainWindow.resetCanvasZoomAndPosition);
    _addCommand("getMaxZoom", "()", () => MainWindow.maxZoomMultiplier);
    _addCommand("setMaxZoom", "(value:Number)", ZoomViewController.setMaxZoomCommand);
    _addCommand("getZoomSteps", "()", () => MainWindow.zoomSteps);
    _addCommand("setZoomSteps", "(value:Number)", ZoomViewController.setZoomStepsCommand);

    _addCommand("getCanvasWidth", "()", () => MainWindow.canvas.canvasWidth);
    _addCommand("getCanvasHeight", "()", () => MainWindow.canvas.canvasWidth);
    _addCommand("setCanvasWidth", "(value:Number)", CanvasSizeViewController.setCanvasWidthCommand);
    _addCommand("setCanvasHeight", "(value:Number)", CanvasSizeViewController.setCanvasHeightCommand);
    _addCommand("setCanvasSize", "(width:Number, height:Number)", CanvasSizeViewController.setCanvasSizeCommand);
  }

  static void _onKeyPress(KeyboardEvent e) {
    switch (e.keyCode) {
      case KeyCode.ENTER:
        _onEnterPress();
        break;
      case KeyCode.DOWN:
        int index = _getSelectedCommandIndex();
        _setSelectedCommand(index + 1);
        break;
      case KeyCode.UP:
       _setSelectedCommand(_getSelectedCommandIndex() - 1);
        break;
      case KeyCode.ESC:
        _hide();
        break;
    }
  }

  ///returns a list of all possible commands including their parameter hints
  static List<String> _getAllCommands() {
    return _commandToParameters.keys.map((command) => command + _commandToParameters[command]).toList();
  }

  static void _onEnterPress() {
    String command = _input.value.trim();

    if(command == "") {
      _hide();
    } else if(RegExp(r"^.+?\(.*?\);?$").hasMatch(command)) {
      //we have a complete command, so run it
      _runCommand(command);
      _hide();
    } else {
      //otherwise, we autocomplete with a suggested command
      String suggestedCommand = _getSelectedCommand();
      if(suggestedCommand != null) {
        suggestedCommand = _removeParametersFromCommand(suggestedCommand);
        _input.value = suggestedCommand + "()";

        //set the text cursor inside the brackets
        int startOfParameters = suggestedCommand.length + 1;
        _input.selectionStart = startOfParameters;
        _input.selectionEnd = startOfParameters;

        _refreshSuggestedCommandsWithPartial(suggestedCommand);
      }
    }
  }

  //removes parameters including brackets
  static String _removeParametersFromCommand(String command) {
    int index = command.indexOf("(");
    if(index == -1) {
      return command;
    } else {
      return command.substring(0, index);
    }
  }

  //returns null if no matching commands can be found
  static String _getSelectedCommand() {
    DivElement suggestedCommand =
        _view.querySelector(".suggestedCommandSelected");
    if (suggestedCommand == null) {
      return null;
    } else {
      return suggestedCommand.text;
    }
  }

  //if no command is selected then -1 is returned
  static int _getSelectedCommandIndex() {
    DivElement selected =
        _suggestedCommands.querySelector(".suggestedCommandSelected");
  
    if(selected == null) {
      return -1;
    }

    return _suggestedCommands.children.indexOf(selected);
  }

  //this method will handle if we are going outside the bounds of the selected commands
  static void _setSelectedCommand(int index) {
    if(index < 0 || index >= _suggestedCommands.children.length) {
      return;
    }

    DivElement previouslySelected =
        _suggestedCommands.querySelector(".suggestedCommandSelected");

    if (previouslySelected != null) {
      previouslySelected.classes.remove("suggestedCommandSelected");
    }

    _suggestedCommands.children[index].classes.add("suggestedCommandSelected");
  }

  static void _refreshSuggestedCommandsWithPartial(String partial) {
    List<String> commands;
    if(partial == "") {
      commands = _getAllCommands();
    } else {
      commands = _autoComplete.getMatches(partial);
      commands = commands.map((command) => command + _commandToParameters[command]).toList();
    }

    _refreshSelectedCommandsWithCommands(commands);
  }

  static void _refreshSelectedCommandsWithCommands(List<String> commands) {
    _suggestedCommands.children.clear();

    if (commands.length > 0) {
      commands.sort();
      for (String command in commands) {
        _suggestedCommands.insertAdjacentHtml(
            "beforeEnd", "<div class=\"suggestedCommand\">$command</div>");
      }

      _setSelectedCommand(0);
    }
  }

  static void show() {
    _view.style.display = "block";
    _input.focus();
    _refreshSuggestedCommandsWithPartial("");
  }

  static void _hide() {
    _input.value = "";
    _suggestedCommands.children.clear();

    _view.style.display = "none";
  }

  ///commandName should not include the closing brackets, only the function name
  ///parameters should be a list of parameters that the function accepts, wrppaed in brackets, e.g. "(1)"
  static void _addCommand(String commandName, String parameters, dynamic callback) {
    _autoComplete.addWord(commandName);
    context[commandName] = callback;
    _commandToParameters[commandName] = parameters;
  }

  static void _runCommand(String command) {
    context.callMethod("eval", [command]);
  }
}
