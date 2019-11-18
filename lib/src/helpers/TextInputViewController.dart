import 'dart:html';

class TextInputViewController {
  InputElement _view;
   Function(String) _onTextInput;

   bool _suspend = false;
   String mostRecentText = null;

  TextInputViewController(String selector, Function(String) onTextInput) {
    this._onTextInput = onTextInput;

    _view = document.querySelector(selector) as InputElement;
    _view.onInput.listen(_onInput);
    _view.addEventListener("focusout", _onFocusOut);
  }

  String get value => _view.value;

  void set value(String s) {
    if(_suspend == false) {
      _view.value = s;
    } else {
      mostRecentText = s;
    }
  }

  void _onFocusOut(_) {
    if(mostRecentText != null) {
      _view.value = mostRecentText;
      mostRecentText = null;
    }
  }

  void _onInput(_) {
    _suspend = true;
    _onTextInput(_view.value);
    _suspend = false;
  }
}