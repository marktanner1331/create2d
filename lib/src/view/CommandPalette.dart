import 'dart:html';

class CommandPalette {
  HtmlElement _view;
  TextInputElement _input;

  CommandPalette() {
    _view = document.querySelector("#commandPalette");
    _input = _view.querySelector("input");
    _input.onKeyPress.listen(_onKeyPress);
  }

  void _onKeyPress(KeyboardEvent e) {
    if(e.keyCode == KeyCode.ENTER) {
      String command = _input.value;
      _runCommand(command);
    }
  }

  void _runCommand(String command) {

  }
}