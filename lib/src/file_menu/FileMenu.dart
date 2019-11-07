import 'dart:html';
import 'dart:async';

import '../view/MainWindow.dart';

class FileMenu  {
  Element _view;
  List<StreamSubscription> _mouseOverButtonSubscriptions;
  StreamSubscription _documentClickSubscription;
  bool _isOpen = false;
  bool _initialized = false;

  CheckboxInputElement _showPropertiesCheckbox;

  FileMenu() {
    _view = document.querySelector("#fileMenu");

    for (Element button in _view.getElementsByClassName("file_menu_button")) {
      button.onClick.listen(_onFileButtonClick);
    }
  }

  int get height => _view.clientHeight;

  void _closeAllMenus() {
    for (Element button in _view.getElementsByClassName("file_menu_button")) {
      button.classes.remove("file_menu_button_selected");
    }

    for (Element child in _view.getElementsByClassName("file_menu_items")) {
      child.style.display = "none";
    }
  }

  void _onFileButtonClick(MouseEvent e) {
    if(_isOpen) {
      return;
    }

    e.stopImmediatePropagation();

    if(_initialized == false) {
      _initialize();
    }

    _refreshItems();

    _isOpen = true;
    _closeAllMenus();
    
    Element button = e.currentTarget as Element;
    button.classes.add("file_menu_button_selected");

    Element items = button.parent.querySelector(".file_menu_items");
    items.style.display = "grid";

    _mouseOverButtonSubscriptions = List();
    for (Element button in _view.getElementsByClassName("file_menu_button")) {
      _mouseOverButtonSubscriptions
          .add(button.onMouseOver.listen(_onMouseOverButton));
    }

    _documentClickSubscription = document.onClick.listen(_onDocumentClick);
  }

  void _refreshItems() {
    _showPropertiesCheckbox.checked = MainWindow.propertyWindow.visible;
  }

  void _initialize() {
    _initialized = true;

    _view.querySelector("#showProperties").onClick.listen((_) {
      MainWindow.propertyWindow.visible = !MainWindow.propertyWindow.visible;
    });

    _showPropertiesCheckbox = _view.querySelector("#showProperties > input");
  }

  void _onDocumentClick(_) {
    _closeAllMenus();
    _isOpen = false;

    for(StreamSubscription subscription in _mouseOverButtonSubscriptions) {
      subscription.cancel();
    }
    _mouseOverButtonSubscriptions.clear();

    _documentClickSubscription.cancel();
    _documentClickSubscription = null;
  }

  void _onMouseOverButton(MouseEvent e) {
    _closeAllMenus();

    Element button = e.currentTarget as Element;
    button.classes.add("file_menu_button_selected");

    Element items = button.parent.querySelector(".file_menu_items");
    items.style.display = "grid";
  }
}
