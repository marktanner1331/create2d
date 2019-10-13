import 'dart:html';

import './Draggable.dart';

class Properties {
  Element _div;

  Properties() {
    _div = document.querySelector("#properties");
    Element titleBar = _div.querySelector(".title_bar");
    Draggable(_div, titleBar);

    List<Element> tabButtons = _div.querySelector(".tab_buttons").children;
    for(Element tabButton in tabButtons) {
      tabButton.onClick.listen(_onTabButtonClick);
    }

    _tabs.first.style.display = "block";
  }

  void _onTabButtonClick(MouseEvent e) {
    Element tabButton = e.currentTarget as Element;
    String targetTabID = tabButton.attributes["target"];

    for(Element tab in _tabs) {
      if(tab.id == targetTabID) {
        tab.style.display = "block";
      } else {
        tab.style.display = "none";
      }
    }
  }

  //returns a list of all tab elements
  List<Element> get _tabs => _div.querySelector(".tabs").children;
}