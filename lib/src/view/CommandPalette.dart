import 'dart:html';
import 'dart:js';
import 'dart:math';

import './MainWindow.dart';
import '../group_controllers/ZoomViewController.dart';
import '../helpers/AutoComplete.dart';

class CommandPalette {
  static HtmlElement _view;
  static TextInputElement _input;
  AutoComplete _autoComplete;

  //a list of all registered command names and their parameters
  Map<String, String> _commandToParameters;

  CommandPalette() {
    _autoComplete = AutoComplete();
    _commandToParameters = Map();

    _view = document.querySelector("#commandPalette");
    _input = _view.querySelector("input");
    _input.onKeyDown.listen(_onKeyPress);
    _input.onInput.listen((_) => _refreshSuggestedCommandsWithPartial(_input.value));
    _input.addEventListener("focusout", (_) => _hide());

    _initializeContext();
  }

  void _initializeContext() {
    _addCommand("zoomIn", "()", MainWindow.zoomStepInAtCenter);
    _addCommand("zoomOut", "()", MainWindow.zoomStepOutAtCenter);
    _addCommand("setZoom", "(value:Number)", ZoomViewController.setZoomCommand);
    _addCommand("getZoom", "()", () => MainWindow.canvasZoom);
    _addCommand("resetZoom", "()", MainWindow.resetCanvasZoomAndPosition);
    _addCommand("getMaxZoom", "()", () => MainWindow.maxZoomMultiplier);
    _addCommand("setMaxZoom", "(value:Number)", ZoomViewController.setMaxZoomCommand);
    _addCommand("getZoomSteps", "()", () => MainWindow.zoomSteps);
    _addCommand("setZoomSteps", "(value:Number)", ZoomViewController.setZoomStepsCommand);
  }

  void _onKeyPress(KeyboardEvent e) {
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
  List<String> _getAllCommands() {
    List<String> commands = _commandToParameters.keys.toList();
    commands.sort();

    return commands.map((command) => _commandToParameters[command]).toList();
  }

  void _onEnterPress() {
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

  String _removeParametersFromCommand(String command) {
    return command.replaceFirst(RegExp(r"\(.*?\)"), "()");
  }

  //returns null if no matching commands can be found
  String _getSelectedCommand() {
    DivElement suggestedCommand =
        _view.querySelector(".suggestedCommandSelected");
    if (suggestedCommand == null) {
      return null;
    } else {
      return suggestedCommand.text;
    }
  }

  //if no command is selected then -1 is returned
  int _getSelectedCommandIndex() {
    //TODO move this to an instance variable
    DivElement suggestedCommands = _view.querySelector("#suggestedCommands");

    DivElement selected =
        suggestedCommands.querySelector(".suggestedCommandSelected");
  
    if(selected == null) {
      return -1;
    }

    return suggestedCommands.children.indexOf(selected);
  }

  //this method will handle if we are going outside the bounds of the selected commands
  void _setSelectedCommand(int index) {
    DivElement suggestedCommands = _view.querySelector("#suggestedCommands");
    if(index < 0 || index >= suggestedCommands.children.length) {
      return;
    }

    DivElement previouslySelected =
        suggestedCommands.querySelector(".suggestedCommandSelected");

    if (previouslySelected != null) {
      previouslySelected.classes.remove("suggestedCommandSelected");
    }

    suggestedCommands.children[index].classes.add("suggestedCommandSelected");
  }

  void _refreshSuggestedCommandsWithPartial(String partial) {
    List<String> commands;
    if(partial == "") {
      commands = _getAllCommands();
    } else {
      commands = _autoComplete.getMatches(partial);
      commands = commands.map((command) => command + _commandToParameters[command]).toList();
    }

    _refreshSelectedCommandsWithCommands(commands);
  }

  void _refreshSelectedCommandsWithCommands(Iterable<String> commands) {
    DivElement suggestedCommands = _view.querySelector("#suggestedCommands");
    suggestedCommands.children.clear();

    if (commands.length > 0) {
      for (String command in commands) {
        suggestedCommands.insertAdjacentHtml(
            "beforeEnd", "<div class=\"suggestedCommand\">$command</div>");
      }

      _setSelectedCommand(0);
    }
  }

  static void show() {
    _view.style.display = "block";
    _input.focus();
  }

  void _hide() {
    _input.value = "";
    DivElement suggestedCommands = _view.querySelector("#suggestedCommands");
    suggestedCommands.children.clear();

    _view.style.display = "none";
  }

  ///commandName should not include the closing brackets, only the function name
  ///parameters should be a list of parameters that the function accepts, wrppaed in brackets, e.g. "(1)"
  void _addCommand(String commandName, String parameters, dynamic callback) {
    _autoComplete.addWord(commandName);
    context[commandName] = callback;
    _commandToParameters[commandName] = parameters;
  }

  void _runCommand(String command) {
    context.callMethod("eval", [command]);
  }
}
