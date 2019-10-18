import 'dart:html';
import './DraggablePropertyWindow.dart';

abstract class TabbedPropertyWindow extends DraggablePropertyWindow {
  Element _div;

  TabbedPropertyWindow(Element div) : super(div) {
    _div = div;

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